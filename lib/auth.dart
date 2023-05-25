// ignore_for_file: constant_identifier_names

import 'package:assignment/dashboard.dart';
import 'package:assignment/user.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:get/get.dart';

import 'helpers/httpexception.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey();

  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {"email": "", "password": ""};

  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();

  var _isLoading = false;

  void _showDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text("An Error Occured!"),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Okay"))
              ],
            ));
  }

  void _switchAuthMode() async {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }
    _formkey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      Provider.of<User>(context, listen: false).signIn(emailController.text,
          passwordController.text, usernameController.text);

      Get.to(() => const dashboard());
    } on httpException catch (error) {
      var errorMessage = "Authentication Failed"; //default message

      if (error.toString().contains("EMAIL_EXISTS")) {
        errorMessage = "This Email is already in use";
      }
      if (error.toString().contains("INVALID_EMAIL")) {
        errorMessage = "This Email is invalid";
      }
      if (error.toString().contains("WEAK_PASSWORD")) {
        errorMessage = "Try a Stronger Password";
      }
      if (error.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = "Can't find a user with this email";
      }
      if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "This password is not valid";
      }
      _showDialog(errorMessage);
    } catch (error) {
      var errorMessage = "Could Not Authenticate.Please Try Again Later";
      _showDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  bool _showpassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SizedBox(
                  width: 500,
                  height: 500,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              const Text(
                                "Welcome",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 25),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                "Login to continue",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Form(
                                key: _formkey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        controller: usernameController,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            labelText: 'UserName'),
                                        textInputAction: TextInputAction.next,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Invalid UserName!';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _authData['email'] = value!;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        controller: emailController,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            labelText: 'Email'),
                                        textInputAction: TextInputAction.next,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              !value.contains('@')) {
                                            return 'Invalid email!';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _authData['email'] = value!;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        // obscuringCharacter: _showpassword.toString(),
                                        style: const TextStyle(
                                            color: Colors.black),
                                        decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _showpassword =
                                                        !_showpassword;
                                                  });
                                                },
                                                icon: Icon(_showpassword
                                                    ? Icons.visibility
                                                    : Icons.visibility_off)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                    color: Colors.black)),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: const BorderSide(
                                                    color: Colors.black)),
                                            labelText: 'Password'),
                                        obscureText: _showpassword,
                                        controller: passwordController,
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              value.length < 5) {
                                            return 'Password is too short!';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _authData['password'] = value!;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (_authMode == AuthMode.Signup)
                                        // SizedBox(
                                        // height: 15,
                                        //),

                                        TextFormField(
                                          style: const TextStyle(
                                              color: Colors.black),
                                          enabled: _authMode == AuthMode.Signup,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color: Colors.black)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color: Colors.black)),
                                              labelText: 'Confirm Password'),
                                          obscureText: true,
                                          validator: _authMode ==
                                                  AuthMode.Signup
                                              ? (value) {
                                                  if (value !=
                                                      passwordController.text) {
                                                    return 'Passwords do not match!';
                                                  }
                                                }
                                              : null,
                                        ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      if (_isLoading)
                                        const CircularProgressIndicator()
                                      else
                                        ElevatedButton(
                                          onPressed: _submit,
                                          child: Text(
                                              _authMode == AuthMode.Login
                                                  ? 'LOGIN'
                                                  : 'SIGN UP'),
                                        ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextButton(
                                        onPressed: _switchAuthMode,
                                        child: Text(
                                            '${_authMode == AuthMode.Login ? 'New User ? Signup' : 'Already a User ? Login'} '),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
