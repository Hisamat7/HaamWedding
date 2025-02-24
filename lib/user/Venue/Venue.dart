import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedweel/user/VendorMainINUser.dart';
import 'package:wedweel/user/Venue/VenueDetails.dart';

class Venue extends StatelessWidget {
  final String collectionName = "services"; // Firestore collection name

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            title: Text(
              "Venues",
              style: TextStyle(
                fontSize: 19,
                fontFamily: 'Poppins-Medium',
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 21, 101, 93),
              ),
            )),
        backgroundColor: Color.fromARGB(255, 237, 250, 244),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(collectionName)
              .where('category', isEqualTo: 'venue') // Filter by category
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No venues available"));
            }

            final List<DocumentSnapshot> documents = snapshot.data!.docs;

            return Container(
              height: MediaQuery.of(context).size.height,
              width: double.maxFinite,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final data =
                            documents[index].data() as Map<String, dynamic>;
                            final isVenueVendor = data['category'] == 'venue';


                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Venuedetails(
                                  isvenuevendor: isVenueVendor,
                                  vendorid: data['vendor_id'],
                                  phonenumber: data['phone'] ?? 'No Phone',
                                  vendorname: data['name'] ?? 'No Name',
                                  location: data['location'] ?? 'No Location',
                                  price: data['price'] ?? 'No Price',
                                  vendorphoto: data['image'] ?? '',
                                  guestcount: data['number_of_guests'] ??
                                      'No Guest Count',
                                  description:
                                      data['description'] ?? 'No Description',
                                  category: data['category'] ?? 'No Category',
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Vendormaininuser(
                              vendorId: documents[index].id,
                              vendorname: data['name'] ?? 'No Name',
                              location: data['location'] ?? 'No Location',
                              price: data['price'] ?? 'No Price',
                              vendorimage: data['image'] ?? '',
                              guestcount:
                                  data['number_of_guests'] ?? 'No Guest Count',
                              isVenueVendor: isVenueVendor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
