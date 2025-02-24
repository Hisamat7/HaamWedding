import 'package:flutter/material.dart';
import 'package:wedweel/user/screen/layersUserSignUp/layer1SignUpUser.dart';
import 'package:wedweel/user/screen/layersUserSignUp/layer2SignupUser.dart';
import 'package:wedweel/user/screen/layersUserSignUp/layer3SignUpUser.dart';

class SignUpUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('asset/primaryBg.png'),
          fit: BoxFit.cover,
        )),
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 140,
                left: 59,
                child: Container(
                  child: Text(
                    'Register',
                    style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Poppins-Medium',
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                )),
            Positioned(top: 255, right: 0, bottom: 0, child: Layer1SignUpUser()),
            Positioned(
                top: 280, right: 0, bottom: 0, left: 20, child: Layer2signupuser()),
            Positioned(top: 120, right: 0, bottom: 0, child: Layer3signupuser()),
          ],
        ),
      ),
    );
  }
}
