import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminAuthServices {
  final firebaseauth = FirebaseAuth.instance;
  void Signin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      print(email);
      print(password);
      await firebaseauth.signInWithEmailAndPassword(
          email: email, password: password);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login Successfull')));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }
}
