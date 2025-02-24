import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedweel/user/screen/layersUser/layer1.dart';
import 'package:wedweel/user/screen/layersUser/layer2.dart';
import 'package:wedweel/user/screen/layersUser/layer3.dart';
import 'package:wedweel/venders/layers/layer1vendor.dart';
import 'package:wedweel/venders/layers/layer2vendor.dart';
import 'package:wedweel/venders/layers/layer3vendor.dart';

class Loginvendor extends StatelessWidget {
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
                top: 120.h,
                left: 59.w,
                child: Container(
                  child: Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 48.sp,
                        fontFamily: 'Poppins-Medium',
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                )),
            Positioned(
                top: 250.h, right: 0.w, bottom: 0.h, child: LayerOneVendor()),
            Positioned(
                top: 275.h,
                right: 0.w,
                bottom: 0.h,
                left: 20.w,
                child: LayerTwoVendor()),
            Positioned(
                top: 120.h, right: 0.w, bottom: 0.h, child: LayerThreeVendor()),
          ],
        ),
      ),
    );
  }
}
