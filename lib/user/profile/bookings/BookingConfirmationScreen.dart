import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:wedweel/user/bootomNavBar.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final String vendorId;
  final String bookingId;

  const BookingConfirmationScreen({
    Key? key,
    required this.vendorId,
    required this.bookingId,
  }) : super(key: key);

  @override
  _BookingConfirmationScreenState createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  Map<String, dynamic>? vendorData;
  Map<String, dynamic>? bookingData;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchBookingAndVendorDetails();
  }

  Future<void> _fetchBookingAndVendorDetails() async {
    try {
      // Fetch vendor details
      QuerySnapshot vendorSnapshot = await FirebaseFirestore.instance
          .collection('services')
          .where('vendor_id', isEqualTo: widget.vendorId)
          .get();

      // Fetch booking details
      DocumentSnapshot bookingSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingId)
          .get();

      if (vendorSnapshot.docs.isNotEmpty && bookingSnapshot.exists) {
        setState(() {
          vendorData = vendorSnapshot.docs.first.data() as Map<String, dynamic>;
          bookingData = bookingSnapshot.data() as Map<String, dynamic>;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Vendor or Booking details not found.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching details: $e";
        _isLoading = false;
      });
      print("Error: $e");
    }
  }

  // Function to format Firestore timestamps to readable dates
  String formatDate(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return DateFormat('dd - MM - yyyy').format(timestamp.toDate());
    }
    return "N/A";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Booking Confirmed",
          style: TextStyle(color: Colors.teal[700]),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Booking Details",
                              style: TextStyle(
                                color: Colors.teal[700],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Start Date: ${formatDate(bookingData?['startDate'])}",
                                  style: TextStyle(color: Colors.teal[700]),
                                ),
                                Text(
                                  "End Date: ${formatDate(bookingData?['endDate'])}",
                                  style: TextStyle(color: Colors.teal[700]),
                                ),
                              ],
                            ),
                            Divider(height: 20, thickness: 1),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vendorData?['name'] ?? "Unknown Vendor",
                                        style: TextStyle(
                                          color: Colors.teal[700],
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 50),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    vendorData?['image'] ?? '',
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(Icons.broken_image, size: 80),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (vendorData?['category'] == 'venue') ...[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.teal[300],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Guests",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          vendorData?['number_of_guests']
                                                  ?.toString() ??
                                              'N/A',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.teal[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Price",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        vendorData?['price']?.toString() ??
                                            'N/A',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Divider(height: 10, thickness: 1),
                            ListTile(
                              leading: Icon(
                                Icons.location_on,
                                color: Colors.teal[700],
                              ),
                              title: Text(
                                " ${vendorData?['location'] ?? 'N/A'}",
                                style: TextStyle(color: Colors.teal[700]),
                              ),
                            ),
                            ElevatedButton(
  onPressed: () {
    // Pop all routes until the BottomNavBar is reached
    Navigator.popUntil(context, (route) {
      // Check if the current route is the BottomNavBar
      return route.isFirst; // This ensures we go back to the first route (home screen)
    });
  },
  child: Text(
    "Book Again",
    style: TextStyle(color: Colors.teal[800]),
  ),
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    backgroundColor: Color.fromARGB(255, 175, 255, 216),
  ),
),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
