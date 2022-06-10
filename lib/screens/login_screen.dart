// todo: delete old db , convert password to caps ,

import 'dart:convert';

import 'package:demo_app/screens/homepage.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceScreen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Usuario",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isNotEmpty && value.length >= 2) {
                          return null;
                        } else if (value.length < 3 && value.isNotEmpty) {
                          return "Username is too short";
                        } else {
                          return "Please enter a username";
                        }
                      },
                      controller: usernameController,
                      autofocus: false,
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        contentPadding: const EdgeInsets.all(15.0),
                        suffixIcon: IconButton(
                            onPressed: () {
                              usernameController.clear();
                            },
                            icon: const Icon(Icons.clear)),
                        suffixIconColor: Colors.black87,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            width: 0.05,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Contrasena",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a password ";
                        } else if (value.length < 3 && value.isNotEmpty) {
                          return "Password is too short";
                        } else {
                          return null;
                        }
                      },
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      controller: passwordController,
                      // obscureText: true,
                      autofocus: false,
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        contentPadding: const EdgeInsets.all(15.0),
                        suffixIconColor: Colors.black87,
                        suffixIcon: IconButton(
                            onPressed: () {
                              passwordController.clear();
                            },
                            icon: const Icon(Icons.clear)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            width: 0.05,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                      onChanged: (value) => setState(() {}),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                child: const Text(
                  "Accesar",
                ),
                onPressed: () {
                  final form = _formkey.currentState;
                  if (form!.validate()) {
                    setState(() {
                      form.save();
                    });
                    loginUserRequest(
                        usernameController.text, passwordController.text);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  final String loginUrl =
      '''http://79.143.190.196:8080/jLeoniPedim/servletExtraeInfoPEdimento?xAccion=listadoAccesoSistema''';

  void loginUserRequest(String username, String password) async {
    var makeLoginRequest =
        Uri.parse(loginUrl); //"xUser=$username&xPass=$password");
    var loginRequestResult = await http.get(makeLoginRequest);
    final loginRequestJson = jsonDecode(loginRequestResult.body);
    validateUser(username, password, loginRequestJson);
  }

  // catch exceptions here
  void validateUser(String username, String password, json) {
    print(json);
    for (var users in json) {
      if (users?.containsKey("xUser") ?? false) {
        print(users!["xUser"]);
        if (users!["xUser"] == username) {
          print("user exists");
          if (users!["xPass"] == password) {
            print("password is coreect");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else {
            print("wrong password");
          }
        } else {
          print("username doesnt exist");
        }
      } else {
        print("xUser not in list");
      }
    }
  }
}
