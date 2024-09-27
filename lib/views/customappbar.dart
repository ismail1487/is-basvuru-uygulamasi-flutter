import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jobbiteproject/views/signinpage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final bool backButton;
  final bool signOutButton;
  final Key? key;
  CustomAppBar({this.backButton = true, this.signOutButton = true, this.key})
      : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Job Bite'),
      backgroundColor: Colors.blue,
      leading: backButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : null,
      actions: [
        signOutButton
            ? IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  _auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                },
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
