import 'package:flutter/material.dart';

class PolicyProfileVendor extends StatelessWidget {
  Widget listpolicy(
      {IconData listicon = Icons.arrow_forward_ios_outlined,
      String listtitle = " "}) {
    return ListTile(
      leading: Icon(listicon, size: 12, color: Colors.red),
      title: Text(
        listtitle,
        style: TextStyle(fontSize: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Privacy Policy",
          style: TextStyle(
              fontFamily: 'Poppins-Medium',
              fontSize: 23,
              color: Color.fromARGB(255, 21, 101, 93),
              fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.all(15),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Protecting Your Information",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins-Medium',
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "WedWheel is committed to protecting your privacy. We collect basic information like your name, email, phone number, and business details to provide our services. We use this information to:",
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Poppins-Regular',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    listpolicy(listtitle: "Process payments for your services"),
                    listpolicy(
                        listtitle:
                            "Communicate with you about your account and services."),
                    listpolicy(
                        listtitle:
                            "Improve our platform based on your feedback."),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Your Rights",
                      style:
                          TextStyle(fontSize: 15, fontFamily: 'Poppins-Medium'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    listpolicy(
                        listtitle:
                            "Access and review your personal information."),
                    listpolicy(
                        listtitle: "Request corrections to your information."),
                    listpolicy(
                        listtitle: "Request deletion of your information.")
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
