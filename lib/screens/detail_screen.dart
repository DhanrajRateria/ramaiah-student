import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ramaiah_students/constants.dart';
import 'package:ramaiah_students/screens/text_field.dart';
import 'package:ramaiah_students/screens/welcome_screen.dart';
import 'text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailScreen extends StatefulWidget {
  static const String id = 'detail_screen';
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  String? name;
  String? company;
  String? branch;
  String? usn;
  String? ctc;
  String? position;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Text('Student Placement details'),
        backgroundColor: Color(0xffA83D69),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFieldForm(
                  hintText: "Enter your name",
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextFieldForm(
                  hintText: "Enter your USN",
                  onChanged: (value) {
                    usn = value;
                  },
                ),
                TextFieldForm(
                  hintText: "Enter your branch",
                  onChanged: (value) {
                    branch = value;
                  },
                ),
                TextFieldForm(
                  hintText: "Enter the company placed",
                  onChanged: (value) {
                    company = value;
                  },
                ),
                TextFieldForm(
                  hintText: "Enter your designated position",
                  onChanged: (value) {
                    position = value;
                  },
                ),
                TextFieldForm(
                  hintText: "Enter your CTC",
                  onChanged: (value) {
                    ctc = value;
                  },
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      final details =
                          await _firestore.collection('details').add({
                        'Name': name,
                        'Branch': branch,
                        'USN': usn,
                        'CTC': ctc,
                        'Company': company,
                        'Designated Position': position,
                        'email': loggedInUser.email
                      });
                      if (details != null) {
                        Navigator.pushNamed(context, WelcomeScreen.id);
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text(
                    'Submit',
                    style: kSubmitButtonTextStyle,
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
