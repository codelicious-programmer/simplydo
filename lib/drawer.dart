import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:SimplyDo/todohome.dart';

import 'constants.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  static var username = user.email.toString();
  var uid = user.uid.toString();
  static var namefinder = username.indexOf("@");
  static var unamedisp = username.substring(0, namefinder);
  var capname = unamedisp.toUpperCase().toString();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Constants.displabel("Welcome", context),
              Constants.displabel(unamedisp.toString(), context),
            ],
          ),
          toolbarHeight: 150,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          
          children: [
            
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      setState(() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          return const SigninPage();
                        })));
                      });
                    },
                    child: Constants.displabel("""
           Sign in with 
     another account      """, context)),
            ),
            
            Center(
              child: TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    setState(() {
                      Navigator.popUntil(context, (route) => false);
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) {
                        return const SigninPage();
                      })));
                    });
                  },
                  child: Constants.displabel("                Logout               ", context)),
            ),
          ],
        ),
      ),
    );
  }
}
