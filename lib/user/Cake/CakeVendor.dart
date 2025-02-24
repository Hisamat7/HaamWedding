import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedweel/user/VendorMainINUser.dart';
import 'package:wedweel/user/Cake/CakeDetails.dart';

class Cakevendor extends StatelessWidget {
  final String collectionName = "services";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          title: Text(
            "Cake Vendors",
            style: TextStyle(
              fontSize: 19,
              fontFamily: 'Poppins-Medium',
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 21, 101, 93),
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 237, 250, 244),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(collectionName)
              .where('category', isEqualTo: 'cake') // Filter by category
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No cake vendors available"));
            }

            final List<DocumentSnapshot> documents = snapshot.data!.docs;

            return Container(
              height: MediaQuery.of(context).size.height,
              width: double.maxFinite,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final data =
                            documents[index].data() as Map<String, dynamic>;

                        // Determine isVenueVendor based on the category
                        final isVenueVendor = data['category'] == 'venue';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Cakedetails(
                                  isVenueVendor: isVenueVendor,
                                  vendorid: data['vendor_id'],
                                  number: data['phone'] ?? 'No Phone',
                                  name: data['name'] ?? 'No Name',
                                  vendorlocation: data['location'] ?? 'No Location',
                                  vendorprice: data['price'] ?? 'No Price',
                                  vendorphoto: data['image'] ?? '',
                                  vendorDescription:
                                      data['description'] ?? 'No Description',
                                  vendorcategory: data['category'] ?? 'No Category',
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Vendormaininuser(
                              vendorId:data['vendor_id'] ,
                              vendorname: data['name'] ?? 'No Name',
                              location: data['location'] ?? 'No Location',
                              price: data['price'] ?? 'No Price',
                              vendorimage: data['image'] ?? '',
                              isVenueVendor: isVenueVendor, // Pass the dynamic value
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