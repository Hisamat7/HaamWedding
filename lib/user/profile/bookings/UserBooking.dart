import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedweel/user/bootomNavBar.dart';

class UserBookingsScreen extends StatefulWidget {
  final String userId;

  const UserBookingsScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _UserBookingsScreenState createState() => _UserBookingsScreenState();
}

class _UserBookingsScreenState extends State<UserBookingsScreen> {
  List<Map<String, dynamic>> _bookings = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUserBookings();
  }

  Future<void> _fetchUserBookings() async {
    try {
      // Fetch all bookings for the user
      QuerySnapshot bookingsSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: widget.userId)
          .get();

      if (bookingsSnapshot.docs.isNotEmpty) {
        // Fetch vendor details for each booking
        List<Map<String, dynamic>> bookingsWithVendorDetails = [];
        for (var bookingDoc in bookingsSnapshot.docs) {
          Map<String, dynamic> bookingData =
              bookingDoc.data() as Map<String, dynamic>;

          // Fetch vendor details from the 'services' collection
          QuerySnapshot vendorSnapshot = await FirebaseFirestore.instance
              .collection('services')
              .where('vendor_id', isEqualTo: bookingData['vendorId'])
              .get();

          if (vendorSnapshot.docs.isNotEmpty) {
            Map<String, dynamic> vendorData =
                vendorSnapshot.docs.first.data() as Map<String, dynamic>;

            // Combine booking and vendor data
            bookingsWithVendorDetails.add({
              ...bookingData,
              'vendorName': vendorData['name'],
              'vendorImage': vendorData['image'],
              'vendorLocation': vendorData['location'], // Fetch vendor location
              'vendorPrice': vendorData['price'], // Fetch vendor price
            });
          } else {
            // If vendor details are not found, add booking data without vendor details
            bookingsWithVendorDetails.add({
              ...bookingData,
              'vendorName': 'Unknown Vendor',
              'vendorImage': '',
              'vendorLocation': 'N/A', // Default location
              'vendorPrice': 'N/A', // Default price
            });
          }
        }

        setState(() {
          _bookings = bookingsWithVendorDetails;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "No bookings found for this user.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching bookings: $e";
        _isLoading = false;
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "My Bookings",
          style: TextStyle(color: Colors.teal[700]),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _bookings.length,
                  itemBuilder: (context, index) {
                    final booking = _bookings[index];
                    return Card(
                      color: const Color.fromARGB(255, 232, 255, 250),
                      margin: EdgeInsets.only(bottom: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Vendor Image and Name
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    booking['vendorImage'] ?? '',
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Icon(Icons.broken_image, size: 80),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    Text(
                                      booking['vendorName'] ?? 'Unknown Vendor',
                                      style: TextStyle(
                                        color: Colors.teal[700],
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.teal[700],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          booking['vendorLocation'] ?? 'N/A',
                                          style: TextStyle(
                                              color: Colors.teal[700]),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.attach_money,
                                          color: Colors.teal[700],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          booking['vendorPrice'] ?? 'N/A',
                                          style: TextStyle(
                                              color: Colors.teal[700]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            // Booking Details

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "startDate",
                                  style: TextStyle(color: Colors.teal[700]),
                                ),
                                Text(
                                  "endDate",
                                  style: TextStyle(color: Colors.teal[700]),
                                ),
                              ],
                            ),
                            SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "${booking['startDate'] ?? 'N/A'}",
                                  style: TextStyle(color: Colors.teal[700]),
                                ),
                                Text(
                                  " ${booking['endDate'] ?? 'N/A'}",
                                  style: TextStyle(color: Colors.teal[700]),
                                ),
                              ],
                            ),

                            SizedBox(height: 8),

                            Row(
                              children: [],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
