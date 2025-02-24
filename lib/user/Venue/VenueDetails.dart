import 'package:flutter/material.dart';
import 'package:wedweel/imageVendor.dart';
import 'package:wedweel/user/VendorMainDetails.dart';

class Venuedetails extends StatelessWidget {
  final String phonenumber;
  final String vendorid;
  final isvenuevendor;
  final String vendorname;
  final String location;
  final String vendorphoto;
  final String price;
  final String description;
  final String guestcount;
  final String category;

  Venuedetails({
    required this.isvenuevendor,
    required this.vendorid,
    required this.phonenumber,
    required this.vendorname,
    required this.location,
    required this.vendorphoto,
    required this.price,
    required this.description,
    required this.guestcount,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 237, 250, 244),
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          title: Text(
            vendorname,
            style: TextStyle(
              fontSize: 17,
              fontFamily: 'Poppins-Medium',
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 21, 101, 93),
            ),
          ),
        ),
        body: Vendormaindetails(
          id: vendorid,
          phonenumber: phonenumber,
          guestnumber: guestcount,
          isVenueVendor: isvenuevendor,
          vendorname: vendorname,
          location: location,
          vendorimage: vendorphoto,
          price: price,
          vendordescription: description,
        ),
      ),
    );
  }
}
