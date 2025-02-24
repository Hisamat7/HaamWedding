import 'package:flutter/material.dart';

class Managevendordetails extends StatelessWidget {
  final String name;
  final String address;
  final String phone;
  final String document;
  final String logo;
  final bool isApproved;
  final String email;

  const Managevendordetails(
      {super.key,
      required this.name,
      required this.address,
      required this.phone,
      required this.document,
      required this.logo,
      required this.isApproved,
      required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 250, 244),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(20),
                height: 210,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(logo), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                color: const Color.fromARGB(255, 245, 255, 245),
                margin: EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'Poppins-Medium',
                            color: Color.fromARGB(255, 1, 58, 3),
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 27,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            address,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppins-Medium',
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 27,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "5.0",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                color: const Color.fromARGB(255, 245, 255, 245),
                margin: EdgeInsets.all(20),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            phone,
                            style: TextStyle(
                                fontFamily: 'Poppins-Medium', fontSize: 20),
                          ),
                          Spacer(),
                          Icon(
                            Icons.call,
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
                          Text(
                            email,
                            style: TextStyle(
                                fontFamily: 'Poppins-Medium', fontSize: 18),
                          ),
                          Spacer(),
                          Icon(
                            Icons.email,
                            size: 30,
                            color: const Color.fromARGB(255, 1, 58, 3),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                color: const Color.fromARGB(255, 245, 255, 245),
                margin: EdgeInsets.all(20),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(children: [
                        Icon(
                          Icons.picture_as_pdf,
                          size: 30,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: Text('Document'),
                                        content: Image.network(document),
                                        actions: [
                                          TextButton(
                                              child: Text('Close'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              })
                                        ]);
                                  });
                            },
                            child: Text(
                              'View Document',
                              style: TextStyle(
                                  fontFamily: 'Poppins-Medium',
                                  fontSize: 20,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                            ))
                      ]),
                    ],
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
