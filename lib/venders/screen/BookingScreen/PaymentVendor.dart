import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Paymentvendor extends StatefulWidget {
  const Paymentvendor({super.key});

  @override
  State<Paymentvendor> createState() => _PaymentvendorState();
}

class _PaymentvendorState extends State<Paymentvendor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: Center(
        child: Text("currently this screen is not available",
            style: TextStyle(fontSize: 16.sp, color: Colors.teal[900])),
      ),
    );
  }
}
