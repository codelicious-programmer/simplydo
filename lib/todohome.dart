// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_import

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:SimplyDo/drawer.dart';

import 'constants.dart';

final user = FirebaseAuth.instance.currentUser!;

bool shouldUseFirestoreEmulator = false;

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
      color: Colors.green,
      child: Text(
        details.toString(),
        style: TextStyle(
          fontSize: 15.0,
          color: Colors.white,
        ),
      ),
    );
  };
  runApp(MaterialApp(
    home: ToDoHome(),
  ));
  //runApp(ToDoHome());
}

class ToDoHome extends StatefulWidget {
  const ToDoHome({super.key});

  @override
  State<ToDoHome> createState() => _ToDoHomeState();
}

class _ToDoHomeState extends State<ToDoHome> {
  final controller = TextEditingController();

  static var username = user.email.toString();
  var uid = user.uid.toString();
  static var namefinder = username.indexOf("@");
  static var unamedisp = username.substring(0, namefinder);
  var capname = unamedisp.toUpperCase().toString();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Constants.disptitle("Simply Do", context),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          toolbarHeight: 50,
          elevation: 0.0,
          bottom: TabBar(

              //isScrollable: true,
              //labelColor: Colors.redAccent,
              unselectedLabelColor: Colors.white,
              //indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Constants.accent2),
              tabs: [
                Constants.displabel("New Task", context),
                Constants.displabel("View Tasks", context),
                //Constants.displabel("Urgent Important")
              ]),
        ),
        drawer: MyDrawer(),
        body: TabBarView(children: [
          NewTask(),
          ViewTasks(),
          //UIMatrix(),
        ]),
      ),
    );
  }
}

class NewTask extends StatefulWidget {
  const NewTask({super.key});

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Constants.displabel("Add a task here", context),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: controller,
              autofocus: true,
              cursorHeight: 30,
              autocorrect: true,
              style: TextStyle(
                //color: Colors.pink,
                fontSize: 20,
              ),
              enabled: true,
              decoration: InputDecoration(
                //icon: Icon(Icons.add_task),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    gapPadding: 10.0),
              ),
            ),
          ),
          Container(
            height: 50,
            width: 300,
            child: ElevatedButton(
                onPressed: () {
                  final task = controller.text;

                  createTask(task: task);
                  controller.clear();
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26.0))),
                ),
                child: Constants.displabel("Create Task", context)),
          ),
        ],
      ),
    ));
  }
}

class ViewTasks extends StatefulWidget {
  const ViewTasks({super.key});

  @override
  State<ViewTasks> createState() => _ViewTasksState();
}

class _ViewTasksState extends State<ViewTasks> {
  final CollectionReference _tasks =
      FirebaseFirestore.instance.collection(user.uid.toString());

  List<Color?> tilecolors = [
    Constants.accent2,
    Constants.accent3,
    Constants.accent4,
  ];
  int c = -1;
  gettilecolor() {
    if (c < tilecolors.length - 1) {
      c = c + 1;
    } else {
      c = 0;
    }

    return tilecolors[c];
  }

  Random r = Random();

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Container(
        color: Constants.accent2,
      );
    };
    return Stack(
      children: [
        Scaffold(
          body: Text("Fetching your to do list"),
        ),
        Scaffold(
            body: StreamBuilder(
          stream: _tasks.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              tilecolors.shuffle();
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];

                    return CheckboxListTile(
                      title: Constants.disptodoitem(
                          ("${index + 1}. " + documentSnapshot['task'])),
                      value: false,
                      tileColor: gettilecolor(),
                      onChanged: (bool? value) {
                        FirebaseFirestore.instance
                            .collection(user.uid.toString())
                            .doc(documentSnapshot['id'])
                            .delete();
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  });
            } else {
              return SnackBar(content: Text("No data"));
            }
          },
        )),
      ],
    );
  }
}

final CollectionReference tasklist =
    FirebaseFirestore.instance.collection(user.uid.toString());

Future createTask({required String task}) async {
  final docuser =
      FirebaseFirestore.instance.collection(user.uid.toString()).doc();

  final json = {
    'id': docuser.id,
    'task': task,
  };

  await docuser.set(json);
}

//////////////////////////////////////////////////////////////////////

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  TextEditingController unamecntrl = TextEditingController();
  TextEditingController pwdcntrl = TextEditingController();

  Future signinwithemail() async {
    String errormessage = "";
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: unamecntrl.text.trim(),
        password: pwdcntrl.text.trim(),
      )
          .then((value) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ToDoHome()));
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        errormessage = e.message.toString();
      });

      return SnackBar(content: Text(errormessage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Constants.disptitle("Simply Do", context),
        centerTitle: true,
        backgroundColor: Constants.accent1,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Constants.disptitle("Sign in to Continue", context),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Constants.displabel("       Username", context),
                        TextField(
                          cursorHeight: 30,
                          cursorColor: Constants.accent4,
                          controller: unamecntrl,
                          decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                gapPadding: 10.0),
                          ),
                        ),
                        Constants.displabel("         Password", context),
                        TextField(
                          cursorHeight: 30,
                          cursorColor: Constants.accent4,
                          controller: pwdcntrl,
                          obscureText: true,
                          obscuringCharacter: "*",
                          decoration: InputDecoration(
                            icon: Icon(Icons.key),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                gapPadding: 10.0),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 50,
                              width: 300,
                              child: ElevatedButton(
                                onPressed: signinwithemail,
                                child: Constants.displabel(
                                    'Sign in with email', context),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No account ? ",
                              style:
                                  TextStyle(fontSize: 20, fontFamily: 'Bree'),
                            ),
                            GestureDetector(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Constants.accent1,
                                    fontSize: 20,
                                    fontFamily: 'Bree'),
                              ),
                              onTap: () {
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignupPage()));
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController unamecntrl = TextEditingController();
  TextEditingController pwdcntrl = TextEditingController();

  Future signup() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: unamecntrl.text.trim(),
      password: pwdcntrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Constants.displabel("       Username", context),
              TextField(
                cursorHeight: 30,
                controller: unamecntrl,
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      gapPadding: 10.0),
                ),
              ),
              Constants.displabel("         Password", context),
              TextField(
                cursorHeight: 30,
                controller: pwdcntrl,
                obscureText: true,
                obscuringCharacter: "*",
                decoration: InputDecoration(
                  icon: Icon(Icons.key),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      gapPadding: 10.0),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      height: 50,
                      width: 300,
                      child: ElevatedButton(
                          onPressed: signup, child: Text('Sign Up'))),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already Have an Account ? "),
                  GestureDetector(
                    child: Text("Sign In"),
                    onTap: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SigninPage()));
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
