import 'package:flutter/material.dart';
import 'package:jobbiteproject/controllers/studentprfilecontroller.dart';
import 'package:jobbiteproject/controllers/studentprofileupdatecontroller.dart';
import 'package:jobbiteproject/models/useranduserdetails.dart';

class StudentProfilePage extends StatelessWidget {
  final String url =
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80';
  final StudentProfileController cont = StudentProfileController();
  Future<UserAndUserdetails> _getUserDetails() async {
    return await cont.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserAndUserdetails>(
      future: _getUserDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final userAndUserdetails = snapshot.data!;
          final StudentProfileUpdateController controller = StudentProfileUpdateController();
          // Burada userAndUserdetails değişkenini kullanabilirsiniz
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  child: Center(
                    child: CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(
                        userAndUserdetails.profilephotourl == '' ? url : userAndUserdetails.profilephotourl,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                          onPressed: () => {controller.businessProfileUpdateView(context)},
                          child: const Icon(Icons.settings)),
                      const SizedBox(
                        height: 5,
                      ),
                      _buildInfoItem('${userAndUserdetails.name}  ${userAndUserdetails.surname}', context),
                      const SizedBox(
                        height: 30,
                      ),
                      _buildInfoItem('E-posta: ${userAndUserdetails.email}', context),
                      const SizedBox(
                        height: 30,
                      ),
                      _buildInfoItem('Telefon: ${userAndUserdetails.name}', context),
                      const SizedBox(
                        height: 30,
                      ),
                      _buildInfoItem('Şehir: ${userAndUserdetails.city}', context),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildInfoItem(String text, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1.0,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text == '' ? '-' : text,
            style: const TextStyle(fontSize: 25),
          ),
        ],
      ),
    );
  }
}
