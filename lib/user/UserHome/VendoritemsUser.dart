import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedweel/user/UserHome/CardSectionGrid.dart';

class Vendoritemsuser extends StatelessWidget {
  // Function to fetch top 3 vendors based on average rating
  Future<List<Map<String, dynamic>>> getTop3Vendors() async {
    // Fetch all reviews from Firestore
    final QuerySnapshot reviewSnapshot =
        await FirebaseFirestore.instance.collection('reviews').get();

    // Group reviews by vendorId
    final Map<String, List<double>> vendorRatings = {};

    for (final doc in reviewSnapshot.docs) {
      final String vendorId = doc['vendorId'];
      final double rating = doc['rating'].toDouble();

      if (vendorRatings.containsKey(vendorId)) {
        vendorRatings[vendorId]!.add(rating);
      } else {
        vendorRatings[vendorId] = [rating];
      }
    }

    // Calculate average rating for each vendor
    final List<Map<String, dynamic>> vendorsWithAverageRating = [];

    vendorRatings.forEach((vendorId, ratings) {
      final double averageRating =
          ratings.reduce((a, b) => a + b) / ratings.length;
      vendorsWithAverageRating.add({
        'vendorId': vendorId,
        'averageRating': averageRating,
        'totalReviews': ratings.length,
      });
    });

    // Sort vendors by averageRating in descending order
    vendorsWithAverageRating
        .sort((a, b) => b['averageRating'].compareTo(a['averageRating']));

    // Select top 3 vendors
    final top3Vendors = vendorsWithAverageRating.take(3).toList();

    return top3Vendors;
  }

  // Function to fetch vendor details (name and image) from the services collection
  Future<Map<String, dynamic>> getVendorDetails(String vendorId) async {
    final QuerySnapshot vendorSnapshot = await FirebaseFirestore.instance
        .collection('services')
        .where('vendor_id', isEqualTo: vendorId)
        .get();

    if (vendorSnapshot.docs.isNotEmpty) {
      final vendorData = vendorSnapshot.docs.first;
      return {
        'name': vendorData['name'],
        'image': vendorData['image'],
      };
    } else {
      return {
        'name': 'Unknown Vendor',
        'image': 'asset/biscoticake.jpg', // Fallback image
      };
    }
  }

  // Function to fetch details for all top vendors
  Future<List<Map<String, dynamic>>> getTopVendorsWithDetails() async {
    final top3Vendors = await getTop3Vendors();
    final List<Map<String, dynamic>> vendorsWithDetails = [];

    for (final vendor in top3Vendors) {
      final vendorDetails = await getVendorDetails(vendor['vendorId']);
      vendorsWithDetails.add({
        ...vendor,
        ...vendorDetails,
      });
    }

    return vendorsWithDetails;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Vendors",
            style: TextStyle(
              fontSize: 21,
              fontFamily: 'Poppins-Medium',
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 21, 101, 93),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Color.fromARGB(255, 237, 250, 244),
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              CardSectionGrid(),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  "Top Vendors",
                  style: TextStyle(
                    fontSize: 21,
                    height: 3,
                    fontFamily: 'Poppins-Medium',
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 21, 101, 93),
                  ),
                ),
              ),
              Container(
                height: 180,
                padding: EdgeInsets.only(left: 10),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: getTopVendorsWithDetails(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: Colors.greenAccent,
                        backgroundColor:
                            const Color.fromARGB(255, 128, 222, 206),
                      ));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No vendors found.'));
                    } else {
                      final topVendors = snapshot.data!;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: topVendors.length,
                        itemBuilder: (context, index) {
                          final vendor = topVendors[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Container(
                              height: 150,
                              width: 300,
                              margin: EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        vendor[
                                            'image'], // Fetch image from Firestore
                                        height: 175,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            'asset/biscoticake.jpg', // Fallback image
                                            height: 175,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            "${index + 1}",
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontFamily: 'Poppins-Medium',
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                  255, 21, 101, 93),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          vendor[
                                              'name'], // Fetch name from Firestore
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: 'Poppins-Medium',
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(
                                                255, 21, 101, 93),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
