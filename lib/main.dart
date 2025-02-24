import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedweel/FirstScreen/FirstScreen.dart';
import 'package:wedweel/admin/screen/adminHome.dart';
import 'package:wedweel/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );
  runApp(ScreenUtilInit(
    designSize: Size(384, 805),
    minTextAdapt: true,
    builder: (context, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 237, 250, 244),
          fontFamily: 'Poppins',
        ),
        home: 
          Firstscreen(),
       // AdminHome(),
      ); 
    },
  )); 
}
