//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:jobbiteproject/controllers/businnessmaincontroller.dart';
import 'package:jobbiteproject/controllers/studentmaincontroller.dart';
import 'package:jobbiteproject/services/firebaseservices.dart';
import 'package:jobbiteproject/services/helper.dart';
import 'package:jobbiteproject/views/signinpage.dart';

class SignInController {
  // Diğer işlemler ve metotlar buraya eklenebilir
  Helper helper = Helper();
  void signInView(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInPage(),
      ),
    );
  }

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    FirebaseServices signin = FirebaseServices();
    String result = await signin.signIn(email, password);
    if (result == 'student') {
      StudentMainController studentMainController = StudentMainController();
      studentMainController.studentMainView(context);
    } else if (result == 'businness') {
      BusinnesMainController businnesMainController = BusinnesMainController();
      businnesMainController.businnesMainView(context);
    } else {
      await Helper.showMessage(context, result);
    }
  }
}
