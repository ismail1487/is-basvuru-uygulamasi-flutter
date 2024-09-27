import 'dart:io';

import 'package:jobbiteproject/models/workplace.dart';
import 'package:jobbiteproject/services/firebaseservices.dart';

class AddWorkplaceController {
  Future<String> addWorkplacePhoto(File file) async {
    String photouri = await FirebaseServices().addWorkPlacePhoto(file);
    return photouri;
  }

  Future<void> addWorkPlace(WorkPlace workPlace) async {
    await FirebaseServices().addWorkPlace(workPlace);
  }

  Future<void> uploadWorkPlace(WorkPlace workPlace) async {
    await FirebaseServices().uploadWorkPlace(workPlace);
  }
}
