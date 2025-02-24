import 'package:flutter/material.dart';
import 'package:wedweel/venders/screen/layersSignUpvendor/layer1SignUpVendor.dart';
import 'package:wedweel/venders/screen/layersSignUpvendor/layer2.SignUpvendor.dart';
import 'package:wedweel/venders/screen/layersSignUpvendor/layer3SignUpvendor.dart';

class Signupvendor extends StatelessWidget {
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
                top: 80,
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
            Positioned(top: 200, right: 0, bottom: 0, child: Layer1SignUpVendor()),
            Positioned(
                top: 225, right: 0, bottom: 0, left: 20, child: Layer2signupvendor()),
            Positioned(top: 120, right: 0, bottom: 0, child: Layer3signupvendor()),
          ],
        ),
      ),
    );
  }
}
