import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'AddServiceVendor.dart';
import 'DetailPageVendor.dart';
import 'EditServiceVendor.dart';

class ServiceFirstScreen extends StatelessWidget {
  Widget screenContainer({
    required String name,
    required String image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        width: 50,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 10),
            Image.asset(
              image,
              fit: BoxFit.cover,
              height: 95,
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins-Regular',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String vendorId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: Color.fromARGB(255, 237, 250, 244),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('services')
            .where('vendor_id', isEqualTo: vendorId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Something went wrong.'));
          }

          final services = snapshot.data?.docs ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  "My Service",
                  style: TextStyle(
                    fontSize: 27,
                    color: Color.fromARGB(255, 21, 101, 93),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Expanded(
                child: GridView.count(
                  padding: EdgeInsets.all(15),
                  crossAxisCount: 2,
                  mainAxisSpacing: 17,
                  crossAxisSpacing: 17,
                  children: [
                    // Static Actions
                    screenContainer(
                      name: "Product Details",
                      image: "asset/information_14875512.png",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Detailpagevendor(),
                          ),
                        );
                      },
                    ),
                    screenContainer(
                      name: "Add Service",
                      image: "asset/essay_3253267.png",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddServiceVendor(),
                          ),
                        );
                      },
                    ),
                    // Dynamic Service Items
                    if (services.isEmpty)
                      screenContainer(
                        name: "Edit Service",
                        image: 'asset/engineering_13337559.png',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No services to edit.')),
                          );
                        },
                      ),
                    if (services.isNotEmpty)
                      ...services.map((service) {
                        final serviceId = service.id;

                        return screenContainer(
                          name: "Edit Service",
                          image: 'asset/engineering_13337559.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditServiceVendor(serviceId: serviceId),
                              ),
                            );
                          },
                        );
                      }).toList(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
