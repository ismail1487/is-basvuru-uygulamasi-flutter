import 'package:jobbiteproject/models/useranduserdetails.dart';
import 'package:jobbiteproject/services/firebaseservices.dart';

class BusinnessProfileController {
  Future<UserAndUserdetails> getProfile() async {
    FirebaseServices firebaseServices = FirebaseServices();
    UserAndUserdetails userDetails =
        await firebaseServices.getProfileInformations();
    return userDetails;
  }
}
