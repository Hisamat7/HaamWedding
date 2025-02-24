import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedweel/user/ReviewWidget.dart';
import 'package:wedweel/user/VendorMainDetails.dart';

class Searchdetailpage extends StatelessWidget {
  final String vendorname;
  final String location;
  final String vendorimage;
  final String price;
  final String vendordescription;
  final isVenueVendor;
  final String guestnumber;
  final String phonenumber;
  final String id;

  Searchdetailpage({
    required this.id,
    required this.phonenumber,
    this.guestnumber = " ",
    required this.vendorname,
    required this.isVenueVendor,
    required this.location,
    required this.vendorimage,
    required this.price,
    required this.vendordescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(
          vendorname,
          style: TextStyle(fontSize: 17.sp, color: Colors.teal[700]),
        ),
      ),
      body: SafeArea(
        child: Vendormaindetails(
          id: id,
          phonenumber: phonenumber,
          guestnumber: guestnumber,
          isVenueVendor: isVenueVendor,
          vendordescription: vendordescription,
          vendorname: vendorname,
          location: location,
          vendorimage: vendorimage,
          price: price,
        ),
      ),
    );
  }
}
