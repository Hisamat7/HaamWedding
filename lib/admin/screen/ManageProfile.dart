import 'package:flutter/material.dart';

class Manageprofile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Manage profile",
            style: TextStyle(
                fontFamily: 'Poppins-Regular',
                fontSize: 23,
                color: Color.fromARGB(255, 21, 101, 93),
                fontWeight: FontWeight.w500)),
      ),
      body: const Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Center(
            child: CircleAvatar(
              backgroundImage: AssetImage('asset/wedlogo.jpg'),
              radius: 55,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Admin",
                  style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 25,
                      color: Color.fromARGB(255, 21, 101, 93),
                      fontWeight: FontWeight.w500))
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Personal information",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins-Regular',
                  ),
                ),
              )
            ],
          ),
          Card(
              elevation: 3,
              color: Color.fromARGB(255, 238, 255, 247),
              margin: EdgeInsets.all(20),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 0, 0, 0),
                          size: 23,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Email",
                          style: TextStyle(
                              fontFamily: 'Poppins-medium',
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Text(
                          "admin@gmail.com",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
