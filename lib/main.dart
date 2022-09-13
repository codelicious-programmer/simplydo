// ignore_for_file: prefer_const_declarations, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:SimplyDo/todohome.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'constants.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      const MaterialApp(debugShowCheckedModeBanner: false, home: MySplash()));
}

class MySplash extends StatefulWidget {
  const MySplash({super.key});

  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset(
        "assets/Simply_Do.png",
        
      ),
      logoWidth: 150,
      title: Constants.splashscreentext("Simply Do"),
      backgroundColor: Constants.accent4,
      showLoader: false,
      loadingText: Text("By Kimberly Moniz",
       style: TextStyle(
           fontFamily: 'Pacifico',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      navigator: MyApp(),
      durationInSeconds: 5,
    );
  }
}

class MyApp extends StatelessWidget {
  static final String title = "Simply Do";
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            iconColor: Constants.accent4,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Constants.accent4),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Constants.accent4),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Constants.accent1),
                borderRadius: BorderRadius.circular(10.0),
                gapPadding: 10.0),
          ),
          scaffoldBackgroundColor: Constants.accent2,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26.0))),
              backgroundColor: MaterialStateProperty.all(Constants.accent1),
              foregroundColor: MaterialStateProperty.all(Constants.accent4),
            ),
          ),
          appBarTheme: AppBarTheme(backgroundColor: Constants.accent1),
          textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 30, fontFamily: 'Arima', color: Constants.accent4),
            labelMedium: TextStyle(
                fontSize: 25, fontFamily: 'Arima', color: Constants.accent4),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Constants.accent1)
            
            
            ),
            
            ),
        ),
        home: Scaffold(
          body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ToDoHome();
                } else {
                  return SigninPage();
                }
              }),
        ));
  }
}
