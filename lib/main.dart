import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jobbiteproject/firebase_options.dart';
import 'package:jobbiteproject/services/firebaseservices.dart';
import 'package:jobbiteproject/views/businness/businnessmainpage.dart';
import 'package:jobbiteproject/views/signinpage.dart';
import 'package:jobbiteproject/views/student/studentmainpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase Authentication'ı kullanarak aktif kullanıcıyı kontrol edin
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  String userType = '';
  if (user != null) {
    FirebaseServices firebaseServices = FirebaseServices();
    String? email = user.email;
    if (email != null) {
      userType = await firebaseServices.getUserType(email);
    }
  }
  // Eğer aktif bir kullanıcı varsa, ana sayfaya yönlendirin; yoksa giriş sayfasını açın
  runApp(MaterialApp(
    home: user == null
        ? SignInPage()
        : userType == 'student'
            ? StudentMainPage()
            : BusinnessMainPage(), // 'HomePage' yerine kendi anasayfa widget'ınızı kullanın
  ));
}
