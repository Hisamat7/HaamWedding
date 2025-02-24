import 'package:flutter/material.dart';

class Paymentvendor extends StatelessWidget {
  Widget payment(
      {required String name, required String date, IconData? verified}) {
    return ListTile(
      leading: Container(
        width: 45,
        height: 45,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.lightBlue),
        child: Icon(
          verified,
          color: Colors.white,
        ),
      ),
      title: Text(name),
      subtitle: Text(date),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 237, 250, 244),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Center(
            child: Text(
              "History",
              style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 23,
                  color: Color.fromARGB(255, 21, 101, 93),
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        body: Column(
          children: [
            TabBar(
                labelColor: Color.fromARGB(255, 21, 101, 93),
                indicatorColor: Color.fromARGB(255, 21, 101, 93),
                tabs: [
                  Tab(
                    text: "All",
                  ),
                  Tab(
                    text: "Received",
                  ),
                  Tab(
                    text: "Pending",
                  )
                ]),
            Expanded(
              child: TabBarView(children: [
                ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return payment(
                      name: "mufeeda",
                      date: "Today, 2.45pm",
                      verified: Icons.arrow_forward,
                    );
                  },
                ),
                ListView.builder(
                  itemCount: 10,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return payment(
                      name: "ajay",
                      date: "22-09-2022",
                      verified: Icons.arrow_forward,
                    );
                  },
                ),
                ListView.builder(
                  itemCount: 10,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return payment(
                        name: "Ajmal Roshan",
                        date: "Yesterday, 9.15",
                        verified: Icons.pending_actions);
                  },
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
