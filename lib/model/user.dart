import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:key_testing/utils/firebase_utils.dart';

class KeyUser {
  String id;
  String email;
  String name;
  bool isAdmin;

  DocumentReference _documentReference;

  DocumentReference get dbReference => _documentReference;

  KeyUser({
    @required this.email,
    this.id,
    this.name,
    this.isAdmin = false,
  });

  static Future<KeyUser> fromDocumentReference(
      DocumentReference reference) async {
    if (reference == null) return null;

    var snapshot = await reference.get();
    return KeyUser.fromDocumentSnapshot(snapshot)
      .._documentReference = reference;
  }

  /// build user object out of Firebase snapshot object
  factory KeyUser.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    if (snapshot == null) return null;

    return KeyUser(
      email: getFieldFromSnapshot("email", snapshot),
      name: getFieldFromSnapshot("name", snapshot, defaultValue: ""),
      isAdmin: getFieldFromSnapshot("isAdmin", snapshot, defaultValue: false),
      id: snapshot.reference.id,
    ).._documentReference = snapshot.reference;
  }

  KeyUser copyWith({
    String name,
    bool isAdmin,
  }) {
    return KeyUser(
      email: this.email,
      id: this.id,
      name: name ?? this.name,
      isAdmin: isAdmin ?? this.isAdmin,
    ).._documentReference = this._documentReference;
  }

  Map<String, dynamic> toMap() => {
        "email": this.email,
        "name": this.name,
        "isAdmin": this.isAdmin,
      };

  @override
  String toString() {
    return 'KeyUser{id: $id, email: $email, name: $name, isAdmin: $isAdmin}';
  }

  @override
  bool operator ==(Object other) =>
      other is KeyUser &&
      id == other.id &&
      email == other.email &&
      name == other.name &&
      isAdmin == other.isAdmin;

  @override
  int get hashCode =>
      id.hashCode ^ email.hashCode ^ name.hashCode ^ isAdmin.hashCode;
}
