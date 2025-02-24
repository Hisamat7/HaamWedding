import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedweel/admin/AdminBlog/AddBlog.dart';

class Wishlistdetailpage extends StatelessWidget {
  final String vendorname;
  final String location;
  final String vendorimage;
  final String price;
  final String vendordescription;
  final String guestnumber;
  final String phonenumber;
  final String id;

 Wishlistdetailpage({
    required this.id,
    this.phonenumber = " ",
    this.guestnumber = " ",
    required this.vendorname,
    required this.location,
    required this.vendorimage,
    required this.price,
    required this.vendordescription,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            title: Text("Vendor Details"),
          ),
          backgroundColor: const Color.fromARGB(255, 251, 255, 254),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 170.h,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    vendorimage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ListTile(
                title: Text(vendorname,
                    style: TextStyle(
                        fontSize: 15, color: Color.fromARGB(255, 21, 101, 93))),
                trailing: Text(
                  "Rs: $price",
                  style: TextStyle(
                      fontSize: 15, color: Color.fromARGB(255, 21, 101, 93)),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 18, right: 18),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star_border,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 10),
                          Text("5.0"),
                          SizedBox(width: 10),
                          Text("(2348 Reviews)"),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              color: Color.fromARGB(255, 21, 101, 93)),
                          SizedBox(width: 10.w),
                          Text(location),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        children: [
                          Text("Contact"),
                          Spacer(),
                          Text(phonenumber)
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      // TabBar
                      TabBar(
                        tabs: [
                          Tab(text: 'Description'),
                          Tab(text: 'Review'),
                          Tab(text: 'Slot'),
                        ],
                        labelColor: const Color.fromARGB(255, 27, 95, 58),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: const Color.fromARGB(255, 212, 209, 51),
                      ),
                      // TabBarView
                      Expanded(
                        child: TabBarView(
                          children: [
                            // Description Tab
                            Column(
                              children: [
                                Container(
                                  height: 185.h,
                                  child: ListView(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 10, right: 10),
                                        child: Text(vendordescription),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Book Now",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 178, 215, 181),
                                      minimumSize: Size(double.infinity, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                              ],
                            ),
                            // Review Tab
                            ListView(
                              children: [
                                Container(
                                  height: 185.h,
                                  child: ListView.builder(
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            ListTile(
                                              leading: CircleAvatar(
                                                radius: 20,
                                              ),
                                              title: Text("name"),
                                              subtitle: Text("review"),
                                            ),
                                            Text("describe"),
                                            Divider(
                                              height: 20,
                                            )
                                          ],
                                        );
                                      }),
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 178, 215, 181),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => ReviewDialog(),
                                      );
                                    },
                                    child: Text(
                                      "Add review",
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 18, 95, 57)),
                                    ))
                              ],
                            ),
                            // Slot Tab
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                child: ListView.builder(
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text("date"),
                                        subtitle: Text("time"),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewDialog extends StatefulWidget {
  @override
  _ReviewDialogState createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Review"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rating Bar
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
              size: 10,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          SizedBox(height: 20),
          // Review Description
          TextField(
            controller: _reviewController,
            decoration: InputDecoration(
              hintText: "Write your review...",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            // Save the review and rating
            final String review = _reviewController.text;
            print("Rating: $_rating, Review: $review");

            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text("Submit"),
        ),
      ],
    );
  }
}
