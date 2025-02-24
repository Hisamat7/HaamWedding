import 'package:flutter/material.dart';
import 'package:wedweel/admin/LoginScreen/layers/LayerAdmin1.dart';
import 'package:wedweel/admin/LoginScreen/layers/LayerAdmin2.dart';
import 'package:wedweel/admin/LoginScreen/layers/LayerAdmin3.dart';

class LoginAdminPage extends StatelessWidget {
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
                    'Login',
                    style: TextStyle(
                        fontSize: 48,
                        fontFamily: 'Poppins-Medium',
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                )),
            Positioned(top: 200, right: 0, bottom: 0, child: LayerAdmin1()),
            Positioned(
                top: 225, right: 0, bottom: 0, left: 20, child: LayerAdmin2()),
            Positioned(top: 120, right: 0, bottom: 0, child: Layeradmin3()),
          ],
        ),
      ),
    );
  }
}
