import 'package:flutter/material.dart';
import 'package:jobbiteproject/models/jobandworkplace.dart';
import 'package:jobbiteproject/models/workplace.dart';
import 'package:jobbiteproject/services/firebaseservices.dart';
import 'package:jobbiteproject/services/helper.dart';
import 'package:jobbiteproject/views/businness/addjobpage.dart';
import 'package:jobbiteproject/views/businness/jobdetailspage.dart';

class JobsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<JobAndWorkPlace>>(
          future: FirebaseServices().getJobs(),
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
              final List<JobAndWorkPlace> jobs = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                          child: ItemWidget(
                            job: jobs[index],
                            context: context,
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        onPressed: () async {
                          List<WorkPlace> workplaces = await FirebaseServices().getWorkPlaces();
                          if (workplaces.isEmpty) {
                            Helper.showMessage(context, 'İş Yeri Eklemesi Yapınız');
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddJobPage(),
                              ),
                            );
                          }
                        },
                        child: const Text('İş İlanı Ekle'),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
    /*return Scaffold(1
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddJobPage(),
                    ),
                  );
                },
                child: const Text('İş İlanı Ekle'),
              ),
            ),
          ],
        ),
      ),
    );*/
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    Key? key,
    required this.job,
    required this.context,
  }) : super(key: key);

  final JobAndWorkPlace job;
  final BuildContext context;

  void _handleTap() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobDetailsPage(jobId: job.jobId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _handleTap();
      },
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
                        job.workPlacePhoto,
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
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        job.workPlaceName,
                        style: const TextStyle(fontSize: 18),
                      )
                    ],
                  ) /*Text(
                  'İşyeri Adı :' + job.workPlaceName,
                  style: const TextStyle(fontSize: 18),
                ),*/
                      ),
                  const SizedBox(width: 16),
                  Expanded(
                      child: Column(
                    children: [
                      const Text(
                        'Saatlik Ücret : ',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        job.fee.toString() + ' ₺',
                        style: const TextStyle(fontSize: 18),
                      )
                    ],
                  )),
                ],
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Text(
                'Başvuru Sayısı: ${job.applicationCount}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
