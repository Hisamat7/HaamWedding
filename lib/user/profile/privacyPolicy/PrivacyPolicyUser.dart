import 'package:flutter/material.dart';

class Privacypolicyuser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 237, 250, 244),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: Text(
            "Privacy Policy",
            style: TextStyle(
                fontFamily: 'Poppins-Medium',
                fontSize: 23,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 21, 101, 93)),
          ),
        ),
        body: Expanded(
            child: Container(
                margin: EdgeInsets.only(left: 20, right: 10, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView(
                      shrinkWrap: true,
                      children: [
                        Text(
                          "Protecting Your Information",
                          style: TextStyle(
                            color: Colors.teal[800],
                          ),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Text(
                          "At WedWheel, we value your privacy and are committed to protecting your personal information. This policy explains how we collect and use your 1  data when you use our wedding planning app",
                          style:
                              TextStyle(fontSize: 11, color: Colors.teal[800]),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Text(
                          "What Information We Collect",
                          style: TextStyle(
                            color: Colors.teal[800],
                          ),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Text(
                          "We collect information you provide, like your name, email, and wedding details. We may also collect information about how you use the app.",
                          style:
                              TextStyle(fontSize: 11, color: Colors.teal[800]),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Text("How We Use Your Information:",
                            style: TextStyle(
                              color: Colors.teal[800],
                            )),
                        SizedBox(
                          height: 13,
                        ),
                        Text(
                            "We use the information to provide and improve the app, respond to your requests, and communicate with you.",
                            style: TextStyle(
                                fontSize: 11, color: Colors.teal[800])),
                        SizedBox(
                          height: 13,
                        ),
                        Text("Sharing Your Information:",
                            style: TextStyle(
                              color: Colors.teal[800],
                            )),
                        SizedBox(height: 13),
                        Text(
                          'We may share your information with trusted vendors you choose to work with. We may also share information with companies that help us run our business, like payment processors.',
                          style:
                              TextStyle(fontSize: 11, color: Colors.teal[800]),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Text("Your Rights:",
                            style: TextStyle(
                              color: Colors.teal[800],
                            )),
                        SizedBox(
                          height: 13,
                        ),
                        Text(
                          "You can access and update your information.\nYou can request that we delete your account.",
                          style:
                              TextStyle(fontSize: 11, color: Colors.teal[800]),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Text("Changes to This Privacy Policy:",
                            style: TextStyle(
                              color: Colors.teal[800],
                            )),
                        SizedBox(
                          height: 13,
                        ),
                        Text(
                          "We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page.",
                          style:
                              TextStyle(fontSize: 11, color: Colors.teal[800]),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Text(
                          "Contact Us:",
                          style: TextStyle(
                            color: Colors.teal[800],
                          ),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Text(
                          "If you have any questions or concerns about this privacy policy, please contact us at HaamWedding@gmail.com.",
                          style:
                              TextStyle(fontSize: 11, color: Colors.teal[800]),
                        ),
                      ],
                    )
                  ],
                ))),
      ),
    );
  }
}
