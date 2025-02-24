import 'package:flutter/material.dart';
import 'package:wedweel/user/VendorMainDetails.dart';

class Photographydetails extends StatelessWidget {
  final String number;
  final isvenuevendor;
  final String name;
  final String vendorid;
  final String vendorlocation;
  final String vendorprice;
  final String vendorDescription;
  final String vendorcategory;
  final String vendorphoto;

  const Photographydetails(
      {super.key,
      required this.isvenuevendor,
      required this.vendorid,
      required this.vendorphoto,
      required this.number,
      required this.name,
      required this.vendorlocation,
      required this.vendorprice,
      required this.vendorDescription,
      required this.vendorcategory});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          title: Text(
            name,
            style: TextStyle(
              fontSize: 17,
              fontFamily: 'Poppins-Medium',
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 21, 101, 93),
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 237, 250, 244),
        body: Vendormaindetails(
            id: vendorid,
            phonenumber: number,
            vendorname: name,
            isVenueVendor: isvenuevendor,
            location: vendorlocation,
            vendorimage: vendorphoto,
            price: vendorprice,
            vendordescription: vendorDescription),
      ),
    );
  }
}
