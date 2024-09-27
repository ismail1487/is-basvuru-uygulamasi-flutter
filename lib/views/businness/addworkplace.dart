import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobbiteproject/controllers/addworkplacecontroller.dart';
import 'package:jobbiteproject/models/workplace.dart';
import 'package:jobbiteproject/services/getimageservice.dart';
import 'package:jobbiteproject/views/businness/businnessmainpage.dart';
import 'package:jobbiteproject/views/customappbar.dart';
//import 'package:jobbiteproject/views/gecici.dart';
import 'package:jobbiteproject/views/mappage.dart';

class AddWorkplace extends StatefulWidget {
  const AddWorkplace({super.key});

  @override
  State<AddWorkplace> createState() => _AddWorkplaceState();
}

class _AddWorkplaceState extends State<AddWorkplace> {
  GetImageService getImageService = GetImageService();
  File? _imageFile;
  bool isFirstButtonVisible = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController workplaceTypeController = TextEditingController();
  double latitude = 0;
  double longitude = 0;
  @override
  void initState() {
    super.initState();
    _imageFile = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          backButton: true,
          signOutButton: false,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: GestureDetector(
                    onTap: () async {
                      XFile? pickedImage = await getImageService.checkPermissionAndOpenGallery();
                      if (pickedImage != null) {
                        setState(() {
                          _imageFile = File(pickedImage.path);
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
                          : Image.network(
                              'https://cdn-icons-png.flaticon.com/512/4211/4211763.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'İşyeri İsmi',
                      hintText: 'İşyeri İsmi Girin',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: DropdownButtonFormField<String>(
                    value: '',
                    onChanged: (value) {
                      workplaceTypeController.text = value!;
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
                      labelText: 'İş Yerş Tşpi',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      if (isFirstButtonVisible)
                        ElevatedButton(
                          child: const Text('KONUM AYARLAMA'),
                          onPressed: () async {
                            final selectedLocation = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MapPage()),
                            );

                            if (selectedLocation != null && selectedLocation is Map<String, dynamic>) {
                              setState(() {
                                adressController.text = selectedLocation['address'];
                                latitude = selectedLocation['latitude'];
                                longitude = selectedLocation['longitude'];
                                isFirstButtonVisible = false;
                              });
                            }
                          },
                        ),
                    ],
                  ),
                ),
                if (!isFirstButtonVisible)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: TextField(
                      controller: adressController,
                      decoration: const InputDecoration(
                        labelText: 'Adres',
                        hintText: 'İşyeri İsmi Girin',
                      ),
                      enabled: false,
                    ),
                  ),
                if (!isFirstButtonVisible)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: ElevatedButton(
                      child: const Text('KAYDET'),
                      onPressed: () async {
                        String photoUrl = '';
                        photoUrl = await AddWorkplaceController().addWorkplacePhoto(_imageFile!);
                        WorkPlace workPlace = getWorkplaceFromFields(photoUrl);
                        AddWorkplaceController().addWorkPlace(workPlace);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BusinnessMainPage(pagenumber: 0),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ));
  }

  WorkPlace getWorkplaceFromFields(String photoUrl) {
    return WorkPlace(
      name: nameController.text,
      workPlacePhoto: photoUrl,
      latidude: latitude,
      longitude: longitude,
      adresses: adressController.text,
      workplaceType: workplaceTypeController.text,
    );
  }
}
