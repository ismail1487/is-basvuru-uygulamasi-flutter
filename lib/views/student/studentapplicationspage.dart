import 'package:flutter/material.dart';
import 'package:jobbiteproject/models/application.dart';
import 'package:jobbiteproject/models/job.dart';
import 'package:jobbiteproject/models/workplace.dart';
import 'package:jobbiteproject/services/firebaseservices.dart';

class StudentApplicationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Application>>(
            future: FirebaseServices().getApplicationsStudent(),
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
                final List<Application> applications = snapshot.data!;
                return SingleChildScrollView(
                  child: Column(children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: applications.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                          child: ItemWidget(
                            application: applications[index],
                            context: context,
                          ),
                        );
                      },
                    ),
                  ]),
                );
              }
            }));
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    Key? key,
    required this.application,
    required this.context,
  }) : super(key: key);

  final Application application;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Job>(
        future: FirebaseServices().getJob(application.jobid),
        builder: (context, snapshotjob) {
          if (snapshotjob.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshotjob.hasError) {
            return Center(
              child: Text('Error: ${snapshotjob.error}'),
            );
          } else {
            final Job job = snapshotjob.data!;
            return FutureBuilder<WorkPlace>(
                future: FirebaseServices().getWorkPlace(job.workPlaceId),
                builder: (context, snapshotworkplace) {
                  if (snapshotworkplace.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshotworkplace.hasError) {
                    return Center(
                      child: Text('Error: ${snapshotworkplace.error}'),
                    );
                  } else {
                    final WorkPlace workPlace = snapshotworkplace.data!;
                    return InkWell(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipOval(
                                child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Image.network(
                                    workPlace.workPlacePhoto,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                  child: Column(
                                children: [
                                  const Text(
                                    'İşyeri Adı : ',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    workPlace.name,
                                    style: const TextStyle(fontSize: 18),
                                  )
                                ],
                              ) /*Text(
                  'İşyeri Adı :' + job.workPlaceName,
                  style: const TextStyle(fontSize: 18),
                ),*/
                                  ),
                              const SizedBox(width: 16),
                              /*Expanded(
                              child: Column(
                            children: [
                              const Text(
                                'Saatlik Ücret : ',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                job.fee.toString() + ' ₺',
                                style: const TextStyle(fontSize: 18),
                              )
                            ],
                          )),*/
                              StateWidget(state: application.status)
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                });
          }
        });
  }
}

class StateWidget extends StatelessWidget {
  final int state;
  StateWidget({
    required this.state,
  });
  @override
  Widget build(BuildContext context) {
    if (state == 0) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          border: Border.all(
            color: const Color.fromARGB(255, 0, 0, 0),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: const Text(
          'Beklemede',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (state == 1) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.green[200],
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: const Text(
          'Onaylandı',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 186, 7, 7),
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: const Text(
          'Reddedildi',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }
}
