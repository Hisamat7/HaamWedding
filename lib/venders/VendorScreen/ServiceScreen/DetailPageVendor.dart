import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedweel/main.dart';

class Detailpagevendor extends StatelessWidget {
  final String collectionName = "services";

  Widget name({required String name}) {
    return Text(name,
        style:
            TextStyle(fontSize: 20, color: Color.fromARGB(255, 21, 101, 93)));
  }

  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Text(
          'Product Details',
          style: TextStyle(color: Color.fromARGB(255, 21, 101, 93)),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: userId == null
          ? Center(child: Text("User not logged in"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(collectionName)
                  .where('vendor_id', isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No services available"));
                }

                final List<DocumentSnapshot> documents = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final data =
                        documents[index].data() as Map<String, dynamic>;
                    return Column(
                      children: [
                        Container(
                          height: 300.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.r),
                              bottomRight: Radius.circular(30.r),
                            ),
                            child:Image.network(
  data['image'] ?? '', // Provide an empty string if data['image'] is null
  fit: BoxFit.cover,
  width: double.infinity,
  errorBuilder: (context, error, stackTrace) {
    // Handle image loading errors
    return const Icon(Icons.error); 
  },
),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20.h),
                          padding: EdgeInsets.only(left: 18.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              name(name: "Description"),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                data['description'],
                                style: TextStyle(color: Colors.teal),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              name(name: "Price"),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                data['price'],
                                style:
                                    TextStyle(color: Colors.teal, fontSize: 17),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              name(name: "Category"),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                data['category'],
                                style:
                                    TextStyle(color: Colors.teal, fontSize: 17),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              name(name: "Location"),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                data['location'],
                                style:
                                    TextStyle(color: Colors.teal, fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
    );
  }
}
