import 'package:flutter/material.dart';
import 'package:jobbiteproject/controllers/signincontroller.dart';
import 'package:jobbiteproject/controllers/signupcontroller.dart';
import 'package:jobbiteproject/views/customappbar.dart';

void main() {
  runApp(const MaterialApp(
    home: SignInPage(),
  ));
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  SignUpController signUpController = SignUpController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(backButton: false, signOutButton: false),
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: emailController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      labelText: 'E-Mail',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      labelText: 'Şifre',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 250,
                  child: Container(
                    child: Column(
                      //row olarak değişecek unutma
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () async {
                              // Giriş yap butonuna tıklandığında yapılacak işlemler
                              SignInController signInController = SignInController();
                              signInController.signIn(emailController.text, passwordController.text, context);
                            },
                            child: const Text('Giriş Yap'),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () async {
                              // Giriş yap butonuna tıklandığında yapılacak işlemler
                              SignInController signInController = SignInController();
                              signInController.signIn('ogrenci@abc.com', '123456', context);
                            },
                            child: const Text('Ogrenci Olarak Giriş Yap'),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () async {
                              // Giriş yap butonuna tıklandığında yapılacak işlemler
                              SignInController signInController = SignInController();
                              signInController.signIn('ismail@avcu.com', '123456', context);
                            },
                            child: const Text('İşveren Olarak Giriş Yap'),
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              // Kayıt Ol butonuna tıklandığında yapılacak işlemler
                              signUpController.signUpView(context);
                            },
                            child: const Text('Kayıt Ol'),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
