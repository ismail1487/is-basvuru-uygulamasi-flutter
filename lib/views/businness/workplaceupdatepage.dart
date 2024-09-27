import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobbiteproject/controllers/addworkplacecontroller.dart';
import 'package:jobbiteproject/models/workplace.dart';
import 'package:jobbiteproject/services/firebaseservices.dart';
import 'package:jobbiteproject/services/getimageservice.dart';
import 'package:jobbiteproject/views/customappbar.dart';
import 'package:jobbiteproject/views/mappage.dart';

class WorkPlaceUpdatePage extends StatefulWidget {
  const WorkPlaceUpdatePage({super.key, required this.workPlaceId});
  final String workPlaceId;
  @override
  State<WorkPlaceUpdatePage> createState() => _WorkPlaceUpdatePageState(workPlaceId: workPlaceId);
}

class _WorkPlaceUpdatePageState extends State<WorkPlaceUpdatePage> {
  String workPlaceId;
  _WorkPlaceUpdatePageState({required this.workPlaceId});

  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController adresessController = TextEditingController();
  TextEditingController photoController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController ownerController = TextEditingController();

  double newlatitude = 0;
  double newlongitude = 0;

  File? _imageFile;
  bool change = false;

  @override
  void initState() {
    super.initState();
    _imageFile = null;
    change = false;
    _loadWorkplaceData();
  }

  void _loadWorkplaceData() async {
    final workPlace = await FirebaseServices().getWorkPlace(workPlaceId);
    setState(() {
      nameController.text = workPlace.name;
      typeController.text = workPlace.workplaceType;
      adresessController.text = workPlace.adresses;
      photoController.text = workPlace.workPlacePhoto;
      idController.text = workPlace.id;
      ownerController.text = workPlace.owner;
      newlatitude = workPlace.latidude;
      newlongitude = workPlace.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(backButton: true, signOutButton: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                XFile? pickedImage = await GetImageService().checkPermissionAndOpenGallery();
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
                    : photoController.text != ''
                        ? Image.network(photoController.text)
                        : Image.network(
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'İşyeri Adı',
                  hintText: 'İşyeri İsmi Giriniz',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: adresessController,
                decoration: const InputDecoration(
                  labelText: 'Adres',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonFormField<String>(
                value: typeController.text == '' ? '' : typeController.text,
                onChanged: (value) {
                  typeController.text = value!;
                },
                items: const [
                  DropdownMenuItem(
                    value: '',
                    child: Text(''),
                  ),
                  DropdownMenuItem(
                    value: 'Kafe',
                    child: Text('Kafe'),
                  ),
                  DropdownMenuItem(
                    value: 'Restorant',
                    child: Text('Restorant'),
                  ),
                ],
                decoration: const InputDecoration(
                  labelText: 'İşyeri Tipi',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                  onPressed: () async {
                    final selectedLocation = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapPage.withLocation(
                          latitude: newlatitude,
                          longitude: newlongitude,
                          purposeofarrival: 'update',
                        ),
                      ),
                    );
                    if (selectedLocation != null && selectedLocation is Map<String, dynamic>) {
                      setState(() {
                        //locationchange = true;
                        adresessController.text = selectedLocation['address'];
                        newlatitude = selectedLocation['latitude'];
                        newlongitude = selectedLocation['longitude'];
                      });
                    }
                  },
                  child: const Text('Konum Değiştir')),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                  onPressed: () async {
                    String photoUrl = '';
                    if (change) {
                      photoUrl = await AddWorkplaceController().addWorkplacePhoto(_imageFile!);
                    } else {
                      photoUrl = photoController.text;
                    }

                    WorkPlace sendWorkplace = WorkPlace(
                      name: nameController.text,
                      workPlacePhoto: photoUrl,
                      latidude: newlatitude,
                      longitude: newlongitude,
                      adresses: adresessController.text,
                      workplaceType: typeController.text,
                      id: idController.text,
                      owner: ownerController.text,
                    );
                    AddWorkplaceController().uploadWorkPlace(sendWorkplace);

                    Navigator.pop(context, sendWorkplace);
                  },
                  child: const Text('Kaydet')),
            )
          ],
        ),
      ),
    );
    /*return Scaffold(
      appBar: CustomAppBar(backButton: true, signOutButton: false),
      body: Center(
        child: Container(
          child: Column(children: [
            GestureDetector(
              onTap: () async {
                XFile? pickedImage = await GetImageService().checkPermissionAndOpenGallery();
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
                    : photoController.text != ''
                        ? Image.network(photoController.text)
                        : Image.network(
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'İşyeri Adı',
                  hintText: 'İşyeri İsmi Giriniz',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: adresessController,
                decoration: const InputDecoration(
                  labelText: 'Adres',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonFormField<String>(
                value: typeController.text == '' ? '' : typeController.text,
                onChanged: (value) {
                  typeController.text = value!;
                },
                items: const [
                  DropdownMenuItem(
                    value: '',
                    child: Text(''),
                  ),
                  DropdownMenuItem(
                    value: 'Kafe',
                    child: Text('Kafe'),
                  ),
                  DropdownMenuItem(
                    value: 'Restorant',
                    child: Text('Restorant'),
                  ),
                  // Diğer şehirler buraya eklenebilir
                ],
                decoration: const InputDecoration(
                  labelText: 'İşyeri Tipi',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                  onPressed: () async {
                    final selectedLocation = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapPage.withLocation(
                                latitude: workPlace.latidude,
                                longitude: workPlace.longitude,
                              )),
                    );

                    if (selectedLocation != null && selectedLocation is Map<String, dynamic>) {
                      setState(() {
                        print(selectedLocation['address']);
                        adresessController.text = selectedLocation['address'];
                        latitude = selectedLocation['latitude'];
                        longitude = selectedLocation['longitude'];
                        print(latitude);
                        print(longitude);
                      });
                    }
                  },
                  child: Text('Konum Değiştir')),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                  onPressed: () async {
                    String photoUrl = '';
                    if (change) {
                      photoUrl = await AddWorkplaceController().addWorkplacePhoto(_imageFile!);
                    } else
                      photoUrl = photoController.text;
                    WorkPlace sendWorkplace = getWorkplaceFromFields(photoUrl);
                    AddWorkplaceController().uploadWorkPlace(sendWorkplace);

                    Navigator.pop(context, sendWorkplace);
                  },
                  child: Text('Kaydet')),
            )
          ]),
        ),
      ),
    );*/
  }

  /*WorkPlace getWorkplaceFromFields(String photoUrl) {
    return WorkPlace(
      name: nameController.text,
      workPlacePhoto: photoUrl,
      latidude: latitude,
      longitude: longitude,
      adresses: adresessController.text,
      workplaceType: typeController.text,
      id: idController.text,
      owner: ownerController.text,
    );
  }*/
}
