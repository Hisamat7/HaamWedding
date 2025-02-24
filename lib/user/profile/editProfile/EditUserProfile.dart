import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wedweel/AddCloudinaryImage.dart';
import 'package:wedweel/admin/AdminBlog/AddBlog.dart';

class EditUserProfile extends StatefulWidget {
  final String fullname;
  final String email;
  final phone;
  final address;
  final String? image;

  EditUserProfile(
      {super.key,
      required this.image,
      required this.fullname,
      required this.email,
      required this.phone,
      required this.address});

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  File? image;

  bool isLoading = false;

  final String userid = FirebaseAuth.instance.currentUser!.uid;

  TextEditingController fullnameController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String? imageuril;

  @override
  void initState() {
    fullnameController.text = widget.fullname;
    emailController.text = widget.email;
    phoneController.text = widget.phone;
    addressController.text = widget.address;
    imageuril = widget.image;
    super.initState();
  }

  Widget editProfile(
      {String? labelname,
      String? hintname,
      IconData? iconprofile,
      TextEditingController? controller}) {
    return Container(
      height: 50.h,
      margin: EdgeInsets.all(13.w),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.teal, width: 1)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            labelText: labelname,
            hintText: hintname,
            prefixIcon: Icon(
              iconprofile,
              color: Color.fromARGB(255, 21, 101, 93),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 22.sp,
            fontFamily: 'Poppins-Medium',
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 21, 101, 93),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color.fromARGB(255, 237, 250, 244),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30.h,
            ),
            Stack(
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundImage: imageuril == null
                        ? AssetImage('asset/wedlogo.jpg')
                        : NetworkImage(imageuril!),
                    radius: 55.r,
                  ),
                ),
                Positioned(
                    top: 65.h,
                    right: 130.w,
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
                          size: 17.sp,
                        )))
              ],
            ),
            SizedBox(
              height: 40.h,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 249, 255, 251),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: Column(
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  editProfile(
                      controller: fullnameController,
                      labelname: 'fullname',
                      hintname: "Wedcom",
                      iconprofile: Icons.person),
                  editProfile(
                      controller: emailController,
                      labelname: "Email",
                      hintname: "Wedcom@gmailcom",
                      iconprofile: Icons.email_outlined),
                  editProfile(
                      controller: phoneController,
                      labelname: 'phone',
                      hintname: "1234567890",
                      iconprofile: Icons.phone_android_outlined),
                  editProfile(
                      controller: addressController,
                      labelname: "Address",
                      hintname: "Calicut",
                      iconprofile: Icons.location_on_outlined),
                  SizedBox(
                    height: 30.h,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      if (image != null) {
                        imageuril = await uploadImageToCloudinary(image!);
                      }

                      await FirebaseFirestore.instance
                          .collection("user")
                          .doc(userid)
                          .update({
                        "fullName": fullnameController.text,
                        "email": emailController.text,
                        "phone": phoneController.text,
                        "address": addressController.text,
                        "image": imageuril
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
                              fontSize: 18.sp,
                              fontFamily: 'Poppins-Medium',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(280, 50),
                        backgroundColor: Color.fromARGB(255, 208, 255, 233),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ],
              ),
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
