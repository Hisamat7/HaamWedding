import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Manageuser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Manage User",
          style: TextStyle(
              fontFamily: 'Poppins-Regular',
              fontSize: 23,
              color: Color.fromARGB(255, 21, 101, 93),
              fontWeight: FontWeight.w500),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('user').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              final data = snapshot.data!.docs;
              return ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final String fullname = data[index]['fullName'];
                  final String email = data[index]['email'];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Color.fromARGB(255, 238, 255, 247),
                    margin: EdgeInsets.all(20),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                fullname,
                                style: TextStyle(
                                    fontFamily: 'Poppins-Medium', fontSize: 20),
                              ),
                              Spacer(),
                              Icon(
                                Icons.badge,
                                size: 30,
                                color: const Color.fromARGB(255, 1, 58, 3),
                              ),
                            ],
                          ),
                          Divider(
                            height: 30,
                            color: Colors.grey[350],
                          ),
                          Row(
                            children: [
                              Text(email,
                                  style: TextStyle(
                                      fontFamily: 'Poppins-Medium',
                                      fontSize: 18)),
                              Spacer(),
                              Icon(
                                Icons.mail,
                                size: 30,
                                color: const Color.fromARGB(255, 1, 58, 3),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
