import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedweel/admin/AdminBlog/AddBlog.dart';

class Detailblogvendor extends StatelessWidget {
  final String blogtitle;
  final String blogdescription;
  final String blogimage;
  final String blogdate;
  final String readtime;

  Detailblogvendor(
      {required this.blogtitle,
      required this.blogdescription,
      required this.blogimage,
      required this.blogdate,
      required this.readtime});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        backgroundColor: Color.fromARGB(255, 239, 248, 244),
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    blogimage,
                    height: 180.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  blogtitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                    color: Color.fromARGB(255, 21, 101, 93),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(readtime),
                    SizedBox(
                      width: 10,
                    ),
                    VerticalDivider(
                      color: Colors.black,
                      width: 10,
                    ),
                    Text(blogdate),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        blogdescription,
                        style: TextStyle(
                          fontFamily: 'Poppins-Medium',
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
