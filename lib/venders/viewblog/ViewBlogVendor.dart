import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedweel/admin/AdminBlog/AddBlog.dart';
import 'package:wedweel/venders/viewblog/DetailBlogVendor.dart';

class Viewblogvendor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Blogs",
          style: TextStyle(
            fontSize: 21.sp,
            fontFamily: 'Poppins-Medium',
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 21, 101, 93),
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 237, 250, 244),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('blog').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            final data = snapshot.data!.docs;
            return Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final blogname = data[index]['name'];
                        final blogimage = data[index]['image'];
                        final blogdate = data[index]['date'];

                        return Container(
                          height: 190.h,
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          margin: EdgeInsets.only(
                            bottom: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    blogimage,
                                    height: 160,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                      blogname,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontFamily: 'Poppins-Medium',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      blogdate,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(height: 13),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Detailblogvendor(
                                                      blogtitle: data[index]
                                                          ['name'],
                                                      blogdescription:
                                                          data[index]
                                                              ['description'],
                                                      blogimage: data[index]
                                                          ['image'],
                                                      blogdate: data[index]
                                                          ['date'],
                                                      readtime: data[index]
                                                          ['read_time'],
                                                    )));
                                      },
                                      child: Text(
                                        "Read More",
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Medium',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
