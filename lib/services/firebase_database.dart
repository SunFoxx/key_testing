import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:key_testing/model/user.dart';
import 'package:key_testing/provider/notifications_layer_provider.dart';

class FirebaseDatabaseService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final FirebaseDatabaseService _instance = FirebaseDatabaseService._();

  factory FirebaseDatabaseService._() => _instance;

  static CollectionReference get usersCollection =>
      _database.collection("users");

  static Future<KeyUser> createUser(User firebaseUser) async {
    try {
      var dbReference = await usersCollection.add(
        {"email": firebaseUser.email},
      );
      return await KeyUser.fromDocumentReference(dbReference);
    } catch (e) {
      _showError(e.toString());
      return null;
    }
  }

  static Future<KeyUser> getUserByEmail(String email) async {
    var query = await usersCollection.where("email", isEqualTo: email).get();
    var reference = query.docs.length == 1 ? query.docs[0].reference : null;
    return (await KeyUser.fromDocumentReference(reference));
  }

  static void _showError(String text) {
    NotificationsLayerProvider().showNotification(
      NotificationElement(
        type: NotificationType.error,
        text: text,
        duration: Duration.zero,
      ),
    );
  }
}
