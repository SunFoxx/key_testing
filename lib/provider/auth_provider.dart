import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:key_testing/services/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    FirebaseAuthService.stream.listen(_onFirebaseAuthEvent);
  }

  /// we have a private setter because we need notify listeners each time we change the value
  /// but the value itself shouldn't be modified from outside
  User __authorizedUser;

  User get authorizedUser =>
      FirebaseAuthService.authorizedUser ?? __authorizedUser;

  bool get isAuthorized => (authorizedUser?.emailVerified ?? false);

  bool get isAwaitingForEmailVerification =>
      FirebaseAuthService.isAwaitingForEmailVerification;

  set _authorizedUser(User user) {
    if (__authorizedUser?.uid != user?.uid) {
      __authorizedUser = user;
      notifyListeners();
    }
  }

  bool __isLoading = false;

  bool get isLoading => __isLoading;

  set _isLoading(bool val) {
    __isLoading = val;
    notifyListeners();
  }

  Future<bool> logIn(String email, String password) async {
    _isLoading = true;
    _authorizedUser =
        await FirebaseAuthService.signInWithEmailAndPassword(email, password);
    _isLoading = false;
    return isAuthorized;
  }

  Future register(String email, String password) async {
    _isLoading = true;
    _authorizedUser = (await FirebaseAuthService.registerWithEmailAndPassword(
            email, password))
        ?.user;
    _isLoading = false;
  }

  Future<bool> sendVerificationLink() async {
    if (authorizedUser == null || authorizedUser.emailVerified == true)
      return false;

    return await FirebaseAuthService.verifyEmail();
  }

  Future logOut() async {
    await FirebaseAuthService.signOut();
  }

  void _onFirebaseAuthEvent(User user) {
    _authorizedUser = user;
    _isLoading = false;
  }
}
