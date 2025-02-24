import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wedweel/admin/screen/ManageVendorDetails.dart';

class Managevendor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: const Center(
            child: Text(
              "Manage Vendor",
              style: TextStyle(
                fontFamily: 'Poppins-Regular',
                fontSize: 23,
                color: Color.fromARGB(255, 21, 101, 93),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            const TabBar(tabs: [
              Tab(
                icon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                text: "Pending",
              ),
              Tab(
                text: "Approved",
              )
            ]),
            Expanded(
              child: TabBarView(
                children: [
                  // Pending Vendors Tab
                  VendorList(isApproved: false),
                  // Approved Vendors Tab
                  VendorList(isApproved: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VendorList extends StatelessWidget {
  final bool isApproved;

  VendorList({required this.isApproved});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('vendor')
          .where('IsAdminApproved', isEqualTo: isApproved)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "No ${isApproved ? "approved" : "pending"} vendors found.",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final vendors = snapshot.data!.docs;

        return ListView.builder(
          itemCount: vendors.length,
          itemBuilder: (context, index) {
            final vendor = vendors[index];
            return VendorCard(
              docid: vendor.id,
              email: vendor['email'],
              name: vendor['fullname'],
              address: vendor['address'],
              phone: vendor['phone'],
              document: vendor['document'],
              logo: vendor['logo'],
              isApproved: isApproved,
            );
          },
        );
      },
    );
  }
}

class VendorCard extends StatelessWidget {
  final String name;
  final String address;
  final String phone;
  final String document;
  final String logo;
  final bool isApproved;
  final String email;
  final String docid;

  VendorCard({
    required this.docid,
    required this.email,
    required this.name,
    required this.address,
    required this.phone,
    required this.document,
    required this.logo,
    required this.isApproved,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Managevendordetails(
              email: email,
              name: name,
              address: address,
              document: document,
              logo: logo,
              phone: phone,
              isApproved: isApproved,
            ),
          ),
        );
      },
      child: Card(
        color: const Color.fromARGB(255, 238, 255, 247),
        margin: const EdgeInsets.all(15),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(logo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(address),
                        Text(phone),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(height: 30, color: Colors.grey[350]),
              Row(
                children: [
                  const Icon(Icons.picture_as_pdf, color: Colors.red),
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                title: Text('Document'),
                                content: Image.network(document),
                                actions: [
                                  TextButton(
                                      child: Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      })
                                ]);
                          });
                    },
                    child: const Text(
                      "View Document",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              if (!isApproved)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: const BorderSide(color: Colors.green),
                        ),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('vendor')
                              .doc(docid)
                              .update({
                            'IsAdminApproved': true,
                          });
                        },
                        child: const Text(
                          'Accept',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: const BorderSide(color: Colors.red),
                        ),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('vendor')
                              .doc(docid)
                              .delete();
                          // Handle Reject logic
                        },
                        child: const Text(
                          'Reject',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
