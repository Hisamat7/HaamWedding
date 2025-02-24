import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedweel/admin/AdminBlog/AddBlog.dart';
import 'package:wedweel/user/screen/layersUser/layer1.dart';
import 'package:wedweel/user/screen/layersUser/layer2.dart';
import 'package:wedweel/user/screen/layersUser/layer3.dart';

class LoginUserPage extends StatelessWidget {
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
                top: 150,
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
            Positioned(top: 240.h, right: 0.w, bottom: 0.h, child: LayerOne()),
            Positioned(
                top: 270.h,
                right: 0.w,
                bottom: 0.h,
                left: 20.w,
                child: LayerTwo()),
            Positioned(
                top: 130.h, right: 0.w, bottom: 0.h, child: LayerThree()),
          ],
        ),
      ),
    );
  }
}
