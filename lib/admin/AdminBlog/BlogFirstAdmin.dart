import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedweel/admin/AdminBlog/AddBlog.dart';
import 'package:wedweel/admin/AdminBlog/BlogDetail.dart';
import 'package:wedweel/admin/AdminBlog/EditBlog.dart';

class Blogfirstadmin extends StatelessWidget {
  Widget bottombutton({
    required String name,
    required Color color,
    VoidCallback? onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(
        name,
        style: TextStyle(color: Color.fromARGB(255, 21, 101, 93), fontSize: 15),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(150.w, 40.h),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color),
          borderRadius: BorderRadius.circular(6),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Text(
          "Blogs",
          style: TextStyle(
            fontSize: 21.sp,
            fontFamily: 'Poppins-Medium',
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 21, 101, 93),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 10, left: 10),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddBlog()),
            );
          },
          child: Icon(
            Icons.add,
            color: Color.fromARGB(255, 21, 101, 93),
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 237, 250, 244),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('blog').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          } else {
            final data = snapshot.data!.docs;

            return isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Expanded(
                        child: Container(
                          height: 250.h,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final blogId = data[index].id; // Get the blog ID
                              final blogData = data[index].data()
                                  as Map<String, dynamic>; // Get the blog data
                              final blogname = blogData['name'];
                              final read_time = blogData['read_time'];
                              final image = blogData['image'];

                              return Container(
                                padding: EdgeInsets.all(10),
                                height: 225.h,
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              image,
                                              height: 140.h,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                blogname,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Poppins-Medium',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(height: 5.h),
                                              Text(
                                                read_time,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              SizedBox(height: 13.h),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Blogdetail(
                                                        blogtitle:
                                                            blogData['name'],
                                                        blogdescription:
                                                            blogData[
                                                                'description'],
                                                        blogimage:
                                                            blogData['image'],
                                                        blogdate:
                                                            blogData['date'],
                                                        readtime: blogData[
                                                            'read_time'],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  "Read More",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-Medium',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        bottombutton(
                                          name: "Edit Blog",
                                          color: Colors.green,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditBlog(
                                                  blogId: blogId,
                                                  blogData: blogData,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        bottombutton(
                                          name: "Delete Blog",
                                          color: Colors.red,
                                          onTap: () {
                                            // Show confirmation dialog
                                            showDeleteConfirmationDialog(
                                                context, blogId);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
          }
        },
      ),
    );
  }

  // Function to show the delete confirmation dialog
  void showDeleteConfirmationDialog(BuildContext context, String blogId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure?"),
          content: Text("Do you want to delete this blog?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await deleteBlog(blogId, context);
              },
              child: Text(
                "OK",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // Function to delete the blog and show a result dialog
  Future<void> deleteBlog(String blogId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('blog').doc(blogId).delete();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Blog deleted successfully."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the success dialog
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Show error dialog
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Failed to delete blog: $e"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
