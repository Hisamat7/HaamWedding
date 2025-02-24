import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'BookingConfirmationScreen.dart';

class UserBookingScreen extends StatefulWidget {
  final String vendorId;

  const UserBookingScreen({super.key, required this.vendorId});

  @override
  State<UserBookingScreen> createState() => _UserBookingScreenState();
}

class _UserBookingScreenState extends State<UserBookingScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 237, 255, 246),
          title: Text("Payment Successful"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
    await _submitBooking(); // Proceed with booking after successful payment
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet Selected: ${response.walletName}")),
    );
  }

  void _openRazorpayCheckout() async {
    // Check if the date range is available before proceeding with payment
    bool isDateRangeAvailable = await _checkDateRangeAvailability();
    if (!isDateRangeAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selected date range is already booked.")),
      );
      return;
    }

    var options = {
      'key': 'rzp_test_a66YOERQYDJCVb', // Replace with your Razorpay API key
      'amount': 100 * 100, // Amount in paise (e.g., 100 INR = 10000 paise)
      'name': 'Booking Payment',
      'description': 'Payment for booking service',
      'prefill': {
        'contact': phoneController.text,
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<bool> _checkDateRangeAvailability() async {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select both start and end dates.")),
      );
      return false;
    }

    String formattedStartDate =
        "${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}";
    String formattedEndDate =
        "${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}";

    try {
      QuerySnapshot overlappingBookings = await FirebaseFirestore.instance
          .collection("bookings")
          .where("vendorId", isEqualTo: widget.vendorId)
          .where("status", isEqualTo: "pending") // Only check pending bookings
          .get();

      for (var doc in overlappingBookings.docs) {
        String existingStartDate = doc["startDate"];
        String existingEndDate = doc["endDate"];

        // Check if the selected date range overlaps with any existing booking
        if ((formattedStartDate.compareTo(existingEndDate) <= 0 &&
            formattedEndDate.compareTo(existingStartDate) >= 0)) {
          return false;
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error checking date availability: $e")),
      );
      return false;
    }

    return true;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    // Fetch all bookings for the vendor
    QuerySnapshot bookings = await FirebaseFirestore.instance
        .collection("bookings")
        .where("vendorId", isEqualTo: widget.vendorId)
        .where("status", isEqualTo: "pending")
        .get();

    // Extract booked dates
    Set<DateTime> bookedDates = {};
    for (var doc in bookings.docs) {
      DateTime startDate = DateTime.parse(doc["startDate"]);
      DateTime endDate = DateTime.parse(doc["endDate"]);
      for (DateTime date = startDate;
          date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
          date = date.add(Duration(days: 1))) {
        bookedDates.add(date);
      }
    }

    // Determine the initial date for the date picker
    DateTime initialDate = DateTime.now();
    if (isStartDate && _startDate != null && _isDateSelectable(_startDate!, bookedDates)) {
      initialDate = _startDate!;
    } else if (!isStartDate && _endDate != null && _isDateSelectable(_endDate!, bookedDates)) {
      initialDate = _endDate!;
    }

    // Ensure the initial date is selectable
    while (!_isDateSelectable(initialDate, bookedDates)) {
      initialDate = initialDate.add(Duration(days: 1));
    }

    // Show date picker with selectableDayPredicate
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      selectableDayPredicate: (DateTime date) {
        // Disable dates that are already booked
        return !bookedDates.any((bookedDate) =>
            bookedDate.year == date.year &&
            bookedDate.month == date.month &&
            bookedDate.day == date.day);
      },
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.teal[800]!, // Body text color
            ),
            dialogBackgroundColor: Colors.white, // Background color of the dialog
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  // Helper method to check if a date is selectable
  bool _isDateSelectable(DateTime date, Set<DateTime> bookedDates) {
    return !bookedDates.any((bookedDate) =>
        bookedDate.year == date.year &&
        bookedDate.month == date.month &&
        bookedDate.day == date.day);
  }

  Future<void> _submitBooking() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You need to be logged in to book.")),
      );
      return;
    }

    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        _startDate == null ||
        _endDate == null ||
        addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields.")),
      );
      return;
    }

    // Format dates for comparison
    String formattedStartDate =
        "${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}";
    String formattedEndDate =
        "${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}";

    // Check for overlapping bookings
    try {
      QuerySnapshot overlappingBookings = await FirebaseFirestore.instance
          .collection("bookings")
          .where("vendorId", isEqualTo: widget.vendorId)
          .where("status", isEqualTo: "pending") // Only check pending bookings
          .get();

      bool isDateRangeAvailable = true;

      for (var doc in overlappingBookings.docs) {
        String existingStartDate = doc["startDate"];
        String existingEndDate = doc["endDate"];

        // Check if the selected date range overlaps with any existing booking
        if ((formattedStartDate.compareTo(existingEndDate) <= 0 &&
            formattedEndDate.compareTo(existingStartDate) >= 0)) {
          isDateRangeAvailable = false;
          break;
        }
      }

      if (!isDateRangeAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selected date range is already booked.")),
        );
        return;
      }

      // If the date range is available, proceed with booking
      DocumentReference bookingRef =
          await FirebaseFirestore.instance.collection("bookings").add({
        "vendorId": widget.vendorId,
        "userId": userId,
        "name": nameController.text,
        "phone": phoneController.text,
        "startDate": formattedStartDate,
        "endDate": formattedEndDate,
        "address": addressController.text,
        "timestamp": FieldValue.serverTimestamp(),
        "status": "pending",
      });

      String bookingId = bookingRef.id;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking saved successfully!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BookingConfirmationScreen(
            vendorId: widget.vendorId,
            bookingId: bookingId,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving booking: $e")),
      );
    }
  }

  Widget buildDateButton({required String label, required bool isStartDate}) {
    return FutureBuilder<bool>(
      future: isStartDate
          ? (_startDate != null ? _isDateAvailable(_startDate!) : Future.value(true))
          : (_endDate != null ? _isDateAvailable(_endDate!) : Future.value(true)),
      builder: (context, snapshot) {
        // Show a loading button while checking availability
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ElevatedButton(
            onPressed: () => _selectDate(context, isStartDate),
            child: Text(
              isStartDate
                  ? (_startDate != null
                      ? "${_startDate!.toLocal()}".split(' ')[0]
                      : label)
                  : (_endDate != null
                      ? "${_endDate!.toLocal()}".split(' ')[0]
                      : label),
              style: TextStyle(fontSize: 16, color: Colors.teal[700]),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          );
        }

        // If the future is complete, check if the date is available
        final isAvailable = snapshot.data ?? true;

        return ElevatedButton(
          onPressed: () => _selectDate(context, isStartDate),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isStartDate
                    ? (_startDate != null
                        ? "${_startDate!.toLocal()}".split(' ')[0]
                        : label)
                    : (_endDate != null
                        ? "${_endDate!.toLocal()}".split(' ')[0]
                        : label),
                style: TextStyle(fontSize: 16, color: Colors.teal[700]),
              ),
              if (!isAvailable)
                Icon(Icons.close, color: Colors.red, size: 16),
            ],
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _isDateAvailable(DateTime date) async {
  QuerySnapshot bookings = await FirebaseFirestore.instance
      .collection("bookings")
      .where("vendorId", isEqualTo: widget.vendorId)
      .where("status", isEqualTo: "pending")
      .get();

  for (var doc in bookings.docs) {
    DateTime startDate = DateTime.parse(doc["startDate"]);
    DateTime endDate = DateTime.parse(doc["endDate"]);

    if (date.isAfter(startDate.subtract(Duration(days: 1))) &&
        date.isBefore(endDate.add(Duration(days: 1)))) {
      return false;
    }
  }
  return true;
}


  Widget buildTextField(
      {required String label,
      required TextEditingController controller,
      int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18, color: Colors.teal[800])),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLines == 3 ? 150 : null,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: const Color.fromARGB(255, 2, 122, 108)),
                borderRadius: BorderRadius.circular(6)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: const Color.fromARGB(255, 101, 255, 181)),
                borderRadius: BorderRadius.circular(6)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          title: Text(
            "Book a Service",
            style: TextStyle(color: Colors.teal[800]),
          )),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: ListView(
          children: [
            buildTextField(label: "Name", controller: nameController),
            SizedBox(height: 15.h),
            buildTextField(label: "Phone", controller: phoneController),
            SizedBox(height: 15.h),
            Text("Select Date",
                style: TextStyle(fontSize: 18, color: Colors.teal[800])),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildDateButton(label: "Start Date", isStartDate: true),
                buildDateButton(label: "End Date", isStartDate: false),
              ],
            ),
            SizedBox(height: 30.h),
            buildTextField(
                label: "Address", controller: addressController, maxLines: 3),
            SizedBox(height: 30.h),
            // Slide-to-Confirm using SlideAction
            SlideAction(
              onSubmit: () {
                _openRazorpayCheckout(); // Trigger payment when slid
              },
              sliderButtonIconPadding: 10,
              sliderRotate: false,
              borderRadius: 12,
              sliderButtonIcon: Icon(
                Icons.lock_open,
                color: Colors.white,
                size: 25,
              ),
              outerColor: Colors.teal[200],
              innerColor: const Color.fromARGB(255, 10, 103, 92),
              text: "Slide to pay      ",
              textStyle: TextStyle(
                fontSize: 18,
                color: Colors.teal[900],
              ),
              elevation: 0,
              submittedIcon: Icon(Icons.check, color: Colors.white),
              alignment: Alignment.centerRight,
            ),
          ],
        ),
      ),
    );
  }
}