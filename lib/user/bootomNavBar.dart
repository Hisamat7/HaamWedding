import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedweel/user/TodoUser/TodoUser.dart';
import 'package:wedweel/user/UserFirst.dart';
import 'package:wedweel/user/UserHome/VendoritemsUser.dart';
import 'package:wedweel/user/profile/UserProfile.dart';
import 'package:wedweel/user/loginmain.dart/loginpage.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  // List of screens for the bottom navigation bar
  List<Widget> _buildScreens() {
    return [
      Userfirst(check: true,),
      Vendoritemsuser(),
      TodosHome(),
      UserProfile(logout: _handleLogout),
      // Pass logout function
    ];
  }

  // Logout function
  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      await prefs.remove('email');
      await prefs.remove('password');

      // Ensure the widget is still mounted before navigating
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginUserPage()),
        (route) => false, // Clear all previous routes
      );
    } catch (e) {
      print('Error during logout: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to logout. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        backgroundColor: const Color.fromARGB(255, 239, 255, 250),
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: [
          PersistentBottomNavBarItem(
            icon: Icon(Icons.home),
            title: 'Home',
            activeColorPrimary: const Color.fromARGB(255, 4, 148, 114),
            inactiveColorPrimary: Color.fromARGB(255, 21, 101, 93),
          ),
          PersistentBottomNavBarItem(
            icon: Icon(Icons.storefront_outlined),
            title: 'Vendor',
            activeColorPrimary: const Color.fromARGB(255, 4, 148, 114),
            inactiveColorPrimary: Color.fromARGB(255, 21, 101, 93),
          ),
          PersistentBottomNavBarItem(
            icon: Icon(Icons.list_alt_outlined),
            title: 'To-Do',
            activeColorPrimary: const Color.fromARGB(255, 4, 148, 114),
            inactiveColorPrimary: Color.fromARGB(255, 21, 101, 93),
          ),
          PersistentBottomNavBarItem(
              icon: Icon(Icons.person),
              title: 'Profile',
              activeColorPrimary: Color.fromARGB(255, 21, 101, 93),
              inactiveColorPrimary: const Color.fromARGB(255, 4, 148, 114)),
        ],
        navBarStyle: NavBarStyle.style9,
      ),
    );
  }
}
