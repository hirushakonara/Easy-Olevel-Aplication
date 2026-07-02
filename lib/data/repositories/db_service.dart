import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. User details Register කිරීම
  Future<void> saveUser(String uid, Map<String, dynamic> userData) async {
    await _db.collection('users').doc(uid).set(userData);
  }

  // 2. User details ලබාගැනීම
  Future<DocumentSnapshot> getUserData(String uid) async {
    return await _db.collection('users').doc(uid).get();
  }

  // 3. Notes ලබාගැනීම (Filter සහිතව)
  Stream<QuerySnapshot> getNotes(String grade, String subject) {
    return _db
        .collection('notes')
        .where('grade', isEqualTo: grade)
        .where('subject', isEqualTo: subject)
        .snapshots();
  }
}
