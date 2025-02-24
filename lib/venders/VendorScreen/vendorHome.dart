import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedweel/venders/screen/LoginVendor.dart';

import 'package:wedweel/venders/VendorScreen/ReviewScreen/VendorReviewScreen.dart';
import 'package:wedweel/venders/VendorScreen/ServiceScreen/ServiceFirstScreenVendor.dart';
import 'package:wedweel/venders/VendorScreen/ProfileScreen/VendorProfile.dart';
import 'package:wedweel/venders/screen/BookingScreen/FirstScreenBooking.dart';
import 'package:wedweel/venders/viewblog/ViewBlogVendor.dart';

class VendorHome extends StatelessWidget {
  bool isLoading = false;

  // Function to log out the user
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Redirect to the vendor login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Loginvendor()),
        (route) => false,
      );
    } catch (e) {
      // Show an error if logout fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 250, 244),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Text(
          "Vendor Home",
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins-Medium',
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 21, 101, 93),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('vendor')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          }

          final data = snapshot.data?.data();
          final email = data?['email'] ?? '';
          final name = data?['fullname'] ?? '';
          final profile = data?['logo'] ?? '';
          final phone = data?['phone'] ?? 'Phone Number';
          final address = data?['address'] ?? 'Address';
          final document = data?['document'] ?? '';

          return isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            child: ClipOval(
                              child: Image.network(
                                profile,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 18.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome,",
                                style: TextStyle(
                                  fontSize: 27,
                                  fontFamily: 'Poppins-Regular',
                                  color: Color.fromARGB(255, 21, 101, 93),
                                ),
                              ),
                              Text(
                                name,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 47, 173, 161),
                                  fontSize: 19,
                                  fontFamily: 'Poppins-Bold',
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        mainAxisSpacing: 7,
                        crossAxisSpacing: 7,
                        childAspectRatio: .9,
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        children: [
                          buildCard(
                            context,
                            "asset/service.jpg",
                            "Service",
                            ServiceFirstScreen(),
                          ),
                          buildCard(
                            context,
                            "asset/Booking.jpeg",
                            "Bookings",
                            FirstScreenBooking(),
                          ),
                          buildCard(context, "asset/5348778.jpg", "Review",
                              VendorReviewsPage()),
                          buildCard(context, "asset/blog.jpg", "Blog",
                              Viewblogvendor()),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Vendorprofile(
                                    email: email,
                                    fullname: name,
                                    phone: phone,
                                    address: address,
                                    document: document,
                                    logo: profile,
                                  ),
                                ),
                              );
                            },
                            child: buildCardContainer(
                              "asset/profile.jpg",
                              "Profile",
                            ),
                          ),
                          GestureDetector(
                            onTap: () => logout(context),
                            child: buildCardContainer(
                              "asset/logout.jpg",
                              "LogOut",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }

  Widget buildCard(
      BuildContext context, String imagePath, String title, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: buildCardContainer(imagePath, title),
    );
  }

  Widget buildCardContainer(
    String imagePath,
    String title,
  ) {
    return Container(
      height: 90.h,
      width: 50.w,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Image.asset(imagePath, fit: BoxFit.cover, height: 118.h),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
