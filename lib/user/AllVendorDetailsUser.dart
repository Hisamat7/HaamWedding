import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedweel/user/VendorMainDetails.dart';

class Allvendordetailsuser extends StatelessWidget {
  final String vendorname;
  final String location;
  final String vendorimage;
  final String price;
  final String vendordescription;
  final String guestnumber;
  final String phonenumber;
  final String id;
  final String category;
  final isvenuvendor;

  Allvendordetailsuser({
    required this.id,
    required this.isvenuvendor,
    required this.category,
    required this.phonenumber,
    this.guestnumber = " ",
    required this.vendorname,
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
              guestnumber: guestnumber,
              phonenumber: phonenumber,
              vendorname: vendorname,
              isVenueVendor: isvenuvendor,
              location: location,
              vendorimage: vendorimage,
              price: price,
              vendordescription: vendordescription),
        ));
  }
}
