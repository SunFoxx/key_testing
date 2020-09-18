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
  User get authorizedUser => __authorizedUser;
  bool get isAuthorized => __authorizedUser != null;
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

  Future onAuth(String email, String password) async {
    _isLoading = true;
    _authorizedUser =
        await FirebaseAuthService.signInWithEmailAndPassword(email, password);
    _isLoading = false;
  }

  void _onFirebaseAuthEvent(User user) {
    print("auth event $user");
    _authorizedUser = user;
    _isLoading = false;
  }
}
