import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wedweel/user/UserFirst.dart';
import 'package:wedweel/user/bootomNavBar.dart';

class UserAuthServices {
  final firebaseauth = FirebaseAuth.instance;
  final firebasestore = FirebaseFirestore.instance;
  Future<void> Signin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      print(email);
      print(password);
      await firebaseauth.signInWithEmailAndPassword(
          email: email, password: password);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar()),
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login Successfull')));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }

  Future<void> SignUp(
      {required String email,
      required String password,
      required String fullname,
      required BuildContext context}) async {
    try {
      var user = await firebaseauth.createUserWithEmailAndPassword(
          email: email, password: password);

      await firebasestore
          .collection('user')
          .doc(user.user!.uid)
          .set({'email': email, 'password': password, 'fullname': fullname});

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar()),
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sign Up Successfull')));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }
}
