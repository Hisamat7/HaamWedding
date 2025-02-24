import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedweel/user/ReviewWidget.dart';
import 'package:wedweel/user/profile/bookings/UserBookingScreen.dart';

class Vendormaindetails extends StatelessWidget {
  final String vendorname;
  final String location;
  final String vendorimage;
  final String price;
  final String vendordescription;
  final bool isVenueVendor;
  final String guestnumber;
  final String phonenumber;
  final String id; // vendorId

  Vendormaindetails({
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

  // Function to fetch reviews and calculate total count and average rating
  Future<Map<String, dynamic>> getReviewData(String vendorId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('vendorId', isEqualTo: vendorId)
        .get();

    final reviews = querySnapshot.docs;
    final totalReviews = reviews.length;

    if (totalReviews == 0) {
      return {
        'totalReviews': 0,
        'averageRating': 0.0,
      };
    }

    // Calculate the average rating
    double totalRating = 0;
    for (final review in reviews) {
      final rating = review['rating'] ?? 0;
      totalRating += rating;
    }
    final averageRating = totalRating / totalReviews;

    return {
      'totalReviews': totalReviews,
      'averageRating': averageRating,
    };
  }

  // Function to fetch booking data for the vendor
  Future<List<Map<String, dynamic>>> getBookingData(String vendorId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('vendorId', isEqualTo: vendorId)
        .get();

    final bookings = querySnapshot.docs.map((doc) => doc.data()).toList();
    return bookings;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        body: FutureBuilder<Map<String, dynamic>>(
          future: getReviewData(id), // Fetch review data using vendorId
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final totalReviews = snapshot.data?['totalReviews'] ?? 0;
            final averageRating = snapshot.data?['averageRating'] ?? 0.0;

            return Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: 170.h,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      vendorimage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(vendorname,
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 21, 101, 93))),
                  trailing: Text(
                    "Rent : $price",
                    style: TextStyle(
                        fontSize: 15, color: Color.fromARGB(255, 21, 101, 93)),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 18, right: 18),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star_border,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 10),
                            Text(
                              averageRating
                                  .toStringAsFixed(1), // Display average rating
                              style: TextStyle(color: Colors.teal[700]),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "($totalReviews Reviews)", // Display total review count
                              style: TextStyle(color: Colors.teal[700]),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        isVenueVendor
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.people,
                                    color: Color.fromARGB(255, 21, 101, 93),
                                  ),
                                  SizedBox(width: 10),
                                  Text(guestnumber),
                                ],
                              )
                            : SizedBox(
                                height: 1.h,
                              ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: Color.fromARGB(255, 21, 101, 93)),
                            SizedBox(width: 10),
                            Text(location),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          children: [
                            Text(
                              "Contact",
                              style: TextStyle(color: Colors.teal[700]),
                            ),
                            Spacer(),
                            Text(
                              phonenumber,
                              style: TextStyle(color: Colors.teal[700]),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TabBar(
                          tabs: [
                            Tab(text: 'Description'),
                            Tab(text: 'Review'),
                            Tab(text: 'Slot'),
                          ],
                          labelColor: const Color.fromARGB(255, 27, 95, 58),
                          unselectedLabelColor: Colors.grey,
                          indicatorColor:
                              const Color.fromARGB(255, 212, 209, 51),
                        ),
                        // TabBarView
                        Expanded(
                          child: TabBarView(
                            children: [
                              // Description Tab
                              Column(
                                children: [
                                  Expanded(
                                    child: ListView(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 10, right: 10),
                                          child: Text(
                                            vendordescription,
                                            style: TextStyle(
                                                color: Colors.teal[700]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UserBookingScreen(
                                                    vendorId:
                                                        id, // Pass vendorId
                                                  )));
                                    },
                                    child: Text(
                                      "Book Now",
                                      style: TextStyle(color: Colors.teal[700]),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 178, 215, 181),
                                        minimumSize: Size(double.infinity, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                  ),
                                ],
                              ),
                              // Review Tab
                              Reviewwidget(vendorId: id), // Pass vendorId
                              // Slot Tab
                              FutureBuilder<List<Map<String, dynamic>>>(
                                future: getBookingData(
                                    id), // Fetch bookings using vendorId
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }

                                  if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  }

                                  final bookings = snapshot.data ?? [];

                                  // Create a list of all dates between start and end dates
                                  final bookedDates = <DateTime>[];
                                  for (final booking in bookings) {
                                    final startDate =
                                        DateTime.parse(booking['startDate']);
                                    final endDate =
                                        DateTime.parse(booking['endDate']);
                                    for (var date = startDate;
                                        date.isBefore(endDate) ||
                                            date.isAtSameMomentAs(endDate);
                                        date = date.add(Duration(days: 1))) {
                                      bookedDates.add(date);
                                    }
                                  }

                                  return ListView.builder(
                                    itemCount: 30, // Display next 30 days
                                    itemBuilder: (context, index) {
                                      final date = DateTime.now()
                                          .add(Duration(days: index));
                                      final isBooked = bookedDates.any(
                                          (bookedDate) =>
                                              bookedDate.year == date.year &&
                                              bookedDate.month == date.month &&
                                              bookedDate.day == date.day);

                                      return ListTile(
                                        title: Text(
                                            "${date.day}/${date.month}/${date.year}",
                                            style: TextStyle(
                                              color: Colors.teal[700],
                                            )),
                                        subtitle: Text(
                                            isBooked ? "Booked" : "Available",
                                            style: TextStyle(
                                              color: isBooked
                                                  ? Colors.red
                                                  : Colors.green,
                                            )),
                                        trailing: Icon(
                                          isBooked ? Icons.close : Icons.check,
                                          color: isBooked
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
