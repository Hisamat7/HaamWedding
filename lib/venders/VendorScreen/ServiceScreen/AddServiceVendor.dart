import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedweel/AddCloudinaryImage.dart';

class AddServiceVendor extends StatefulWidget {
  AddServiceVendor({Key? key}) : super(key: key);

  @override
  _AddServiceVendorState createState() => _AddServiceVendorState();
}

class _AddServiceVendorState extends State<AddServiceVendor> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationnameController = TextEditingController();
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController servicePriceController = TextEditingController();
  final TextEditingController serviceDescriptionController =
      TextEditingController();
  final TextEditingController numberOfGuestsController =
      TextEditingController();

  File? image;
  String? selectedCategory;
  final List<String> categories = [
    'vendor',
    'venue',
    'photo',
    'makeup',
    'flower',
    'decoration',
    'food',
    'cake'
  ];
  Widget form(
      {required String labelName,
      required String hintName,
      required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelName,
          style: TextStyle(
            fontSize: 17,
            fontFamily: 'Poppins-Regular',
          ),
        ),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.teal, width: 1),
            ),
            hintText: hintName,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Service",
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins-Medium',
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 21, 101, 93),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 237, 250, 244),
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Category",
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                  SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    dropdownColor: const Color.fromARGB(255, 250, 255, 249),
                    borderRadius: BorderRadius.circular(10),
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                    items: categories
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.teal, width: 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: "Select a category",
                    ),
                  ),
                ],
              ),
              if (selectedCategory == "venue")
                form(
                    labelName: "Number of Guests",
                    hintName: "Enter guest capacity",
                    controller: numberOfGuestsController),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: form(
                        labelName: "Location",
                        hintName: "Enter location",
                        controller: locationnameController),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.white,
                      onTap: () async {
                        image = await pickImage();
                        setState(() {});
                      },
                      child: image != null
                          ? Image.file(
                              image!,
                              height: 100,
                              width: 100,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'asset/upload.jpeg',
                                height: 100,
                                width: 100,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              form(
                  labelName: "Service Price",
                  hintName: "Enter service price",
                  controller: servicePriceController),
              form(
                  labelName: "Vendor Name",
                  hintName: "Enter vendor name",
                  controller: serviceNameController),
              form(
                  labelName: "Phone Number",
                  hintName: "Enter phone number",
                  controller: phoneController),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Service Description",
                    style:
                        TextStyle(fontSize: 17, fontFamily: 'Poppins-Regular'),
                  ),
                  SizedBox(height: 6),
                  TextFormField(
                    controller: serviceDescriptionController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.teal, width: 1),
                      ),
                      hintText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 26),
              ElevatedButton(
                onPressed: () async {
                  await addServiceToFirebase(context);
                },
                child: Text(
                  "Add Service",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Poppins-Medium',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(320, 50),
                  backgroundColor: Color.fromARGB(255, 237, 250, 244),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<File?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    return pickedImage != null ? File(pickedImage.path) : null;
  }

  Future<void> addServiceToFirebase(BuildContext context) async {
    if (serviceNameController.text.isEmpty ||
        servicePriceController.text.isEmpty ||
        serviceDescriptionController.text.isEmpty ||
        image == null ||
        selectedCategory == null ||
        (selectedCategory == "venue" &&
            numberOfGuestsController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Please fill all fields, select an image, and choose a category.")),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      final cloudinaryUrl = await uploadImageToCloudinary(image!);

      await FirebaseFirestore.instance.collection('services').add({
        'location': locationnameController.text,
        'price': servicePriceController.text,
        'description': serviceDescriptionController.text,
        'image': cloudinaryUrl,
        'category': selectedCategory,
        'phone': phoneController.text,
        'vendor_id': FirebaseAuth.instance.currentUser?.uid,
        'name': serviceNameController.text,
        if (selectedCategory == "venue")
          'number_of_guests': numberOfGuestsController.text,
      });

      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('Your service has been added successfully.'),
              actions: [
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}
