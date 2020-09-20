import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:key_testing/provider/notifications_layer_provider.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseAuthService _instance = FirebaseAuthService._();

  factory FirebaseAuthService() => _instance;

  FirebaseAuthService._();

  static Timer _emailVerificationWatcher;

  static Stream<User> get stream => _auth.userChanges();

  static User get authorizedUser => _auth.currentUser;

  static bool get isAwaitingForEmailVerification =>
      (_emailVerificationWatcher?.isActive ?? false);

  static Future<User> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      var credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credentials.user.emailVerified == false) {
        await verifyEmail(true);
      }
      return credentials.user;
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

  static Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result?.user?.emailVerified == false) {
        await verifyEmail();
      }
      return result;
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
  static Future<bool> verifyEmail([bool fromLogin = false]) async {
    try {
      await _auth.currentUser.sendEmailVerification();
      await _watchEmailVerification();
      return true;
    } on FirebaseAuthException catch (e) {
      String errText = "";
      if (e.code == "too-many-requests") {
        if (fromLogin) {
          await _watchEmailVerification();
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

  /// Manually listening for email link verification
  static Future _watchEmailVerification() async {
    _emailVerificationWatcher?.cancel();
    _emailVerificationWatcher =
        Timer(Duration(seconds: 1), _watchEmailVerification);

    if (_auth.currentUser == null) {
      _emailVerificationWatcher.cancel();
      return;
    }

    await _auth.currentUser.reload();
    if (_auth.currentUser.emailVerified) {
      _emailVerificationWatcher.cancel();
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
