import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text('Your Wishlist'),
      ),
      body: user == null
          ? Center(
              child: Text('You need to be logged in to view your wishlist.'),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('wishlist')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Your wishlist is empty.'));
                }

                final wishlistItems = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: wishlistItems.length,
                  itemBuilder: (context, index) {
                    final item =
                        wishlistItems[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item['vendorimage'],
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        item['vendorname'],
                        style: TextStyle(
                            color: const Color.fromARGB(255, 20, 74, 49)),
                      ),
                      subtitle: Text(item['location']),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outlined,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('wishlist')
                              .doc(item['vendorname'])
                              .delete();
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
