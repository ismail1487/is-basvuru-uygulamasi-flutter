import 'package:flutter/material.dart';
import 'package:jobbiteproject/controllers/workplaceupdatecontroller.dart';
import 'package:jobbiteproject/models/workplace.dart';
import 'package:jobbiteproject/services/firebaseservices.dart';
import 'package:jobbiteproject/services/helper.dart';
import 'package:jobbiteproject/views/businness/businnessmainpage.dart';
import 'package:jobbiteproject/views/customappbar.dart';
import 'package:jobbiteproject/views/mappage.dart';

class WorkPlaceDetailsPage extends StatefulWidget {
  const WorkPlaceDetailsPage({super.key, required this.workPlaceId});
  final String workPlaceId;

  @override
  State<WorkPlaceDetailsPage> createState() => _WorkPlaceDetailsPageState(workPlaceId: workPlaceId);
}

class _WorkPlaceDetailsPageState extends State<WorkPlaceDetailsPage> {
  final String workPlaceId;
  _WorkPlaceDetailsPageState({required this.workPlaceId});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backButton: true,
        signOutButton: false,
      ),
      body: FutureBuilder<WorkPlace>(
        future: FirebaseServices().getWorkPlace(workPlaceId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final WorkPlace workPlace = snapshot.data!;

            TextEditingController nameController = TextEditingController();
            TextEditingController typeController = TextEditingController();
            TextEditingController adresessController = TextEditingController();
            TextEditingController photoController = TextEditingController();

            nameController.text = workPlace.name;
            typeController.text = workPlace.workplaceType;
            adresessController.text = workPlace.adresses;
            photoController.text = workPlace.workPlacePhoto;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    child: Center(
                      child: CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                          photoController.text,
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
                            onPressed: () async {
                              await WorkPlaceUpdateController().WorkPlaceUpdatePageView(context, workPlace.id);
                              setState(() {});
                            },
                            child: const Icon(Icons.settings)),
                        const SizedBox(
                          height: 5,
                        ),
                        _buildInfoItem('İşyeri İsmi : ${nameController.text}', context),
                        const SizedBox(
                          height: 30,
                        ),
                        _buildInfoItem('Adres: ${adresessController.text}', context),
                        const SizedBox(
                          height: 30,
                        ),
                        _buildInfoItem('Tür: ${typeController.text}', context),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: SizedBox(),
                            ),
                            ElevatedButton(
                                onPressed: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MapPage.withLocation(
                                            latitude: workPlace.latidude,
                                            longitude: workPlace.longitude,
                                            purposeofarrival: 'look',
                                          ),
                                        ),
                                      )
                                    },
                                child: const Text('Konumuna Bak')),
                            const Expanded(
                              child: SizedBox(),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await FirebaseServices().deleteWorkPlace(workPlace.id).then((value) {
                                  if (value) {
                                    Helper.showMessage(context, 'Kayıt Silme İşlemi Başarılı');
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const BusinnessMainPage(pagenumber: 0),
                                      ),
                                    );
                                  }
                                });
                              },
                              child: const Text('İşyeri Kaydını Sil'),
                            ),
                            const Expanded(
                              child: SizedBox(),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
    /*return Scaffold(
        appBar: CustomAppBar(
          backButton: true,
          signOutButton: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                child: Center(
                  child: CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(
                      photoController.text,
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
                        onPressed: () async {
                          WorkPlace w = await WorkPlaceUpdateController()
                              .WorkPlaceUpdatePageView(context, workPlace);
                          setState(() {
                            nameController.text = w.name;
                            typeController.text = w.workplaceType;
                            adresessController.text = w.adresses;
                            photoController.text = w.workPlacePhoto;
                          });
                        },
                        child: const Icon(Icons.settings)),
                    const SizedBox(
                      height: 5,
                    ),
                    _buildInfoItem(
                        'İşyeri İsmi : ${nameController.text}', context),
                    const SizedBox(
                      height: 30,
                    ),
                    _buildInfoItem(
                        'Adres: ${adresessController.text}', context),
                    const SizedBox(
                      height: 30,
                    ),
                    _buildInfoItem('Tür: ${typeController.text}', context),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MapPage.withLocation(
                                          latitude: workPlace.latidude,
                                          longitude: workPlace.longitude,
                                        )),
                              )
                            },
                        child: const Text('Konumuna Bak')),
                  ],
                ),
              ),
            ],
          ),
        ));*/
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
