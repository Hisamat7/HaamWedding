import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Editprofilevendor extends StatefulWidget {
  final String fullname;
  final String email;
  final phone;
  final address;
  final logo;
  final document;
  Editprofilevendor(
      {super.key,
      required this.fullname,
      required this.email,
      required this.phone,
      required this.address,
      required this.logo,
      required this.document});

  @override
  State<Editprofilevendor> createState() => _EditprofilevendorState();
}

class _EditprofilevendorState extends State<Editprofilevendor> {
  File? image;
  bool isLoading = false;
  final String vendorid = FirebaseAuth.instance.currentUser!.uid;

  TextEditingController fullnameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController addressController = TextEditingController();
  void initState() {
    fullnameController.text = widget.fullname;
    emailController.text = widget.email;
    phoneController.text = widget.phone;
    addressController.text = widget.address;

    super.initState();
  }

  Widget editProfile(
      {String? labelname,
      String? hintname,
      IconData? iconprofile,
      TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(27),
              borderSide: BorderSide(color: Colors.teal, width: 1)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(27),
          ),
          labelText: labelname,
          hintText: hintname,
          prefixIcon: Icon(
            iconprofile,
            color: Color.fromARGB(255, 21, 101, 93),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins-Medium',
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 21, 101, 93),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color.fromARGB(255, 237, 250, 244),
      body: Padding(
        padding: EdgeInsets.only(top: 40, left: 40, right: 40),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Stack(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    child: ClipOval(
                      child: Image.network(
                        widget.logo,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 55,
                    right: 100,
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: CircleBorder(
                              side: BorderSide(color: Colors.white),
                            )),
                        onPressed: () async {
                          image = await uploadImage();
                        },
                        label: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.black,
                          size: 17,
                        )))
              ],
            ),
            SizedBox(
              height: 50,
            ),
            editProfile(
                controller: fullnameController,
                labelname: "Name",
                hintname: "Wedcom",
                iconprofile: Icons.person),
            SizedBox(
              height: 14,
            ),
            editProfile(
                controller: emailController,
                labelname: "Email",
                hintname: "Wedcom@gmailcom",
                iconprofile: Icons.email_outlined),
            SizedBox(
              height: 14,
            ),
            editProfile(
                controller: phoneController,
                labelname: "Phone",
                hintname: "1234567890",
                iconprofile: Icons.phone_android_outlined),
            SizedBox(
              height: 14,
            ),
            editProfile(
                controller: addressController,
                labelname: "Address",
                hintname: "Calicut",
                iconprofile: Icons.location_on_outlined),
            SizedBox(
              height: 14,
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Image.network(widget.document),
                  ),
                );
              },
              child: Text(
                "View document",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Poppins-Medium',
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(320, 50),
                  backgroundColor: Color.fromARGB(255, 235, 250, 244),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: const Color.fromARGB(255, 121, 116, 116)),
                      borderRadius: BorderRadius.circular(40))),
            ),
            SizedBox(
              height: 41,
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await FirebaseFirestore.instance
                    .collection("vendor")
                    .doc(vendorid)
                    .update({
                  "fullname": fullnameController.text,
                  "email": emailController.text,
                  "phone": phoneController.text,
                  "address": addressController.text,
                  "image": image
                });
                setState(() {
                  isLoading = false;
                });
              },
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Poppins-Medium',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(280, 50),
                  backgroundColor: Color.fromARGB(255, 208, 255, 233),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
            )
          ],
        ),
      ),
    );
  }

  Future<File?> uploadImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    final imageFile = image != null ? File(image.path) : null;

    return imageFile;
  }
}
