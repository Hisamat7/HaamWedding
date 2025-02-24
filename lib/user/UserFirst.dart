import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedweel/custom_package_recomentation.dart';
import 'package:wedweel/user/SearchPage.dart';
import 'package:wedweel/user/UserBlogs/UserBlogs.dart';
import 'package:intl/intl.dart';
import 'package:wedweel/user/UserHome/CardSectionGrid.dart';

class Userfirst extends StatelessWidget {
  final bool check;
  Userfirst({required this.check});

  // Function to calculate remaining days
  String remainingDays(DateTime targetDate) {
    final now = DateTime.now();
    final difference = targetDate.difference(now).inDays;
    return difference >= 0 ? '$difference days to go' : 'Booking date passed';
  }

  // Function to format date
  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd - MM - yyyy');
    return formatter.format(date);
  }

  // Get the current date
  String getCurrentDate() {
    return DateFormat('dd - MM - yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user
    final User? user = FirebaseAuth.instance.currentUser;
    final String userId =
        user?.uid ?? ''; // Get the user ID or an empty string if null

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 237, 250, 244),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('bookings')
              .where('userId', isEqualTo: userId) // Filter by current user's ID
              .where('status', whereIn: ['pending', 'confirmed'])
              .orderBy('startDate', descending: true) // Fetch latest booking
              .limit(1)
              .snapshots(),
          builder: (context, snapshot) {
            String titleText = "Welcome";
            String subtitleText = "Today's Date: ${getCurrentDate()}";

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.teal,
                  color: Colors.tealAccent,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              var booking = snapshot.data!.docs.first;

              // Ensure startDate is retrieved as DateTime (Handles Timestamp or String)
              DateTime startDate;
              if (booking['startDate'] is Timestamp) {
                startDate = (booking['startDate'] as Timestamp).toDate();
              } else {
                startDate = DateTime.parse(booking['startDate']);
              }

              titleText = remainingDays(startDate);
              subtitleText = 'Booking: ${formatDate(startDate)} ';
            }

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: ListView(
                children: [
                  ListTile(
                    title: Text(
                      titleText,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.teal,
                      ),
                    ),
                    subtitle: Text(
                      subtitleText,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Searchpage()));
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.teal,
                        size: 30.w,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Center(
                    child: Text(
                      "Create Your Own Version\n Of Perfect Wedding",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21.sp,
                        fontFamily: 'Poppins-Medium',
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 21, 101, 93),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Container(
                      padding: EdgeInsets.only(left: 10.w),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 199, 233, 217),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      height: 220.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),
                          Text(
                            "Are you tired?",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontFamily: 'Poppins-Medium',
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 21, 101, 93),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 15, top: 15, bottom: 15),
                            child: Text(
                              'Tired of looking through every single vendor of each service type? We will select a tailored package that best fits your interests.',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BestServiceScreen(),
                                ),
                              );
                            },
                            child: Container(
                              width: 150.w,
                              height: 35.h,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 21, 101, 93),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.r),
                                  bottomRight: Radius.circular(20.r),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Custom Package',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontFamily: 'Poppins-Medium',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  check ? CardSectionGrid() : _buildTasksSection(),
                  ListTile(
                    leading: Text(
                      "Recent Events",
                      style:
                          TextStyle(fontSize: 18.sp, color: Colors.teal[700]),
                    ),
                  ),
                  _buildRecentEvents(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Build Task Section
  Widget _buildTasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: Text(
            "Tasks",
            style: TextStyle(
              fontSize: 21.sp,
              height: 3,
              fontFamily: 'Poppins-Medium',
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 21, 101, 93),
            ),
          ),
        ),
        Container(
          height: 200.h,
          padding: EdgeInsets.only(left: 10.w),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 15.w),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.w),
                  height: 150.h,
                  width: 170.w,
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.asset(
                          'assets/hall1.png', // Replace with your image asset
                          height: 105.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Makeup",
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontFamily: 'Poppins-Medium',
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 21, 101, 93),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Pending",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Build Recent Events Section
  Widget _buildRecentEvents() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('blog').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No data available'));
        }

        final data = snapshot.data!.docs;
        return Container(
          height: 200.h,
          padding: EdgeInsets.only(left: 10.w),
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final blogname = data[index]['name'];
              final blogimage = data[index]['image'];
              final blogdate = data[index]['date'];
              return Container(
                height: 150.h,
                margin: EdgeInsets.only(bottom: 20.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.network(
                          blogimage,
                          height: 140.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 7.h),
                          Text(blogname,
                              style: TextStyle(
                                  fontSize: 13.sp, color: Colors.teal[700])),
                          SizedBox(height: 5.h),
                          Text(blogdate, style: TextStyle(fontSize: 11.sp)),
                          SizedBox(height: 11.h),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Userblogs(
                                    blogdate: data[index]['date'],
                                    blogtitle: data[index]['name'],
                                    blogimage: data[index]['image'],
                                    blogdescription: data[index]['description'],
                                    readtime: data[index]['read_time'],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "Read More",
                              style: TextStyle(
                                  fontSize: 15.sp, color: Colors.blue),
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
        );
      },
    );
  }
}
