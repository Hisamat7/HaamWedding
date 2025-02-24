import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditServiceVendor extends StatefulWidget {
  final String serviceId; // Service ID to identify the document in Firestore

  EditServiceVendor({Key? key, required this.serviceId}) : super(key: key);

  @override
  _EditServiceVendorState createState() => _EditServiceVendorState();
}

class _EditServiceVendorState extends State<EditServiceVendor> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController serviceCapacityController =
      TextEditingController();
  final TextEditingController locationNameController = TextEditingController();
  final TextEditingController servicePriceController = TextEditingController();
  final TextEditingController serviceDescriptionController =
      TextEditingController();

  File? image;
  bool isLoading = true; // For loading spinner
  String? currentVendorId;
  List<Map<String, dynamic>> servicesList = []; // List to store services
  String? selectedServiceId; // Selected service ID from dropdown
  String? selectedCategory; // Selected category from dropdown

  // List of categories
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

  @override
  void initState() {
    super.initState();
    currentVendorId =
        FirebaseAuth.instance.currentUser?.uid; // Current vendor's ID
    fetchServices(); // Fetch the list of services
  }

  Future<void> fetchServices() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('services')
          .where('vendor_id', isEqualTo: currentVendorId)
          .get();

      setState(() {
        servicesList = querySnapshot.docs.map((doc) {
          return {
            'phone': doc['phone'],
            'id': doc.id,
            'location': doc['location'],
            'price': doc['price'],
            'description': doc['description'],
            'category': doc['category'],
            if (doc['category'] == "venue")
              'number_of_guests': doc['number_of_guests'],
          };
        }).toList();
      });

      // After fetching the services, fetch the data for the specific service being edited
      fetchServiceData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching services: $e")),
      );
    }
  }

  Future<void> fetchServiceData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('services')
          .doc(widget.serviceId)
          .get();

      if (docSnapshot.exists &&
          docSnapshot.data()?['vendor_id'] == currentVendorId) {
        final data = docSnapshot.data()!;
        serviceCapacityController.text = data['number_of_guests'] ?? '';
        locationNameController.text = data['location'] ?? '';
        servicePriceController.text = data['price'] ?? '';
        serviceDescriptionController.text = data['description'] ?? '';
        phoneController.text = data['phone'] ?? '';
        selectedCategory =
            data['category'] ?? 'vendor'; // Set the selected category

        // Set the selectedServiceId to the service being edited
        setState(() {
          selectedServiceId = widget.serviceId;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Service not found or access denied.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching service: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onServiceSelected(String? serviceId) {
    if (serviceId == null) return;

    setState(() {
      selectedServiceId = serviceId;
    });

    final selectedService =
        servicesList.firstWhere((service) => service['id'] == serviceId);
    locationNameController.text = selectedService['location'];
    servicePriceController.text = selectedService['price'];
    serviceDescriptionController.text = selectedService['description'];
    selectedCategory = selectedService['category'];
    phoneController.text = selectedService['phone'];
  }

  void onCategorySelected(String? category) {
    if (category == null) return;

    setState(() {
      selectedCategory = category;
    });
  }

  Future<void> updateService() async {
    if (locationNameController.text.isEmpty ||
        servicePriceController.text.isEmpty ||
        serviceDescriptionController.text.isEmpty ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields.")),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      final dataToUpdate = {
        'number_of_guests': serviceCapacityController.text,
        'phone': phoneController.text,
        'location': locationNameController.text,
        'price': servicePriceController.text,
        'description': serviceDescriptionController.text,
        'category': selectedCategory,
      };

      await FirebaseFirestore.instance
          .collection('services')
          .doc(
              selectedServiceId) // Use selectedServiceId to update the correct service
          .update(dataToUpdate);

      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('Your service has been updated successfully.'),
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
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating service: $e")),
      );
    }
  }

  Future<File?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    return pickedImage != null ? File(pickedImage.path) : null;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Service",
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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Location",
                          style: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize: 17,
                              color: Colors.black),
                        ),
                        SizedBox(height: 6),
                        TextFormField(
                          controller:locationNameController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.teal, width: 1),
                            ),
                            hintText: "Service Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        image = await pickImage();
                        setState(() {});
                      },
                      child: image != null
                          ? Image.file(image!, height: 100, width: 100)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'asset/upload.jpeg',
                                height: 100,
                                width: 100,
                              ),
                            ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Price",
                  style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 17,
                      color: Colors.black),
                ),
              ),
              SizedBox(height: 6),
              TextField(
                controller: servicePriceController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.teal, width: 1),
                  ),
                  hintText: "Service Price",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Phone Number",
                  style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 17,
                      color: Colors.black),
                ),
              ),
              SizedBox(height: 6),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.teal, width: 1),
                  ),
                  hintText: "Enter phone number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Description",
                  style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 17,
                      color: Colors.black),
                ),
              ),
              SizedBox(height: 6),
              TextField(
                controller: serviceDescriptionController,
                maxLines: 6,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.teal, width: 1),
                  ),
                  hintText: "Describe your service",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              if (selectedCategory == 'venue')
                Column(children: [
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Capacity",
                      style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 17,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 6),
                  TextField(
                      controller: serviceCapacityController,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.teal, width: 1),
                          ),
                          hintText: "Capacity",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )))
                ]),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Category",
                  style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 17,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                hint: Text(
                  "Select a category",
                  style: TextStyle(color: Colors.black54),
                ),
                onChanged: onCategorySelected,
                items: categories.map<DropdownMenuItem<String>>((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.teal, width: 1),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                dropdownColor: const Color.fromARGB(255, 249, 255, 254),
              ),
              SizedBox(height: 26),
              ElevatedButton(
                onPressed: updateService,
                child: Text(
                  "Edit Service",
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
