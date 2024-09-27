import 'package:flutter/material.dart';
import 'package:jobbiteproject/models/application.dart';
import 'package:jobbiteproject/models/useranduserdetails.dart';
import 'package:jobbiteproject/services/firebaseservices.dart';
import 'package:jobbiteproject/views/businness/studentapplicationdetails.dart';
import 'package:jobbiteproject/views/customappbar.dart';

class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({super.key, required this.jobId});
  final String jobId;

  @override
  State<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        signOutButton: false,
        backButton: true,
      ),
      body: FutureBuilder<List<Application>>(
        future: FirebaseServices().getApplicationsBusiness(widget.jobId),
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
            return RefreshIndicator(
              onRefresh: refresh,
              child: ListView.builder(
                shrinkWrap: true,
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
            );
          }
        },
      ),
    );
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 0));
    setState(() {});
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
    return FutureBuilder<UserAndUserdetails>(
      future: FirebaseServices().getStudent(application.studentid),
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
          final UserAndUserdetails student = snapshotjob.data!;
          return InkWell(
            child: Card(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ClipOval(
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: Image.network(
                              student.profilephotourl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Öğrenci Adı : ',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                student.name,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentApplicationDetails(applicationId: application.id),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: application.status == 0
                                ? Colors.grey
                                : application.status == 1
                                    ? Colors.green
                                    : Colors.red,
                          ),
                          child: const Text('Detay Görüntüle'),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Text(
                      'Başvuru Tarihi : ${application.createdat.day}-${application.createdat.month}-${application.createdat.year}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
