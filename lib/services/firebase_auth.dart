import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:key_testing/model/user.dart';
import 'package:key_testing/provider/notifications_layer_provider.dart';
import 'package:key_testing/services/firebase_database.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseAuthService _instance = FirebaseAuthService._();

  factory FirebaseAuthService() => _instance;

  FirebaseAuthService._();

  static Timer _emailVerificationWatcher;

  static Stream<User> get stream => _auth.userChanges();

  static User get authorizedFirebaseUser => _auth.currentUser;

  static KeyUser get authorizedUser {
    FirebaseDatabaseService.getUserByEmail(authorizedFirebaseUser?.email)
        .then((keyUser) {
      return keyUser;
    });

    return null;
  }

  static Future<KeyUser> signInWithEmailAndPassword(
    String email,
    String password,
    VoidCallback successCallback,
  ) async {
    try {
      var credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      var keyUser = await FirebaseDatabaseService.getUserByEmail(email);

      if (credentials.user.emailVerified == false) {
        await verifyEmail(true, successCallback);
      } else {
        successCallback();
      }
      return keyUser;
    } on FirebaseAuthException catch (e) {
      String errText = "";
      if (e.code == 'user-not-found') {
        errText = 'Пользователь с таким адресом не существует';
      } else if (e.code == 'wrong-password') {
        errText = 'Неправильный пароль';
      } else {
        errText = "Ошибка входа: ${e.code}";
      }

      _showError(errText);
    }

    return null;
  }

  static Future signOut() async {
    await _auth.signOut();
  }

  static Future<KeyUser> registerWithEmailAndPassword(
    String email,
    String password,
    VoidCallback onEmailVerificationCallback,
  ) async {
    try {
      var firebaseCredentials = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      var keyUser =
          await FirebaseDatabaseService.createUser(firebaseCredentials.user);
      if (firebaseCredentials?.user?.emailVerified == false) {
        await verifyEmail(false, onEmailVerificationCallback);
      }

      return keyUser;
    } on FirebaseAuthException catch (e) {
      String errText = "";
      if (e.code == 'weak-password') {
        errText = 'Пароль слишком слабый';
      } else if (e.code == 'email-already-in-use') {
        errText = 'Аккаунт с таким адресом уже существует';
      } else {
        errText = "Ошибка: ${e.code}";
      }

      _showError(errText);
    }

    return null;
  }

  /// sending verification link and setting up periodic timer for constantly checking for confirmation
  /// we are using [Timer] because [Stream userChanges] from firebase lib doesn't notify about verification
  static Future<bool> verifyEmail([
    bool fromLogin = false,
    VoidCallback onVerificationPassed,
  ]) async {
    try {
      await _auth.currentUser.sendEmailVerification();
      await _watchEmailVerification(onVerificationPassed);
      return true;
    } on FirebaseAuthException catch (e) {
      String errText = "";
      if (e.code == "too-many-requests") {
        if (fromLogin) {
          await _watchEmailVerification(onVerificationPassed);
          return false;
        }
        errText = "Подождите немного! Вы шлёте слишком много запросов";
      } else {
        errText = "Ошибка при отправке кода валидации: ${e.code}";
      }

      _showError(errText);
    }

    return false;
  }

  /// Manually listening for email link verification because
  /// [stream] doesn't provide automatic updates regarding email verification status
  /// executing [onVerifiedCallback] upon successful verification
  static Future _watchEmailVerification(
      [VoidCallback onVerifiedCallback]) async {
    _emailVerificationWatcher?.cancel();
    _emailVerificationWatcher = Timer(Duration(seconds: 1),
        () => _watchEmailVerification(onVerifiedCallback));

    if (_auth.currentUser == null) {
      _emailVerificationWatcher.cancel();
      return;
    }

    await _auth.currentUser.reload();
    if (_auth.currentUser.emailVerified) {
      _emailVerificationWatcher.cancel();
      if (onVerifiedCallback != null) onVerifiedCallback();
      return;
    }
  }

  static void _showError(String text) {
    NotificationsLayerProvider().showNotification(
      NotificationElement(
        type: NotificationType.error,
        text: text,
        duration: Duration(milliseconds: 1750),
      ),
    );
  }
}
