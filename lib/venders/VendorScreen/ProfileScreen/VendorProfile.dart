import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wedweel/venders/VendorScreen/ProfileScreen/EditProfileVendor.dart';
import 'package:wedweel/venders/VendorScreen/ProfileScreen/PolicyProfileVendor.dart';
import 'package:wedweel/venders/VendorScreen/ProfileScreen/VendorProfileInfo.dart';
import 'package:wedweel/venders/screen/LoginVendor.dart';

class Vendorprofile extends StatefulWidget {
  final String fullname;
  final String email;
  final phone;
  final address;
  final logo;
  final document;

  Vendorprofile(
      {super.key,
      required this.fullname,
      required this.email,
      required this.phone,
      required this.address,
      required this.logo,
      required this.document});

  @override
  State<Vendorprofile> createState() => _VendorprofileState();
}

class _VendorprofileState extends State<Vendorprofile> {
  final String vendorid = FirebaseAuth.instance.currentUser!.uid;

  TextEditingController fullnameController = TextEditingController();
  TextEditingController logoController = TextEditingController();

  void initState() {
    fullnameController.text = widget.fullname;

    logoController.text = widget.logo;

    super.initState();
  }

  Widget listprofile(
      {String? listtitle,
      IconData? listicon,
      String leadingtitle = " ",
      Color? TextColor}) {
    return ListTile(
      leading: Icon(
        listicon,
        color: Colors.blue,
      ),
      title: Text(
        listtitle!,
        style: TextStyle(color: TextColor),
      ),
      // trailing: Icon(listicon, color: Colors.blue),
      trailing: Text(
        leadingtitle,
        style: TextStyle(color: Color.fromARGB(255, 21, 101, 93), fontSize: 13),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Profile",
            style: TextStyle(
                fontFamily: 'Poppins-Regular',
                fontSize: 23,
                color: Color.fromARGB(255, 21, 101, 93),
                fontWeight: FontWeight.w500)),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Center(
              child: CircleAvatar(
                radius: 45,
                child: ClipOval(
                  child: Image.network(
                    width: double.infinity,
                    widget.logo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.fullname,
              style: TextStyle(
                  fontSize: 18, color: Color.fromARGB(255, 21, 101, 93)),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Editprofilevendor(
                              address: widget.address,
                              document: widget.document,
                              email: widget.email,
                              fullname: widget.fullname,
                              logo: widget.logo,
                              phone: widget.phone,
                            )));
              },
              child: Text(
                "Edit Profile",
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 237, 250, 244),
                minimumSize: (Size(150, 35)),
                shape: StadiumBorder(),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Vendorprofileinfo(
                              address: widget.address,
                              email: widget.email,
                              fullname: widget.fullname,
                              logo: widget.logo,
                              phone: widget.phone,
                            )));
              },
              child: listprofile(
                  listtitle: "information",
                  listicon: Icons.info,
                  leadingtitle: ">"),
            ),
            listprofile(
                listicon: Icons.translate,
                leadingtitle: "English",
                listtitle: "Language"),
            listprofile(
                listicon: Icons.support_agent_outlined,
                listtitle: "Help & Support"),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PolicyProfileVendor()));
              },
              child: listprofile(
                  listtitle: "Privacy Policy",
                  listicon: Icons.privacy_tip_outlined),
            ),
            GestureDetector(
              onTap: () {
                logout(context);
              },
              child: listprofile(
                  listtitle: "Logout",
                  listicon: Icons.logout_outlined,
                  TextColor: Colors.red),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    // Redirect to the vendor login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Loginvendor()),
      (route) => false,
    );
  } catch (e) {
    // Show an error if logout fails
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error logging out: $e')),
    );
  }
}
