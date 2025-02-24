import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Vendormaininuser extends StatelessWidget {
  final String vendorname;
  final String location;
  final String price;
  final String vendorimage;
  final String guestcount;
  final bool isVenueVendor;
  final String vendorId; // Add vendorId to fetch reviews

  Vendormaininuser({
    required this.vendorname,
    this.guestcount = "",
    required this.location,
    required this.price,
    required this.vendorimage,
    required this.isVenueVendor,
    required this.vendorId, // Initialize vendorId
  });

  // Function to toggle wishlist
  Future<void> toggleWishlist(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in to manage wishlist')),
      );
      return;
    }

    final wishlistRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('wishlist')
        .doc(vendorname); // Use vendorname as the document ID

    // Check if the item is already in the wishlist
    final doc = await wishlistRef.get();
    if (doc.exists) {
      // Remove from wishlist
      await wishlistRef.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed from wishlist')),
      );
    } else {
      // Add to wishlist
      await wishlistRef.set({
        'vendorname': vendorname,
        'location': location,
        'price': price,
        'vendorimage': vendorimage,
        'guestcount': guestcount,
        'isVenueVendor': isVenueVendor,
        'timestamp': FieldValue.serverTimestamp(), // Optional: Add timestamp
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to wishlist')),
      );
    }
  }

  // Function to fetch average rating and total reviews
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

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      height: 310.h,
      margin: EdgeInsets.only(
        left: 27,
        right: 27,
        top: 20,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromARGB(255, 178, 215, 181)),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            height: 150.h,
            width: double.infinity,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(vendorimage, fit: BoxFit.cover)),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            height: 130.h,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: FutureBuilder<Map<String, dynamic>>(
              future: getReviewData(vendorId), // Fetch review data
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Color.fromARGB(255, 113, 255, 161),
                    color: Color.fromARGB(255, 210, 255, 225),
                  ));
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final totalReviews = snapshot.data?['totalReviews'] ?? 0;
                final averageRating = snapshot.data?['averageRating'] ?? 0.0;

                return Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Text(
                          vendorname,
                          style: TextStyle(
                              color: const Color.fromARGB(255, 27, 101, 52)),
                        ),
                        Spacer(),
                        Text(
                          "Rent : $price",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 27, 101, 52)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      children: [
                        Row(
                          children: isVenueVendor
                              ? [
                                  Icon(
                                    Icons.people,
                                    color:
                                        const Color.fromARGB(255, 27, 101, 52),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    guestcount,
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 27, 101, 52)),
                                  ),
                                ]
                              : [
                                  Icon(
                                    Icons.star_outline,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    averageRating.toStringAsFixed(
                                        1), // Display average rating
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[700]),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "($totalReviews Reviews)", // Display total review count
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[700]),
                                  ),
                                ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: const Color.fromARGB(255, 27, 101, 52),
                            ),
                            SizedBox(width: 10),
                            Text(
                              location,
                              style: TextStyle(
                                color: const Color.fromARGB(255, 27, 101, 52),
                              ),
                            ),
                            Spacer(),
                            StreamBuilder<DocumentSnapshot>(
                              stream: user != null
                                  ? FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .collection('wishlist')
                                      .doc(vendorname)
                                      .snapshots()
                                  : null,
                              builder: (context, snapshot) {
                                final isInWishlist =
                                    snapshot.data?.exists ?? false;
                                return IconButton(
                                  icon: Icon(
                                    isInWishlist
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isInWishlist
                                        ? const Color.fromARGB(255, 32, 120, 51)
                                        : Colors.green,
                                  ),
                                  onPressed: () => toggleWishlist(context),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ]);
              },
            ),
          )
        ],
      ),
    );
  }
}
