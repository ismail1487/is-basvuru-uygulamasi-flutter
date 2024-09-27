import 'package:flutter/material.dart';
import 'package:jobbiteproject/views/businness/businnessmainpage.dart';

class BusinnesMainController {
  void businnesMainView(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const BusinnessMainPage(),
      ),
    );
  }
}
