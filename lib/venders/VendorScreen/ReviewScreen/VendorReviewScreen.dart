import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VendorReviewsPage extends StatefulWidget {
  @override
  _VendorReviewsPageState createState() => _VendorReviewsPageState();
}

class _VendorReviewsPageState extends State<VendorReviewsPage> {
  final String vendorId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    print(vendorId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "User Reviews",
          style: TextStyle(fontSize: 20.sp, color: Colors.teal[900]),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("reviews")
                    .where("vendorId", isEqualTo: vendorId)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No reviews yet."));
                  }
                  var reviews = snapshot.data!.docs;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Total Reviews  ${reviews.length}",
                          style: TextStyle(
                              fontSize: 20.sp, color: Colors.teal[700]),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Expanded(
                        child: ListView.builder(
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            var review = reviews[index];
                            return Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        Color.fromARGB(255, 54, 219, 142),
                                    radius: 20,
                                    child: Text(
                                      review['username'][0],
                                      style: TextStyle(color: Colors.teal[700]),
                                    ), // First letter of username
                                  ),
                                  title: Text(
                                    review['username'],
                                    style: TextStyle(
                                        color: Colors.teal[900], fontSize: 16),
                                  ), // Display username
                                  subtitle: Text(
                                    "Rating : ${review['rating']}",
                                    style: TextStyle(color: Colors.teal[900]),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Text(
                                    review['review'],
                                    style: TextStyle(color: Colors.teal[800]),
                                  ),
                                ),
                                Divider(
                                  height: 20.h,
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
