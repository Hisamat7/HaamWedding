import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class VendorReviewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Vendor Reviews",
          style: TextStyle(color: Colors.teal[800]),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('reviews').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          Map<String, int> vendorReviewCount = {};
          List<QueryDocumentSnapshot> reviews = snapshot.data!.docs;

          for (var review in reviews) {
            String vendorId = review['vendorId'];
            vendorReviewCount[vendorId] =
                (vendorReviewCount[vendorId] ?? 0) + 1;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: Text(
                  "Total Reviews: ${reviews.length}",
                  style: TextStyle(fontSize: 20, color: Colors.teal[700]),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    var review = reviews[index];
                    String username = review['username'];
                    String reviewText = review['review'];
                    final rating = review['rating'];
                    Timestamp timestamp = review['timestamp'];
                    DateTime dateTime = timestamp.toDate();
                    String formattedDate =
                        DateFormat('MMMM d, y hh:mm a').format(dateTime);

                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Card(
                        color: Colors.white,
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(username,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[700])),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text(
                                "Rating: $rating",
                                style: TextStyle(
                                    color: Colors.teal[900],
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "$reviewText",
                                style: TextStyle(color: Colors.teal[900]),
                              ),
                              SizedBox(height: 8),
                              Text("Date: $formattedDate",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
