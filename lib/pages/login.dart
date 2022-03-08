// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_final_fields, deprecated_member_use, unnecessary_import, unused_local_variable, avoid_print, unnecessary_new

import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_blog/pages/home.dart';
import 'package:flutter_blog/pages/registration.dart';
import 'package:flutter_blog/widgets/header_widget.dart';
import 'package:flutter_blog/common/theme_helper.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double _headerHeight = 150;
  Key _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String username = "", password = "";

  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: _headerHeight,
            child: HeaderWidget(_headerHeight, true, Icons.login_rounded),
          ),
          SafeArea(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    children: [
                      Text(
                        'Welcome',
                        style: TextStyle(
                            fontSize: 60, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Sign In',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  // onSaved: (val) {
                                  //   username = val!;
                                  // },
                                  controller: _username,
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Username', 'Enter Username'),
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                child: TextFormField(
                                  // onSaved: (val) {
                                  //   password = val!;
                                  // },
                                  controller: _password,
                                  obscureText: true,
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Password', 'Enter Password'),
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                                alignment: Alignment.topRight,
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(
                                    text: 'Forgot your password?',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             ForgotPasswordPage()));
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey),
                                  ),
                                ])),
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                decoration:
                                    ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  onPressed: () {
                                    login(username, password);
                                    setState(() {
                                      isLoading = true;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 10, 40, 10),
                                    child: Text(
                                      "Login".toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(text: "Don't have an account? "),
                                  TextSpan(
                                    text: 'Create',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegistrationPage()));
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).accentColor),
                                  ),
                                ])),
                              )
                            ],
                          ))
                    ],
                  )))
        ]),
      ),
    );
  }

  //API
  login(username, password) async {
    username = _username.text;
    password = _password.text;

    if (username == "" || password == "") {
      Fluttertoast.showToast(
        msg: "Username or password cannot be blank",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Map data = {'username': username, 'password': password};

      //print(data.toString());

      final response = await http.post(
          Uri.parse("http://192.168.1.104/localconnect/signin.php"),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      //If data fetching is successful
      if (response.statusCode == 200) {
        print(response.body);
        final content = jsonDecode(response.body);

        if (!content['error']) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        } else {
          Fluttertoast.showToast(
            msg: "Username or password invalid",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
          );
        }
      }
    }
  }
}
