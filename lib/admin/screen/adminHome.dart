import 'package:flutter/material.dart';
import 'package:wedweel/admin/AdminBlog/BlogFirstAdmin.dart';

import 'package:wedweel/admin/screen/ManageCompliant.dart';
import 'package:wedweel/admin/screen/ManageProfile.dart';
import 'package:wedweel/admin/screen/ManageReview.dart';
import 'package:wedweel/admin/screen/ManageUser.dart';
import 'package:wedweel/admin/screen/manageVendor.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  Widget contain({required String name, required VoidCallback pagename}) {
    return GestureDetector(
      onTap: pagename,
      child: Container(
        child: Center(
          child: Text(name,
              style: TextStyle(
                  color: Colors.teal,
                  fontFamily: 'Poppins-Medium',
                  fontWeight: FontWeight.w500,
                  fontSize: 16)),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 250, 255, 250),
            border: Border.all(
              color: Colors.teal,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Home',
          style: TextStyle(
            fontSize: 21,
            fontFamily: 'Poppins-Medium',
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 21, 101, 93),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 237, 250, 244),
      ),
      body: Container(
        height: double.maxFinite,
        color: Color.fromARGB(255, 237, 250, 244),
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          mainAxisSpacing: 13,
          crossAxisSpacing: 14,
          childAspectRatio: .8,
          padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
          children: [
            contain(
                name: 'Manage Profile',
                pagename: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Manageprofile()));
                }),
            contain(
                name: 'Manageuser',
                pagename: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Manageuser(),
                      ));
                }),
            contain(
                name: 'Manage Vendor',
                pagename: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Managevendor()));
                }),
            contain(
                name: "View Review",
                pagename: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VendorReviewsPage()));
                }),
            contain(
                name: "Manage blogs",
                pagename: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Blogfirstadmin()));
                }),
            contain(
                name: "Manage\n Complaint",
                pagename: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminComplaintsPage()));
                })
          ],
        ),
      ),
    );
  }
}
