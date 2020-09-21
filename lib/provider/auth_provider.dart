import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:key_testing/model/user.dart';
import 'package:key_testing/services/firebase_auth.dart';
import 'package:key_testing/services/firebase_database.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    FirebaseAuthService.stream.listen(_onFirebaseAuthEvent);
  }

  /// we have a private setter because we need notify listeners each time we change the value
  /// but the value itself shouldn't be modified from outside
  KeyUser __authorizedUser;

  KeyUser get authorizedUser => __authorizedUser;

  User get authorizedFirebaseUser => FirebaseAuthService.authorizedFirebaseUser;

  bool get isAwaitingForEmailVerification =>
      FirebaseAuthService.authorizedFirebaseUser?.emailVerified == false;

  set _authorizedUser(KeyUser keyUser) {
    if (keyUser != authorizedUser) {
      __authorizedUser = keyUser;
      notifyListeners();
    }
  }

  bool __isLoading = false;

  bool get isLoading => __isLoading;

  set _isLoading(bool val) {
    __isLoading = val;
    notifyListeners();
  }

  /// you can log in with unverified email, however you still need to verify it
  /// pass [onSuccessCallback] to react on verification completion
  /// return [true] if logged in without any problem
  Future<bool> logIn(
    String email,
    String password, [
    VoidCallback onSuccessCallback,
  ]) async {
    _isLoading = true;
    _authorizedUser = await FirebaseAuthService.signInWithEmailAndPassword(
      email,
      password,
      onSuccessCallback,
    );
    _isLoading = false;
    return FirebaseAuthService.authorizedFirebaseUser?.emailVerified;
  }

  Future register(
    String email,
    String password,
    VoidCallback onSuccessCallback,
  ) async {
    _isLoading = true;
    _authorizedUser = await FirebaseAuthService.registerWithEmailAndPassword(
      email,
      password,
      onSuccessCallback,
    );
    _isLoading = false;
  }

  Future<bool> sendVerificationLink(VoidCallback onVerifyCallback) async {
    if (authorizedFirebaseUser == null ||
        authorizedFirebaseUser.emailVerified == true) return false;

    return await FirebaseAuthService.verifyEmail(false, onVerifyCallback);
  }

  Future logOut() async {
    await FirebaseAuthService.signOut();
  }

  void _onFirebaseAuthEvent(User user) async {
    bool hadUserBefore = authorizedUser != null;
    KeyUser newUser;

    if (hadUserBefore) {
      newUser =
          KeyUser.fromDocumentSnapshot(await authorizedUser.dbReference.get());
    } else {
      newUser = await FirebaseDatabaseService.getUserByEmail(user?.email);
    }
    _authorizedUser = newUser;
    bool willHaveUser = newUser != null;

    if (!hadUserBefore && willHaveUser) {
      authorizedUser.dbReference.snapshots().listen(
        (snapshot) {
          _authorizedUser = KeyUser.fromDocumentSnapshot(snapshot);
        },
        cancelOnError: false,
      );
    }

    _isLoading = false;
  }
}
