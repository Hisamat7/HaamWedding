import 'package:flutter/material.dart';
import 'package:wedweel/venders/screen/BookingScreen/BookingVendor.dart';
import 'package:wedweel/venders/screen/BookingScreen/PaymentVendor.dart';

class FirstScreenBooking extends StatelessWidget {
  Widget screen({required String name, required String image}) {
    return Container(
      margin: EdgeInsets.all(20),
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Image.asset(
            image,
            fit: BoxFit.cover,
            height: 145,
            width: 200,
            // width: double.infinity,
          ),
          SizedBox(
            height: 20,
          ),
          Text(name, style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 250, 244),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 237, 250, 244),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => VendorBookingScreen()));
              },
              child: screen(
                name: "Booking",
                image: "asset/Booking.jpeg",
              ),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Paymentvendor()));
                },
                child: screen(name: "Payment", image: "asset/payment.jpg"))
          ],
        ),
      ),
    );
  }
}
