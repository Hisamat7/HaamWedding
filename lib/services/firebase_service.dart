// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;

  
//   Future<User?> signUpWithEmailAndPassword(String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user; // Returns the signed-in user
//     } on FirebaseAuthException catch (e) {
//       // Handle errors
//       if (e.code == 'weak-password') {
//         print('The password provided is too weak.');
//       } else if (e.code == 'email-already-in-use') {
//         print('The account already exists for that email.');
//       }
//       return null; // Return null if sign-up failed
//     } catch (e) {
//       print(e.toString());
//       return null; // Return null if there was an error
//     }
//   }


//    Future<void> addUserToCollection(String uid, String name, String email, String phone, String address) async {
//     try {
//       await _firestore.collection('users').doc(uid).set({
//         'name': name,
//         'email': email,
//         'phone': phone,
//         'address': address,
//       });
//       print('User added to Firestore successfully!');
//     } catch (e) {
//       print('Error adding user to Firestore: $e');
//     }
//   }
// }
