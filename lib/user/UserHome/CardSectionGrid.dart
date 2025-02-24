import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedweel/user/Cake/CakeVendor.dart';
import 'package:wedweel/user/Decoration/DecorationVendor.dart';
import 'package:wedweel/user/UserHome/VendorList.dart';
import 'package:wedweel/user/Venue/Venue.dart';
import 'package:wedweel/user/flowershop/FlowerVendor.dart';
import 'package:wedweel/user/food/CateryingVendor.dart';
import 'package:wedweel/user/makeup/MakeupVendor.dart';
import 'package:wedweel/user/photography/photographyVendor.dart';

class CardSectionGrid extends StatelessWidget {
  Widget cardItems({
    required String name,
    required String photo,
    double imageheight = 35,
    double imagewidth = 35,
  }) {
    return Container(
      height: 200.h,
      child: Column(
        children: [
          Container(
            height: 100.h,
            width: 200.w,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    photo,
                    fit: BoxFit.cover,
                    height: imageheight,
                    width: imagewidth,
                  ),
                  Text(
                    name,
                    style: TextStyle(fontSize: 12.sp),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      child: GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          mainAxisSpacing: 10,
          crossAxisSpacing: 8,
          childAspectRatio: .8,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Vendorlist()));
              },
              child: GestureDetector(
                child: cardItems(
                  name: "Vendor",
                  photo: "asset/person.png",
                  imageheight: 30,
                  imagewidth: 30,
                ),
              ),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Venue()));
                },
                child: cardItems(name: "Venue", photo: "asset/venue2.png")),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Photographyvendor()));
              },
              child: cardItems(
                  name: "Photo", photo: "asset/photo-camera_5472910.png"),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Makeupvendor()));
              },
              child:
                  cardItems(name: "Make up", photo: "asset/cream_8337970.png"),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Flowervendor()));
              },
              child: cardItems(
                  name: "Flower",
                  photo: "asset/flower.png",
                  imageheight: 45,
                  imagewidth: 45),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Cateryingvendor()));
              },
              child: cardItems(
                  name: "Food ",
                  photo: "asset/catering.png",
                  imageheight: 45,
                  imagewidth: 45),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Decorationvendor()));
                },
                child: cardItems(
                    name: "Decoration ", photo: "asset/decoration.png")),
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Cakevendor()));
                },
                child: cardItems(
                    name: "cake ", photo: "asset/wedding-cake_5168732.png")),
          ]),
    );
  }
}
