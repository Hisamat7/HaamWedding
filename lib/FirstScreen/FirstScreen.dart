import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedweel/user/loginmain.dart/loginpage.dart';
import 'package:wedweel/venders/screen/LoginVendor.dart';

class Firstscreen extends StatelessWidget {
  Widget button({required String name, VoidCallback? onTap}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(125.w, 40.h),
          backgroundColor: Color.fromARGB(255, 232, 255, 243),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                color: Colors.teal,
              ))),
      onPressed: onTap,
      child: Text(
        name,
        style: TextStyle(color: Colors.teal[600], fontSize: 16.sp),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('asset/hAAM.jpg'),
                fit: BoxFit.cover,
              )),
              child: Stack(
                children: [
                  Positioned(
                      bottom: 150.h,
                      left: 10.w,
                      right: 10.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          button(
                            name: "User",
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginUserPage()),
                                  (route) => false);
                            },
                          ),
                          button(
                              name: "Vendor",
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Loginvendor(),
                                    ),
                                    (route) => false);
                              }),
                        ],
                      ))
                ],
              ))),
    );
  }
}
