import 'package:cloud_firestore/cloud_firestore.dart';

dynamic getFieldFromSnapshot(String field, DocumentSnapshot snapshot,
    {dynamic defaultValue}) {
  try {
    return snapshot.get(field);
  } on StateError catch (e) {
    return defaultValue ?? null;
  } catch (e) {
    return null;
  }
}
