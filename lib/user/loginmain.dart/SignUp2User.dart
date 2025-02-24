// import 'package:cloudinary/cloudinary.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';

// import 'dart:io';

// class Signup2user extends StatefulWidget {
//   @override
//   _CompleteProfilePageState createState() => _CompleteProfilePageState();
// }

// class _CompleteProfilePageState extends State<Signup2user> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   File? _profileImage;
//   DateTime? _weddingDate;
//   final ImagePicker _picker = ImagePicker();

//   // Initialize Cloudinary
//   final Cloudinary cloudinary = Cloudinary.fromCloudName(cloudName: 'YOUR_CLOUD_NAME');

//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _profileImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _selectWeddingDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );

//     if (pickedDate != null) {
//       setState(() {
//         _weddingDate = pickedDate;
//       });
//     }
//   }

//   Future<void> _uploadImageToCloudinary() async {
//     if (_profileImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please select a profile photo.")),
//       );
//       return null;
//     }

//     try {
//       // Upload image to Cloudinary
//       final response = await cloudinary.upload(
//         file: _profileImage!.path,
//         resourceType: CloudinaryResourceType.image,
//         folder: "profile_images", // Optional: Organize images in a folder
//       );

//       if (response.isSuccessful) {
//         return response.secureUrl; // Return the uploaded image URL
//       } else {
//         throw Exception("Failed to upload image: ${response.error}");
//       }
//     } catch (e) {
//       throw Exception("Failed to upload image: $e");
//     }
//   }

//   Future<void> _saveProfile() async {
//     if (_profileImage == null || _weddingDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please upload a profile photo and select a wedding date.")),
//       );
//       return;
//     }

//     final user = _auth.currentUser;
//     if (user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("You must be logged in to complete your profile.")),
//       );
//       return;
//     }

//     try {
//       // Upload profile photo to Cloudinary
//       final photoUrl = await _uploadImageToCloudinary();

//       // Save profile data to Firestore
//       await _firestore.collection('users').doc(user.uid).set({
//         'profilePhoto': photoUrl,
//         'weddingDate': _weddingDate,
//       }, SetOptions(merge: true));

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Profile updated successfully!")),
//       );

//       // Navigate to the next screen (e.g., home page)
//       Navigator.pushReplacementNamed(context, '/home');
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to update profile: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Complete Your Profile"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: _pickImage,
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
//                 child: _profileImage == null
//                     ? Icon(Icons.camera_alt, size: 50, color: Colors.grey)
//                     : null,
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               "Upload Profile Photo",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: () => _selectWeddingDate(context),
//               child: Text(
//                 _weddingDate == null
//                     ? "Select Wedding Date"
//                     : "Wedding Date: ${DateFormat('yyyy-MM-dd').format(_weddingDate!)}",
//                 style: TextStyle(fontSize: 16),
//               ),
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//               ),
//             ),
//             SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: _saveProfile,
//               child: Text(
//                 "Save Profile",
//                 style: TextStyle(fontSize: 18),
//               ),
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }