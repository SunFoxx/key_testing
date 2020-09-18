import 'package:firebase_auth/firebase_auth.dart';
import 'package:key_testing/provider/overlay_provider.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseAuthService _instance = FirebaseAuthService._();

  factory FirebaseAuthService() => _instance;

  FirebaseAuthService._();

  static Stream<User> get stream => _auth.userChanges();

  static Future<User> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      var credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credentials.user;
    } on FirebaseAuthException catch (e) {
      String errText = "";
      if (e.code == 'user-not-found') {
        errText = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errText = 'Wrong password provided for that user.';
      } else {
        errText = "Error: ${e.code}";
      }

      _showError(errText);
    }

    return null;
  }

  static Future signOut() async {
    await _auth.signOut();
  }

  static Future registerWithEmailAndPassword(String email, String password,
      {String name}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result?.user?.emailVerified == false) {
        await verifyEmail();
      }

      _auth.currentUser.updateProfile(displayName: name);
    } on FirebaseAuthException catch (e) {
      String errText = "";
      if (e.code == 'weak-password') {
        errText = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errText = 'The account already exists for that email.';
      } else {
        errText = "Error: ${e.code}";
      }

      _showError(errText);
    }
  }

  static Future verifyEmail() async {
    try {
      await _auth.currentUser.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      _showError("sending verify email error: ${e.code}");
    }
  }

  static Future applyEmailVerificationCode(String code) async {
    try {
      await _auth.checkActionCode(code);
      await _auth.applyActionCode(code);

      _auth.currentUser.reload();
    } on FirebaseAuthException catch (e) {
      String errText = "";
      if (e.code == 'invalid-action-code') {
        errText = 'The code is invalid.';
      } else {
        errText = "email verification error: ${e.code}";
      }

      _showError(errText);
    }
  }

  static void _showError(String text) {
    NotificationsProvider().showNotification(
      NotificationElement(
        type: NotificationType.error,
        text: text,
        duration: Duration(milliseconds: 1750),
      ),
    );
  }
}
