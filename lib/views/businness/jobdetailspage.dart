import 'package:flutter/material.dart';
import 'package:jobbiteproject/controllers/jopupdatecontroller.dart';
import 'package:jobbiteproject/models/job.dart';
import 'package:jobbiteproject/models/workplace.dart';
import 'package:jobbiteproject/services/firebaseservices.dart';
import 'package:jobbiteproject/services/helper.dart';
import 'package:jobbiteproject/views/businness/applicationspage.dart';
import 'package:jobbiteproject/views/businness/businnessmainpage.dart';
//import 'package:jobbiteproject/views/businness/jobupdatepage.dart';
import 'package:jobbiteproject/views/customappbar.dart';
import 'package:jobbiteproject/views/mappage.dart';

class JobDetailsPage extends StatefulWidget {
  const JobDetailsPage({super.key, this.jobId = ''});
  final String jobId;

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  String jobId = '';
  @override
  void initState() {
    super.initState();
    jobId = widget.jobId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backButton: true,
        signOutButton: false,
      ),
      body: FutureBuilder<Job>(
          future: FirebaseServices().getJob(jobId),
          builder: (context, snapshotJob) {
            if (snapshotJob.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshotJob.hasError) {
              return Center(
                child: Text('Error: ${snapshotJob.error}'),
              );
            } else {
              final Job job = snapshotJob.data!;

              return FutureBuilder<WorkPlace>(
                future: FirebaseServices().getWorkPlace(job.workPlaceId),
                builder: (context, snapshotWorkPlace) {
                  if (snapshotWorkPlace.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshotWorkPlace.hasError) {
                    return Center(
                      child: Text('Error: ${snapshotJob.error}'),
                    );
                  } else {
                    final WorkPlace workPlace = snapshotWorkPlace.data!;

                    //TextEditingController workPlaceIdController = TextEditingController();
                    TextEditingController workPlaceNameController = TextEditingController();
                    TextEditingController workPlacePhotoController = TextEditingController();
                    TextEditingController explainController = TextEditingController();
                    TextEditingController feeController = TextEditingController();
                    TextEditingController personCountController = TextEditingController();
                    TextEditingController maxPersonCountController = TextEditingController();
                    TextEditingController applicationCountController = TextEditingController();

                    //double latitude = workPlace.latidude;
                    //double longitude = workPlace.longitude;

                    workPlacePhotoController.text = workPlace.workPlacePhoto;
                    workPlaceNameController.text = workPlace.name;
                    explainController.text = job.explain;
                    feeController.text = job.fee.toString();
                    personCountController.text = job.personcount.toString();
                    maxPersonCountController.text = job.maxpersoncount.toString();
                    applicationCountController.text = job.applicationcount.toString();

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            child: Center(
                              child: CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(
                                  workPlacePhotoController.text,
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
                                      await JobUpdateController().JobUpdatePageView(context, jobId);
                                      setState(() {});
                                    },
                                    child: const Icon(Icons.settings)),
                                const SizedBox(
                                  height: 5,
                                ),
                                _buildInfoItem(
                                  'İşyeri İsmi : ${workPlaceNameController.text}',
                                  context,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                _buildInfoItem(
                                  'Açıklama: ${explainController.text}',
                                  context,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                _buildInfoItem(
                                  'Tür: ${workPlace.workplaceType}',
                                  context,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                _buildInfoItem(
                                  'Saatlik Ücret: ${feeController.text} ₺',
                                  context,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                _buildInfoItem(
                                  'İşe Alınabilecek Kişi Sayısı: ${maxPersonCountController.text}',
                                  context,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                _buildInfoItem(
                                  'İşe Alınan Kişi Sayısı: ${personCountController.text}',
                                  context,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                _buildInfoItem(
                                  'Başvuru Sayısı: ${applicationCountController.text} ',
                                  context,
                                ),
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
                                      child: const Text('İş Yeri Konumuna Bak'),
                                    ),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ApplicationsPage(
                                              jobId: jobId,
                                            ),
                                          ),
                                        ),
                                      },
                                      child: const Text('Başvuruları Gör'),
                                    ),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await FirebaseServices().deleteJob(jobId).then((value) {
                                          if (value) {
                                            Helper.showMessage(context, 'Kayıt Silme İşlemi Başarılı');
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const BusinnessMainPage(pagenumber: 1),
                                              ),
                                            );
                                          }
                                        });
                                      },
                                      child: const Text('İş İlanı Kaydını Sil'),
                                    ),
                                    const Expanded(
                                      child: SizedBox(),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            }
          }),
    );
  }
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
