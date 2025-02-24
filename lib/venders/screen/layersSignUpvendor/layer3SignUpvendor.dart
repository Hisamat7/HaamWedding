import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedweel/config.dart';
import 'package:wedweel/venders/screen/LoginVendor.dart';
import 'package:wedweel/venders/screen/SignUpsecondPage.dart';

class Layer3signupvendor extends StatefulWidget {
  @override
  State<Layer3signupvendor> createState() => _LayerThree();
}

class _LayerThree extends State<Layer3signupvendor> {
  final _formKey = GlobalKey<FormState>();
  String? validateEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    );
    bool isvalid = emailRegExp.hasMatch(email);
    if (isvalid) {
      return null;
    } else {
      return 'Enter a valid email';
    }
  }

  String? validatePassword(String password) {
    final RegExp passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    bool isvalid = passwordRegExp.hasMatch(password);

    return isvalid ? null : 'Enter a valid password';
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController fullname = TextEditingController();
  bool isload = false;
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Container(
          height: 684.h,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 59.w,
                top: 149.h,
                child: Text(
                  'Fullname',
                  style: TextStyle(
                      color: Color.fromARGB(255, 1, 108, 95),
                      fontFamily: 'Poppins-Medium',
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Positioned(
                  left: 59.w,
                  top: 179.h,
                  child: Container(
                    width: 310.w,
                    child: TextField(
                      controller: fullname,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 1, 108, 95)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 1, 108, 95)),
                        ),
                        hintText: 'Enter Fullname',
                        hintStyle: TextStyle(color: hintText),
                      ),
                    ),
                  )),
              Positioned(
                left: 59.w,
                top: 252.h,
                child: Text(
                  'Email',
                  style: TextStyle(
                      fontFamily: 'Poppins-Medium',
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 1, 108, 95)),
                ),
              ),
              Positioned(
                  left: 59.w,
                  top: 285.h,
                  child: Container(
                    width: 310.w,
                    child: TextFormField(
                      controller: email,
                      validator: (value) {
                        return validateEmail(value!);
                      },
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 1, 108, 95)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 1, 108, 95)),
                        ),
                        hintText: 'Enter Email',
                        hintStyle: TextStyle(color: hintText),
                      ),
                    ),
                  )),
              Positioned(
                left: 59.w,
                bottom: 265.h,
                child: Text(
                  'Password',
                  style: TextStyle(
                      fontFamily: 'Poppins-Medium',
                      fontSize: 24,
                      color: Color.fromARGB(255, 1, 108, 95),
                      fontWeight: FontWeight.w500),
                ),
              ),
              Positioned(
                  left: 59.r,
                  bottom: 220.h,
                  child: Container(
                    width: 310.w,
                    child: TextFormField(
                      controller: password,
                      validator: (value) {
                        return validatePassword(value!);
                      },
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 1, 108, 95)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color.fromARGB(255, 1, 108, 95)),
                        ),
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(color: hintText),
                      ),
                    ),
                  )),
              Positioned(
                bottom: 160.h,
                right: 33.w,
                child: GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Signupsecondpage(
                                  email: email.text,
                                  fullname: fullname.text,
                                  password: password.text,
                                )),
                      );
                    }
                  },
                  child: Container(
                    width: 99.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      color: signInButton,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                    child: isload
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              'Sign Up',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Poppins-Medium',
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 59.w,
                right: 59.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins-Medium',
                          color: forgotPasswordText),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Loginvendor()),
                        );
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            fontSize: 17,
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
