import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Reviewwidget extends StatefulWidget {
  final vendorId;

  Reviewwidget({required this.vendorId});

  @override
  State<Reviewwidget> createState() => _ReviewwidgetState();
}

class _ReviewwidgetState extends State<Reviewwidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('reviews')
                .where('vendorId', isEqualTo: widget.vendorId)
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 54, 219, 142),
                  backgroundColor: const Color.fromARGB(255, 139, 255, 228),
                ));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No reviews yet."));
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final review = snapshot.data!.docs[index];
                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 54, 219, 142),
                          radius: 20,
                          child: Text(
                            review['username'][0],
                            style: TextStyle(color: Colors.teal[700]),
                          ), // First letter of username
                        ),
                        title: Text(
                          review['username'],
                          style: TextStyle(color: Colors.teal[800]),
                        ), // Display username
                        subtitle: Text("Rating: ${review['rating']}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Text(
                          review['review'],
                          style: TextStyle(color: Colors.teal[700]),
                        ),
                      ),
                      Divider(
                        height: 20.h,
                      )
                    ],
                  );
                },
              );
            },
          ),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 178, 215, 181),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ReviewDialog(vendorId: widget.vendorId),
              );
            },
            child: Text(
              "Add review",
              style: TextStyle(color: const Color.fromARGB(255, 18, 95, 57)),
            ))
      ],
    );
  }
}

class ReviewDialog extends StatefulWidget {
  final String vendorId;

  ReviewDialog({required this.vendorId});

  @override
  _ReviewDialogState createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0;
  String _username = "Guest"; // Default username

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          _username = userDoc['fullName']; // Fetch username from Firestore
        });
      }
    }
  }

  Future<void> _saveReview() async {
    final String review = _reviewController.text;
    final double rating = _rating;

    if (review.isNotEmpty && rating > 0) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('reviews').add({
          'vendorId': widget.vendorId,
          'rating': rating,
          'review': review,
          'userId': user.uid,
          'username': _username, // Store username
          'timestamp': FieldValue.serverTimestamp(),
        });

        Navigator.of(context).pop(); // Close the dialog
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You must be logged in to submit a review.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please provide a rating and review.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 244, 255, 253),
      title: Text(
        "Add Review",
        style: TextStyle(color: Colors.teal[800]),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rating Bar
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
              size: 10,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          SizedBox(height: 20),
          // Review Description
          TextField(
            controller: _reviewController,
            decoration: InputDecoration(
                hintText: "Write your review...",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.teal,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.tealAccent,
                  ),
                )),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        TextButton(
          onPressed: _saveReview,
          child: Text(
            "Submit",
            style: TextStyle(
              color: Colors.teal[700],
            ),
          ),
        ),
      ],
    );
  }
}
