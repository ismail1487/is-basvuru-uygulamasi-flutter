import 'package:flutter/material.dart';
import 'package:jobbiteproject/views/student/studentmainpage.dart';

class StudentMainController {
  void studentMainView(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const StudentMainPage(),
      ),
    );
  }
}
