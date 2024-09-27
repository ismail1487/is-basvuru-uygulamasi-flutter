import 'package:flutter/material.dart';
import 'package:jobbiteproject/models/application.dart';
import 'package:jobbiteproject/models/useranduserdetails.dart';
import 'package:jobbiteproject/services/firebaseservices.dart';
import 'package:jobbiteproject/services/helper.dart';
import 'package:jobbiteproject/views/customappbar.dart';

class StudentApplicationDetails extends StatefulWidget {
  const StudentApplicationDetails({super.key, required this.applicationId});
  final String applicationId;
  @override
  State<StudentApplicationDetails> createState() => _StudentApplicationDetailsState();
}

class _StudentApplicationDetailsState extends State<StudentApplicationDetails> {
  late String applicationId;
  final String url =
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80';
  @override
  void initState() {
    super.initState();
    applicationId = widget.applicationId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backButton: true,
        signOutButton: false,
      ),
      body: FutureBuilder<Application>(
        future: FirebaseServices().getApplication(applicationId),
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
            final Application application = snapshot.data!;
            return FutureBuilder<UserAndUserdetails>(
              future: FirebaseServices().getStudent(application.studentid),
              builder: (context, snapshotStudent) {
                if (snapshotStudent.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshotStudent.hasError) {
                  return Center(
                    child: Text('Error: ${snapshotStudent.error}'),
                  );
                } else {
                  final UserAndUserdetails student = snapshotStudent.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        child: Center(
                          child: CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                              student.profilephotourl == '' ? url : student.profilephotourl,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            _buildInfoItem('Ad Soyad : ${student.name}  ${student.surname}', context),
                            const SizedBox(
                              height: 30,
                            ),
                            _buildInfoItem('E-posta: ${student.email}', context),
                            const SizedBox(
                              height: 30,
                            ),
                            _buildInfoItem('Telefon: ${student.name}', context),
                            const SizedBox(
                              height: 30,
                            ),
                            _buildInfoItem('Şehir: ${student.city}', context),
                            const SizedBox(
                              height: 30,
                            ),
                            application.status == 0
                                ? _buildInfoItem('Onay Durumu : Beklemede', context)
                                : application.status == 1
                                    ? _buildInfoItem('Onay Durumu : Onaylandı', context)
                                    : _buildInfoItem('Onay Durumu : Reddedildi', context)
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          const Expanded(
                            child: SizedBox(),
                          ),
                          IconButton(
                            onPressed: () {
                              FirebaseServices().setApplicationsStatus(1, applicationId).then((value) {
                                if (value == 'success') {
                                  Helper.showMessage(context, 'İşlem Başarılı');
                                  Navigator.pop(context);
                                } else if (value == 'full') {
                                  Helper.showMessage(context,
                                      'Bu iş için alınabilecek kişi sayısı yetersizdir iş detayları sayfasından güncelleme yapabilirsiniz');
                                } else if (value == 'full1') {
                                  Helper.showMessage(context,
                                      'İşlem başarılı. Bu iş için alınabilecek kişiler sona ermiştir iş detayları sayfasından güncelleme yapabilirsiniz ya da onay verilen bir kişiyi reddedip tekrar deneyebilirsiniz.');
                                } else if (value == 'success1') {
                                  Helper.showMessage(context, 'Zaten başvuruya onay verilmiş durumda');
                                }
                              });
                            },
                            icon: const Icon(Icons.check_circle, color: Colors.green),
                            iconSize: 90,
                          ),
                          const SizedBox(width: 40), // Araya bir boşluk ekleyebiliriz
                          IconButton(
                            onPressed: () {
                              FirebaseServices().setApplicationsStatus(2, applicationId).then((value) {
                                if (value == 'success') {
                                  Helper.showMessage(context, 'İşlem Başarılı');
                                  Navigator.pop(context);
                                }
                                // } else if (value == 'full') {
                                //   Helper.showMessage(context,
                                //       'Bu İş İçin Alınabilecek Kişi Sayısı Yetersizdir İş Detayları Sayfasından Güncelleme Yapabilirsiniz');
                                // } else if (value == 'full1') {
                                //   Helper.showMessage(context,
                                //       'Bu İş İçin Alınabilecek Kişiler Sona Ermiştir İş Detayları Sayfasından Güncelleme Yapabilirsiniz Ya Da Onay verilen bir kişiyi reddedip tekrar deneyebilirsiniz.');
                                // }
                              });
                            },
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            iconSize: 90.0,
                          ),
                          const Expanded(
                            child: SizedBox(),
                          ),
                        ],
                      )
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
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
