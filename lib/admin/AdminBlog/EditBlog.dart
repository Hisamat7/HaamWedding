import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedweel/AddCloudinaryImage.dart';

class EditBlog extends StatefulWidget {
  final String blogId;
  final Map<String, dynamic> blogData;

  EditBlog({required this.blogId, required this.blogData});

  @override
  State<EditBlog> createState() => _EditBlogState();
}

class _EditBlogState extends State<EditBlog> {
  final TextEditingController blogNameController = TextEditingController();
  final TextEditingController blogReadtimeController = TextEditingController();
  final TextEditingController blogDescriptionController = TextEditingController();
  final TextEditingController blogDateController = TextEditingController();

  File? image;
  String? currentImageUrl;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing blog data
    blogNameController.text = widget.blogData['name'];
    blogReadtimeController.text = widget.blogData['read_time'];
    blogDescriptionController.text = widget.blogData['description'];
    blogDateController.text = widget.blogData['date'];
    currentImageUrl = widget.blogData['image'];
  }

  Widget textField({
    required String labelName,
    required String hintName,
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelName,
          style: TextStyle(fontSize: 17, fontFamily: 'Poppins-Regular'),
        ),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.teal, width: 1),
            ),
            hintText: hintName,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Blog",
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Blog Name",
                          style: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize: 17,
                              color: Colors.black),
                        ),
                        SizedBox(height: 6),
                        TextFormField(
                          controller: blogNameController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.teal, width: 1),
                            ),
                            hintText: "Blog name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                          : currentImageUrl != null
                              ? Image.network(
                                  currentImageUrl!,
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
              SizedBox(height: 30),
              textField(
                labelName: "Read time",
                hintName: "5 min",
                controller: blogReadtimeController,
              ),
              SizedBox(height: 14.h),
              textField(
                labelName: "Date",
                hintName:
                    "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                controller: blogDateController
                  ..text =
                      "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                readOnly: true,
              ),
              SizedBox(height: 30.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Blog Description",
                      style: TextStyle(
                          fontSize: 17, fontFamily: 'Poppins-Regular')),
                  SizedBox(height: 6),
                  TextFormField(
                    controller: blogDescriptionController,
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
              SizedBox(height: 46),
              ElevatedButton(
                onPressed: () async {
                  await updateBlogInFirebase(context);
                },
                child: Text(
                  "Update Blog",
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

  Future<void> updateBlogInFirebase(BuildContext context) async {
    if (blogNameController.text.isEmpty ||
        blogReadtimeController.text.isEmpty ||
        blogDescriptionController.text.isEmpty ||
        blogDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields.")),
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
      String? imageUrl = currentImageUrl;

      // If a new image is selected, upload it to Cloudinary
      if (image != null) {
        imageUrl = await uploadImageToCloudinary(image!);
      }

      // Update data in Firestore
      await FirebaseFirestore.instance
          .collection('blog')
          .doc(widget.blogId)
          .update({
        'name': blogNameController.text,
        'date': blogDateController.text,
        'description': blogDescriptionController.text,
        'read_time': blogReadtimeController.text,
        'image': imageUrl,
      });

      Navigator.pop(context); // Close the loading dialog
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('Blog has been updated successfully.'),
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
      Navigator.pop(context); // Close the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}