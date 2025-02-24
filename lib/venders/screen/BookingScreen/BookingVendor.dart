import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VendorBookingScreen extends StatefulWidget {
  @override
  _VendorBookingScreenState createState() => _VendorBookingScreenState();
}

class _VendorBookingScreenState extends State<VendorBookingScreen> {
  String? vendorId;

  @override
  void initState() {
    super.initState();
    vendorId = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> _updateBookingStatus(String bookingId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection("bookings")
        .doc(bookingId)
        .update({"status": newStatus});
  }

  @override
  Widget build(BuildContext context) {
    if (vendorId == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Vendor Bookings")),
        body: Center(child: Text("Please log in to view bookings.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title:
            Text("Vendor Bookings", style: TextStyle(color: Colors.teal[800])),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("bookings")
            .where("vendorId", isEqualTo: vendorId)
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No bookings yet."));
          }

          return ListView(
            padding: EdgeInsets.only(top: 20, left: 15, right: 15),
            children: snapshot.data!.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: const Color.fromARGB(255, 223, 255, 242),
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        "${data["name"]}",
                        style: TextStyle(
                          color: Colors.teal[800],
                          fontSize: 18,
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        color: const Color.fromARGB(255, 223, 255, 242),
                        onSelected: (String value) {
                          _updateBookingStatus(doc.id, value);
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            value: "confirmed",
                            child: Text(
                              "Confirmed",
                              style: TextStyle(
                                color: Colors.teal[800],
                                fontSize: 15,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: "completed",
                            child: Text(
                              "Completed",
                              style: TextStyle(
                                color: Colors.teal[800],
                                fontSize: 15,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: "canceled",
                            child: Text(
                              "Canceled",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Start Date ",
                                style: TextStyle(
                                  color: Colors.teal[800],
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "End Date ",
                                style: TextStyle(
                                  color: Colors.teal[800],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                data["startDate"],
                                style: TextStyle(
                                  color: Colors.teal[800],
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                data["endDate"],
                                style: TextStyle(
                                  color: Colors.teal[800],
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Phone : ${data["phone"]}",
                            style: TextStyle(
                              color: Colors.teal[800],
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Address: ${data["address"]}",
                            style: TextStyle(
                              color: const Color.fromRGBO(0, 105, 92, 1),
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Status :  ${data["status"]}",
                            style: TextStyle(
                              color: Colors.teal[800],
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
