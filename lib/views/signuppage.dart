import 'package:flutter/material.dart';
import 'package:jobbiteproject/controllers/signupcontroller.dart';
import 'package:jobbiteproject/models/user.dart';
import 'package:jobbiteproject/views/customappbar.dart';

void main() {
  runApp(const MaterialApp(
    home: SignUpPage(),
  ));
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController password1Controller;
  late TextEditingController cityController;
  List<String> userTypes = ['Kullanıcı Tipi Seçiniz', 'Öğrenci', 'İşveren'];
  String selectedUserType = '';
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    surnameController = TextEditingController();
    password1Controller = TextEditingController();
    cityController = TextEditingController();
    selectedUserType = userTypes[0];
  }

  SignUpController signUpController = SignUpController();
  bool sonuc = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: CustomAppBar(backButton: false, signOutButton: false),
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: nameController,
                        obscureText: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          labelText: 'İsim',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: surnameController,
                        obscureText: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          labelText: 'Soyisim',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: emailController,
                        obscureText: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
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
                      child: TextField(
                        controller: password1Controller,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          labelText: 'Şifre Tekrar',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 250,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30.0)),
                      ),
                      child: DropdownButton<String>(
                        value: selectedUserType,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedUserType = newValue!;
                          });
                        },
                        items: userTypes
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        width: 250,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: cityController.text == ''
                              ? ''
                              : cityController.text,
                          onChanged: (value) {
                            cityController.text = value!;
                          },
                          items: const [
                            DropdownMenuItem(
                              value: '',
                              child: Text(''),
                            ),
                            DropdownMenuItem(
                              value: 'Kastamonu',
                              child: Text('Kastamonu'),
                            ),
                            // Diğer şehirler buraya eklenebilir
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Şehir',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ), /* DropdownButtonFormField<String>(
                        value: cityController.text == ''
                            ? ''
                            : cityController.text,
                        onChanged: (value) {
                          cityController.text = value!;
                        },
                        items: const [
                          DropdownMenuItem(
                            value: '',
                            child: Text(''),
                          ),
                          DropdownMenuItem(
                            value: 'Kastamonu',
                            child: Text('Kastamonu'),
                          ),
                          // Diğer şehirler buraya eklenebilir
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Şehir',
                          border: OutlineInputBorder(),
                        ),
                      ),*/
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 180,
                      child: ElevatedButton(
                          onPressed: () async {
                            User user = getUserFromFields();
                            signUpController.signUp(
                                user, context, password1Controller.text);
                          },
                          child: const Text('Kayıt Ol')),
                    )
                  ],
                )),
              ),
            )));
  }

  User getUserFromFields() {
    String name = nameController.text;
    String surname = surnameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    int userType = userTypes.indexOf(
        selectedUserType); // User tipini seçilen tipin indeksi olarak al
    String city = cityController.text;
    return User(
      name: name,
      surname: surname,
      email: email,
      password: password,
      city: city,
      userType: userType,
    );
  }
}
