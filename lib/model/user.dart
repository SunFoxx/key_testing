import 'package:flutter/cupertino.dart';

class KeyUser {
  String email;
  String displayName;
  UserRole role;

  KeyUser({
    @required this.email,
    this.displayName,
    this.role,
  });

  KeyUser copyWith({
    String displayName,
    UserRole role,
  }) {
    return KeyUser(
      email: this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
    );
  }
}

enum UserRole { user, admin }
