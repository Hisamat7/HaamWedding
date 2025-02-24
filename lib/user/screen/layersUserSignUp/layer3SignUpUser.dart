import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Add this import
import 'package:wedweel/config.dart';
import 'package:wedweel/user/loginmain.dart/loginpage.dart';

class Layer3signupuser extends StatefulWidget {
  Layer3signupuser({super.key});
  @override
  State<Layer3signupuser> createState() => _LayerThree();
}

class _LayerThree extends State<Layer3signupuser> {
  bool obscureText = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController fullName = TextEditingController();
  bool isLoad = false;

  String? validateEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    );
    return emailRegExp.hasMatch(email) ? null : 'Enter a valid email';
  }

  String? validatePassword(String password) {
    final RegExp passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    return passwordRegExp.hasMatch(password)
        ? null
        : 'Password must be at least 8 characters, include an uppercase letter, a number, and a special character.';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Container(
          height: 1.sh, // Full screen height
          width: 1.sw, // Full screen width
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 59.w,
                top: 169.h,
                child: Text(
                  'Email',
                  style: TextStyle(
                    color: Colors.teal[700],
                    fontFamily: 'Poppins-Medium',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Positioned(
                left: 59.w,
                top: 200.h,
                child: Container(
                  width: 310.w,
                  child: TextFormField(
                    controller: email,
                    validator: (value) => validateEmail(value!),
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 1, 108, 95)),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 0, 121, 107)),
                      ),
                      hintText: 'Enter your Email',
                      hintStyle: TextStyle(color: hintText),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 59.w,
                top: 265.h,
                child: Text(
                  'Password',
                  style: TextStyle(
                    color: Colors.teal[700],
                    fontFamily: 'Poppins-Medium',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Positioned(
                left: 59.w,
                top: 300.h,
                child: Container(
                  width: 310.w,
                  child: TextFormField(
                    obscureText: obscureText,
                    controller: password,
                    validator: (value) => validatePassword(value!),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 1, 108, 95)),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 0, 121, 107)),
                      ),
                      hintText: 'Enter Password',
                      hintStyle: TextStyle(color: hintText),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 59.w,
                top: 359.h,
                child: Text(
                  'Fullname',
                  style: TextStyle(
                    color: Colors.teal[700],
                    fontFamily: 'Poppins-Medium',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Positioned(
                left: 59.w,
                top: 400.h,
                child: Container(
                  width: 310.w,
                  child: TextFormField(
                    controller: fullName,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 1, 108, 95)),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 0, 121, 107)),
                      ),
                      hintText: 'Enter your full name',
                      hintStyle: TextStyle(color: hintText),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 150.h,
                right: 26.w,
                child: GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoad = true;
                      });
                      await _registerUser(context, email.text.trim(),
                          password.text.trim(), fullName.text.trim());
                      setState(() {
                        isLoad = false;
                      });
                    }
                  },
                  child: Container(
                    width: 99.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      color: signInButton,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        bottomRight: Radius.circular(20.r),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontFamily: 'Poppins-Medium',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0.h,
                left: 59.w,
                right: 59.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                          fontSize: 17.sp,
                          fontFamily: 'Poppins-Regular',
                          color: forgotPasswordText),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginUserPage()),
                        );
                      },
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                            fontSize: 17.sp,
                            fontFamily: 'Poppins-Regular',
                            color: signInButton),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 50.h,
                left: 120.w,
                right: 120.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        await _signInWithGoogle(context);
                      },
                      child: Container(
                        width: 59.w,
                        height: 58.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: signInBox),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.r),
                                bottomRight: Radius.circular(20.r))),
                        child: Image.asset(
                          'asset/icon_google.png',
                          width: 20.w,
                          height: 21.h,
                        ),
                      ),
                    ),
                    Text(
                      'or',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'Poppins-Regular',
                          color: hintText),
                    ),
                    Container(
                      width: 59.w,
                      height: 58.h,
                      decoration: BoxDecoration(
                          border: Border.all(color: signInBox),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.r),
                              bottomRight: Radius.circular(20.r))),
                      child: Image.asset(
                        'asset/icon_apple.png',
                        width: 20.w,
                        height: 21.h,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registerUser(BuildContext context, String email,
      String password, String fullName) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user?.uid)
          .set({
        'email': email,
        'fullName': fullName,
        'uid': userCredential.user?.uid,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginUserPage(),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to register: $e'),
            actions: [
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // Google Sign-In
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return; // User canceled the sign-in process
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Save user details to Firestore
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userCredential.user?.uid)
          .set({
        'email': googleUser.email,
        'fullName': googleUser.displayName,
        'uid': userCredential.user?.uid,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginUserPage(),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to sign in with Google: $e'),
            actions: [
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
