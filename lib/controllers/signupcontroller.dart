//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobbiteproject/controllers/signincontroller.dart';
import 'package:jobbiteproject/services/firebaseservices.dart';
import 'package:jobbiteproject/services/helper.dart';
import 'package:jobbiteproject/views/signuppage.dart';
import 'package:jobbiteproject/models/user.dart';

class SignUpController {
  void signUpView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpPage(),
      ),
    );
  }

  Future<void> signUp(User user, BuildContext context, String password1) async {
    if (user.email.isEmpty ||
        user.password.isEmpty ||
        user.name.isEmpty ||
        user.surname.isEmpty ||
        user.userType == 0) {
      Helper.showMessage(context, 'Lütfen tüm alanları doldurun.');
      return;
    } else if (password1 != user.password) {
      Helper.showMessage(context, 'Şifreler Eşleşmiyor Lütfen Kontrol Ediniz');
      return;
    }
    FirebaseServices firebaseServices = FirebaseServices();

    String result = await firebaseServices.addUser(user);
    if (result == 'Kullanıcı başarıyla eklendi.') {
      Helper.showMessage(context, result);
      SignInController signInController = SignInController();
      signInController.signInView(context);
    }
    Helper.showMessage(context, result);
  }
}
