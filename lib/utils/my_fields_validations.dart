import 'package:flutter/material.dart';

class MyFieldValidations {
  static String? validateEmail(BuildContext context, String? email) {
    if (email!.isEmpty) {
      return "Email can not be empty!";
    }
    var p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    var regExp = RegExp(p);
    if (regExp.hasMatch(email)) {
      return null;
    }
    return "Email not in valid format";
  }

  static String? validatePassword(BuildContext context, String? password) {
    if (password!.isEmpty) {
      return "Password can not be empty!";
    }
    return null;
  }

  static String? validateRequiredField(BuildContext context, String? value) {
    if (value!.isNotEmpty) {
      return null;
    }
    return "Field is required!";
  }

  static String? validateIsNumber(BuildContext context, String? value) {
    if (double.tryParse(value!) != null) {
      return null;
    }
    return "Shpuld be number!";
  }
}
