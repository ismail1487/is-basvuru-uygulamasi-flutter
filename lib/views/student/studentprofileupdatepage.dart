import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobbiteproject/controllers/studentprfilecontroller.dart';
import 'package:jobbiteproject/controllers/studentprofileupdatecontroller.dart';
import 'package:jobbiteproject/models/useranduserdetails.dart';
import 'package:jobbiteproject/services/firebaseservices.dart';
import 'package:jobbiteproject/services/getimageservice.dart';
import 'package:jobbiteproject/views/customappbar.dart';

import 'dart:io';

import 'package:jobbiteproject/views/student/studentmainpage.dart';

class StudentProfileUpdatePage extends StatefulWidget {
  const StudentProfileUpdatePage({super.key});

  @override
  State<StudentProfileUpdatePage> createState() => _StudentProfileUpdatePageState();
}

class _StudentProfileUpdatePageState extends State<StudentProfileUpdatePage> {
  FirebaseServices firebaseServices = FirebaseServices();
  final StudentProfileUpdateController cont = StudentProfileUpdateController();
  final StudentProfileController cont1 = StudentProfileController();
  final GetImageService getImageService = GetImageService();
  File? _imageFile;
  bool change = false;

  @override
  void initState() {
    super.initState();
    _imageFile = null;
    change = false;
  }

  Future<UserAndUserdetails> _getUserDetails() async {
    return await cont1.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserAndUserdetails>(
        future: _getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final userAndUserdetails = snapshot.data!;
            TextEditingController nameController = TextEditingController();
            TextEditingController surnameController = TextEditingController();
            TextEditingController emailController = TextEditingController();
            TextEditingController cityController = TextEditingController();
            TextEditingController departmentController = TextEditingController();
            TextEditingController ibanController = TextEditingController();
            TextEditingController profilephotourlController = TextEditingController();
            TextEditingController univercityController = TextEditingController();

            nameController.text = userAndUserdetails.name;
            surnameController.text = userAndUserdetails.surname;
            cityController.text = userAndUserdetails.city;
            emailController.text = userAndUserdetails.email;
            departmentController.text = userAndUserdetails.department;
            ibanController.text = userAndUserdetails.iban;
            profilephotourlController.text = userAndUserdetails.profilephotourl;
            univercityController.text = userAndUserdetails.univercity;

            return Scaffold(
              appBar: CustomAppBar(backButton: true, signOutButton: false),
              body: Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          XFile? pickedImage = await getImageService.checkPermissionAndOpenGallery();
                          if (pickedImage != null) {
                            setState(() {
                              _imageFile = File(pickedImage.path);
                              change = true;
                            });
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: _imageFile != null
                              ? Image.file(_imageFile!, fit: BoxFit.cover)
                              : profilephotourlController.text != ''
                                  ? Image.network(profilephotourlController.text)
                                  : Image.network(
                                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'İsim',
                            hintText: 'Adınızı girin',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: surnameController,
                          decoration: const InputDecoration(
                            labelText: 'Soyisim',
                            hintText: 'Soyadınızı girin',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'E-posta',
                            hintText: 'E-posta adresinizi girin',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButtonFormField<String>(
                          value: cityController.text == '' ? '' : cityController.text,
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
                            DropdownMenuItem(
                              value: 'Ankara',
                              child: Text('Ankara'),
                            ),
                            // Diğer şehirler buraya eklenebilir
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Şehir',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          child: const Text('KAYDET'),
                          onPressed: () async {
                            if (change) {
                              String uri = '';
                              uri = await cont.addProfilePhoto(_imageFile!);
                              profilephotourlController.text = uri;
                            }
                            UserAndUserdetails userdetails = UserAndUserdetails(
                                name: nameController.text,
                                surname: surnameController.text,
                                email: emailController.text,
                                city: cityController.text,
                                univercity: univercityController.text,
                                department: departmentController.text,
                                iban: ibanController.text,
                                profilephotourl: profilephotourlController.text);
                            await cont.uploadProfile(userdetails);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StudentMainPage(pagenumber: 1),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
