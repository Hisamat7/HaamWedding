import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedweel/config.dart';
import 'package:wedweel/user/bootomNavBar.dart';
import 'package:wedweel/user/loginmain.dart/signuppage.dart';
import 'package:wedweel/user/screen/forgetpassword/ForgotPasswordScreen.dart';

class LayerThree extends StatefulWidget {
  LayerThree({super.key});
  @override
  State<LayerThree> createState() => _LayerThree();
}

class _LayerThree extends State<LayerThree> {
  bool obscureText = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoad = false;
  bool isChecked = false;

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

  Future<void> saveCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Future<Map<String, String?>> getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString('email'),
      'password': prefs.getString('password'),
    };
  }

  Future<void> clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
  }

  Future<void> autoLogin(BuildContext context) async {
    final credentials = await getCredentials();
    if (credentials['email'] != null && credentials['password'] != null) {
      await _checkVerificationStatus(
          context, credentials['email']!, credentials['password']!);
    }
  }

  @override
  void initState() {
    super.initState();
    autoLogin(context);
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
                  'Username',
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
                            color: const Color.fromARGB(255, 2, 104, 92)),
                      ),
                      hintText: 'Enter User ID or Email',
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
                            color: const Color.fromARGB(255, 2, 104, 92)),
                      ),
                      hintText: 'Enter Password',
                      hintStyle: TextStyle(color: hintText),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 30.w,
                top: 360.h,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen()),
                    );
                  },
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                      color: forgotPasswordText,
                      fontSize: 16.sp,
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 46.w,
                bottom: 190.h,
                child: Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.black,
                      activeColor: checkbox,
                      value: isChecked,
                      onChanged: (bool? value) async {
                        setState(() {
                          isChecked = value!;
                        });
                        if (isChecked) {
                          await saveCredentials(
                              email.text.trim(), password.text.trim());
                        } else {
                          await clearCredentials();
                        }
                      },
                    ),
                    Text(
                      'Remember Me',
                      style: TextStyle(
                        color: forgotPasswordText,
                        fontSize: 14.sp,
                        fontFamily: 'Poppins-Medium',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 200.h,
                right: 46.w,
                child: GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoad = true;
                      });
                      await _checkVerificationStatus(
                          context, email.text.trim(), password.text.trim());
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
                        'Sign In',
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
                  bottom: 140.h,
                  left: 59.w,
                  child: Container(
                    height: 0.5.h,
                    width: 310.w,
                    color: inputBorder,
                  )),
              Positioned(
                bottom: 50.h,
                left: 120.w,
                right: 120.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
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
              Positioned(
                bottom: 0.h,
                left: 59.w,
                right: 59.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
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
                              builder: (context) => SignUpUserPage()),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 17.sp,
                            fontFamily: 'Poppins-Regular',
                            color: signInButton),
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
}

Future<void> _checkVerificationStatus(
    context, String email, String password) async {
  try {
    final userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(userCredential.user?.uid)
        .get();

    if (userData.exists && userCredential.user != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar()),
        (route) => false,
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Please Create Your Account'),
            content: Text('Please create your account to continue.'),
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
  } catch (e) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Invalid credentials. Please try again.'),
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
