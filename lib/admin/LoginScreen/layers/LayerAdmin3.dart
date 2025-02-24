import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wedweel/config.dart';

import 'package:wedweel/user/servicesuser/AuthUserServices.dart';

class Layeradmin3 extends StatefulWidget {
  Layeradmin3({super.key});
  @override
  State<Layeradmin3> createState() => _LayerThree();
}

class _LayerThree extends State<Layeradmin3> {
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
  Widget build(BuildContext context) {
    bool isChecked = false;
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Container(
          height: 684,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 59,
                top: 119,
                child: Text(
                  'Email',
                  style: TextStyle(
                      fontFamily: 'Poppins-Medium',
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Positioned(
                  left: 59,
                  top: 150,
                  child: Container(
                    width: 310,
                    child: TextFormField(
                      controller: email,
                      validator: (value) {
                        return validateEmail(value!);
                      },
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Enter User ID or Email',
                        hintStyle: TextStyle(color: hintText),
                      ),
                    ),
                  )),
              Positioned(
                left: 59,
                top: 219,
                child: Text(
                  'Password',
                  style: TextStyle(
                      fontFamily: 'Poppins-Medium',
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Positioned(
                  left: 59,
                  top: 249,
                  child: Container(
                    width: 310,
                    child: TextFormField(
                      controller: password,
                      validator: (value) {
                        return validatePassword(value!);
                      },
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(color: hintText),
                      ),
                    ),
                  )),
              Positioned(
                  top: 330,
                  right: 37,
                  child: GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        UserAuthServices().Signin(
                            email: email.text,
                            password: password.text,
                            context: context);
                      }
                    },
                    child: Container(
                      width: 99,
                      height: 35,
                      decoration: BoxDecoration(
                        color: signInButton,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          'Sign In',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Poppins-Medium',
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
