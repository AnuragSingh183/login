import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  String email = "";
  String pwd = "";
  String username = "";
  void signIn(String emailTxt, String pwdTxt, String username) {
    email = emailTxt;
    pwd = pwdTxt;
    username = username;
    notifyListeners();
  }
}
