import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedweel/user/Transaction.dart';

import 'package:wedweel/user/profile/Wishlist/Wishlist.dart';
import 'package:wedweel/user/profile/bookings/UserBooking.dart';
import 'package:wedweel/user/profile/editProfile/EditUserProfile.dart';
import 'package:wedweel/user/profile/privacyPolicy/PrivacyPolicyUser.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key, required this.logout});

  final Future<void> Function() logout;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isLoading = false; // Loading state for logout

  // Helper function for consistent ListTile UI
  Widget buttonaction({required String name, VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        name,
        style: TextStyle(color: Colors.teal[900]),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 244, 255, 249),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(color: Colors.greenAccent),
        ),
      ),
    );
  }

  Widget listContainer({
    required IconData iconleading,
    required String name,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Container(
          height: 30.h,
          width: 30.w,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 178, 215, 181),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(iconleading, size: 20),
        ),
        title: Text(name,
            style: const TextStyle(color: Color.fromARGB(255, 2, 118, 104))),
        trailing: Container(
          height: 30.h,
          width: 30.w,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 178, 215, 181),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.arrow_forward_ios, size: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text(
            'Profile Information',
            style: TextStyle(
              fontSize: 19,
              fontFamily: 'Poppins-Medium',
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 21, 101, 93),
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 237, 250, 244),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('user')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator(
                color: Color.fromARGB(255, 54, 219, 142),
                backgroundColor: Color.fromARGB(255, 89, 243, 207),
              ));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(
                color: Color.fromARGB(255, 54, 219, 142),
                backgroundColor: Color.fromARGB(255, 89, 243, 207),
              ));
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('User data not found'));
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final phone = data['phone'] ?? 'Phone Number';
            final address = data['address'] ?? 'Address';
            final image = data['image'];
            final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

            return Column(
              children: [
                SizedBox(height: 15.h),
                Center(
                  child: CircleAvatar(
                    backgroundImage: image != null && image.isNotEmpty
                        ? NetworkImage(image)
                        : const AssetImage('asset/wedlogo.jpg')
                            as ImageProvider,
                    radius: 30,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  data['fullName'] ?? 'User Name',
                  style: const TextStyle(
                    fontFamily: 'Poppins-Regular',
                    fontSize: 20,
                    color: Color.fromARGB(255, 21, 101, 93),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),

                // Profile Options
                Container(
                  height: 180.h,
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 249, 255, 251),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      listContainer(
                        iconleading: Icons.person,
                        name: "Edit Profile",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserProfile(
                              image: image,
                              email: data['email'],
                              fullname: data['fullName'],
                              phone: phone,
                              address: address,
                            ),
                          ),
                        ),
                      ),
                      listContainer(
                        iconleading: Icons.favorite,
                        name: 'Wishlist',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WishlistPage()),
                        ),
                      ),
                      listContainer(
                        iconleading: Icons.view_kanban,
                        name: 'My Bookings',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserBookingsScreen(
                                    userId: userId,
                                  )),
                        ),
                      ),
                    ],
                  ),
                ),

                // More Options
                Container(
                  height: 180.h,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 249, 255, 251),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TransactionScreen()));
                        },
                        child: listContainer(
                            iconleading: Icons.paid, name: 'Transactions'),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showComplientDialog(
                              userId: userId, userName: data['fullName']);
                        },
                        child: listContainer(
                            iconleading: Icons.info, name: 'Complaints'),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showfeedbackDialog(
                              userId: userId, userName: data['fullName']);
                        },
                        child: listContainer(
                            iconleading: Icons.rate_review,
                            name: 'Share Feedback'),
                      ),
                    ],
                  ),
                ),

                // Privacy and Logout
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 249, 255, 251),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      listContainer(
                        iconleading: Icons.security,
                        name: 'Privacy Policy',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Privacypolicyuser()),
                        ),
                      ),
                      listContainer(
                        iconleading: Icons.logout,
                        name: 'Logout',
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });

                          await widget.logout();

                          if (!mounted) return;

                          setState(() {
                            isLoading = false;
                          });

                          // Redirect to login or home screen after logout
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showComplientDialog(
      {required String userId, required String userName}) {
    final TextEditingController _complaintController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 225, 255, 237),
          content: Container(
            height: 120,
            child: TextFormField(
              controller: _complaintController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Give your Complaint",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      BorderSide(color: const Color.fromARGB(255, 14, 86, 0)),
                ),
              ),
            ),
          ),
          actions: [
            buttonaction(
              name: "Cancel",
              onPressed: () => Navigator.pop(context),
            ),
            buttonaction(
              name: "Add",
              onPressed: () async {
                final complaint = _complaintController.text.trim();
                if (complaint.isNotEmpty) {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await FirebaseFirestore.instance
                        .collection('complaints')
                        .add({
                      'userId': userId,
                      'userName': userName,
                      'complaint': complaint,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showfeedbackDialog({required String userId, required String userName}) {
    final TextEditingController _feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 225, 255, 237),
          content: Container(
            height: 120,
            child: TextFormField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Give your feedback",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      BorderSide(color: const Color.fromARGB(255, 14, 86, 0)),
                ),
              ),
            ),
          ),
          actions: [
            buttonaction(
              name: "Submit",
              onPressed: () async {
                final feedback = _feedbackController.text.trim();
                if (feedback.isNotEmpty) {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await FirebaseFirestore.instance
                        .collection('feedback')
                        .add({
                      'userId': userId,
                      'userName': userName,
                      'feedback': feedback,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
