import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jobbiteproject/models/useranduserdetails.dart';
import 'package:jobbiteproject/services/firebaseservices.dart';
import 'package:jobbiteproject/views/businness/businessprofileupdatepage.dart';

class BusinessProfileUpdateController {
  void businessProfileUpdateView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BusinessProfileUpdatePage(),
      ),
    );
  }

  Future<String> addProfilePhoto(File file) async {
    String photouri = await FirebaseServices().addProfilePhoto(file);
    return photouri;
  }

  Future<void> uploadProfile(UserAndUserdetails userAndUserdetails) async {
    await FirebaseServices().uploadUser(userAndUserdetails);
  }
}
