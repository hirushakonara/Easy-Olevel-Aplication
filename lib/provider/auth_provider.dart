import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../data/repositories/db_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _dbService = DatabaseService();

  Future<void> registerUser({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    try {
      // 1. Auth හරහා Register වීම
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // 2. Firestore එකට අමතර විස්තර save කිරීම
      await _dbService.saveUser(userCredential.user!.uid, userData);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
