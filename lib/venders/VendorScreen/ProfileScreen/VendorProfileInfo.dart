import 'package:flutter/material.dart';

class Vendorprofileinfo extends StatelessWidget {
  final String fullname;
  final String email;
  final String phone;
  final String address;
  final String logo;

  const Vendorprofileinfo(
      {super.key,
      required this.fullname,
      required this.email,
      required this.phone,
      required this.address,
      required this.logo});

  // ignore: prefer_const_constructors_in_immutables

  Widget listprofileinfo(
      {String? listtitle, String leadingtitle = " ", Color? TextColor}) {
    return ListTile(
      leading: Text(
        leadingtitle!,
        style: TextStyle(fontSize: 14),
      ),
      title: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Text(
            listtitle!,
            style: TextStyle(color: TextColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.only(left: 29, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Center(
              child: CircleAvatar(
                radius: 45,
                child: ClipOval(
                  child: Image.network(
                    logo,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text('Change profile ',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins-Regular',
                      color: Colors.teal)),
            ),
            Divider(
              height: 50,
              color: Colors.grey,
              // indent: 12,
              // endIndent: 12,
            ),
            Text("Profile Information",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(
              height: 25,
            ),
            listprofileinfo(
              leadingtitle: "Name :",
              listtitle: fullname,
            ),
            listprofileinfo(
              leadingtitle: "email :",
              listtitle: email,
            ),
            listprofileinfo(
              leadingtitle: "Phone :",
              listtitle: phone,
            ),
            listprofileinfo(
              leadingtitle: "address :",
              listtitle: address,
            )
          ],
        ),
      ),
    );
  }
}
