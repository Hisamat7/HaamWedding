import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  @override
  State<TransactionScreen> createState() => _TransactionState();
}

class _TransactionState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: Center(
        child: Text(
          "Currently this screen is not available",
          style:
              TextStyle(fontSize: 16, color: Color.fromARGB(255, 21, 101, 93)),
        ),
      ),
    );
  }
}
