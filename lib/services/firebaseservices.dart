import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jobbiteproject/models/application.dart';
import 'package:jobbiteproject/models/job.dart';
import 'package:jobbiteproject/models/jobandworkplace.dart';
import 'package:jobbiteproject/models/user.dart';
import 'package:jobbiteproject/models/useranduserdetails.dart';
import 'package:jobbiteproject/models/userdetails.dart';
import 'package:jobbiteproject/models/workplace.dart';
import 'package:uuid/uuid.dart';

class FirebaseServices {
  Future<String> signIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        final db = FirebaseFirestore.instance;
        final user = await db.collection("Users").where("email", isEqualTo: email).get();
        if (user.docs.isNotEmpty) {
          final userlog = user.docs.first;
          final userType = userlog["userType"];
          if (userType == 1) {
            //öğrenci sayfasına gidecek
            return 'student';
          } else {
            //İşveren sayfasına gidecek
            return 'businness';
          }
        } else {
          return 'Böyle bir kullanıcı yok';
        }
      } else {
        return 'Böyle bir kullanıcı yok';
      } // Oturum açma işlemi başarılı oldu
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Kullanıcı bulunamadı'; // Eğer kullanıcı bulunamazsa
      } else if (e.code == 'wrong-password') {
        return 'Yanlış şifre'; // Eğer yanlış şifre girilirse
      } else {
        return 'Bir hata oluştu: ${e.toString()}'; // Diğer hata durumları için
      }
    }
  }

  Future<String> addUser(User user) async {
    try {
      //öncelikle Authentication ile uygulamaya hesap eklenecek altta
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user.email, password: user.password);
      String uid = credential.user!.uid;
      user.uid = uid;
      //Ardından bu kullanıcının bilgileri eklenecek authenticationdan gelen id ile birlikte
      final db = FirebaseFirestore.instance;
      final userCollection = db.collection("Users");

      // Eğer "Users" koleksiyonu henüz yoksa, oluşturulur
      await userCollection.doc(user.uid).set({
        'name': user.name,
        'surname': user.surname,
        'email': user.email,
        'password': user.password,
        'userType': user.userType,
        'city': user.city,
      });

      UserDetails userDetails = UserDetails();
      final userDetailCollection = db.collection("UserDetails");

      await userDetailCollection.doc(user.uid).set({
        'univercity': userDetails.univercity,
        'department': userDetails.department,
        'iban': userDetails.iban,
        'profilePhotoUrl': userDetails.profilephotourl,
      });

      return 'Kullanıcı başarıyla eklendi.';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Şifre Zayıf';
      } else if (e.code == 'email-already-in-use') {
        return 'E-mail Adresi Kullanımda';
      } else {
        return e.code;
      }
    }
  }

  Future<String> uploadUser(UserAndUserdetails user) async {
    try {
      //öncelikle Authentication ile uygulamaya hesap eklenecek altta
      final auth = FirebaseAuth.instance.currentUser?.uid;
      //Ardından bu kullanıcının bilgileri eklenecek authenticationdan gelen id ile birlikte
      final db = FirebaseFirestore.instance;
      final userCollection = db.collection("Users");

      // Eğer "Users" koleksiyonu henüz yoksa, oluşturulur
      await userCollection.doc(auth).update({
        'name': user.name,
        'surname': user.surname,
        'email': user.email,
        'city': user.city,
      });

      //UserDetails userDetails = UserDetails();
      final userDetailCollection = db.collection("UserDetails");

      await userDetailCollection.doc(auth).update({
        'profilePhotoUrl': user.profilephotourl,
      });

      return 'Kullanıcı başarıyla eklendi.';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Şifre Zayıf';
      } else if (e.code == 'email-already-in-use') {
        return 'E-mail Adresi Kullanımda';
      } else {
        return e.code;
      }
    }
  }

  Future<String> addProfilePhoto(File file) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    String fileName = const Uuid().v4();
    try {
      await firebaseStorage.ref('profilephotos/$fileName.jpg').putFile(file);
      String downloadURL = await FirebaseStorage.instance.ref('profilephotos/$fileName.jpg').getDownloadURL();
      return downloadURL;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> getUserType(String email) async {
    final db = FirebaseFirestore.instance;
    final user = await db.collection("Users").where("email", isEqualTo: email).get();
    if (user.docs.isNotEmpty) {
      final userlog = user.docs.first;
      final userType = userlog["userType"];
      if (userType == 1) {
        return 'student';
      } else {
        return 'business';
      }
    } else {
      return 'Böyle bir kullanıcı yok';
    }
  }

  Future<UserAndUserdetails> getProfileInformations() async {
    final db = FirebaseFirestore.instance;

    final uid = FirebaseAuth.instance.currentUser!.uid.toString();

    final user = await db.collection("Users").doc(uid).get();
    final userDetails = await db.collection("UserDetails").doc(uid).get();

    final email = user['email'];
    final name = user['name'];
    final surname = user['surname'];
    final department = userDetails['department'];
    final iban = userDetails['iban'];
    final profilephotourl = userDetails['profilePhotoUrl'];
    final univercity = userDetails['univercity'];
    final cityid = user['city'];

    UserAndUserdetails userAndUserdetails = UserAndUserdetails(
      name: name,
      surname: surname,
      email: email,
      city: cityid,
      univercity: univercity,
      department: department,
      iban: iban,
      profilephotourl: profilephotourl,
    );

    return userAndUserdetails;
  }

  Future<UserAndUserdetails> getStudent(String studentId) async {
    final db = FirebaseFirestore.instance;

    final user = await db.collection("Users").doc(studentId).get();
    final userDetails = await db.collection("UserDetails").doc(studentId).get();

    final email = user['email'];
    final name = user['name'];
    final surname = user['surname'];
    final department = userDetails['department'];
    final iban = userDetails['iban'];
    final profilephotourl = userDetails['profilePhotoUrl'];
    final univercity = userDetails['univercity'];
    final cityid = user['city'];

    UserAndUserdetails userAndUserdetails = UserAndUserdetails(
      name: name,
      surname: surname,
      email: email,
      city: cityid,
      univercity: univercity,
      department: department,
      iban: iban,
      profilephotourl: profilephotourl,
    );

    return userAndUserdetails;
  }

  //WORKPLACE
  Future<String> addWorkPlacePhoto(File file) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    String fileName = const Uuid().v4();
    try {
      await firebaseStorage.ref('workplacephotos/$fileName.jpg').putFile(file);
      String downloadURL = await FirebaseStorage.instance.ref('workplacephotos/$fileName.jpg').getDownloadURL();
      return downloadURL;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> addWorkPlace(WorkPlace workPlace) async {
    //Ardından bu kullanıcının bilgileri eklenecek authenticationdan gelen id ile birlikte
    final db = FirebaseFirestore.instance;
    final userCollection = db.collection("WorkPlaces");
    String fileName = const Uuid().v4();
    String owneruid = FirebaseAuth.instance.currentUser!.uid;
    // Eğer "Users" koleksiyonu henüz yoksa, oluşturulur
    await userCollection.doc(fileName).set({
      'name': workPlace.name,
      'owner': owneruid,
      'adresses': workPlace.adresses,
      'createdat': workPlace.createdat,
      'status': workPlace.status,
      'latitude': workPlace.latidude,
      'longitude': workPlace.longitude,
      'workplacetype': workPlace.workplaceType,
      'workplacephoto': workPlace.workPlacePhoto,
    });
  }

  Future<List<WorkPlace>> getWorkPlaces() async {
    List<WorkPlace> workPlaces = [];
    final db = FirebaseFirestore.instance;
    final uid = FirebaseAuth.instance.currentUser!.uid.toString();
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection('WorkPlaces').where('owner', isEqualTo: uid).where('status', isEqualTo: 0).get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
      Timestamp dateStampt = documentSnapshot['createdat'];
      DateTime date = dateStampt.toDate();
      WorkPlace w = WorkPlace(
        adresses: documentSnapshot['adresses'],
        latidude: documentSnapshot['latitude'],
        longitude: documentSnapshot['longitude'],
        name: documentSnapshot['name'],
        owner: documentSnapshot['owner'],
        workPlacePhoto: documentSnapshot['workplacephoto'],
        workplaceType: documentSnapshot['workplacetype'],
        id: documentSnapshot.id,
        createdat: date,
      );
      workPlaces.add(w);
    }
    return workPlaces;
  }

  Future<WorkPlace> getWorkPlace(String documentId) async {
    final db = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await db.collection('WorkPlaces').doc(documentId).get();
    Timestamp dateStampt = documentSnapshot['createdat'];
    DateTime date = dateStampt.toDate();
    WorkPlace w = WorkPlace(
      adresses: documentSnapshot['adresses'],
      latidude: documentSnapshot['latitude'],
      longitude: documentSnapshot['longitude'],
      name: documentSnapshot['name'],
      owner: documentSnapshot['owner'],
      workPlacePhoto: documentSnapshot['workplacephoto'],
      workplaceType: documentSnapshot['workplacetype'],
      createdat: date,
      status: documentSnapshot['status'],
      id: documentSnapshot.id,
    );
    return w;
  }

  Future<void> uploadWorkPlace(WorkPlace workPlace) async {
    final db = FirebaseFirestore.instance;
    final userCollection = db.collection("WorkPlaces");

    await userCollection.doc(workPlace.id).update({
      'name': workPlace.name,
      'owner': workPlace.owner,
      'adresses': workPlace.adresses,
      'latitude': workPlace.latidude,
      'longitude': workPlace.longitude,
      'workplacetype': workPlace.workplaceType,
      'workplacephoto': workPlace.workPlacePhoto,
    });
  }

  Future<bool> deleteWorkPlace(String workPlaceId) async {
    try {
      final db = FirebaseFirestore.instance;
      final workPlaceCollection = db.collection("WorkPlaces");
      final jobCollection = db.collection('Jobs');

      await workPlaceCollection.doc(workPlaceId).update({
        'status': 1,
      });

      //işyerine bağlı olan işlerin statusunu 1 yaparak siliyoruz.
      QuerySnapshot<Map<String, dynamic>> js =
          await db.collection('Jobs').where('workplaceid', isEqualTo: workPlaceId).get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> j in js.docs) {
        await jobCollection.doc(j.id).update({
          'status': 1,
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  //JOBS
  Future<void> addJob(Job job) async {
    final db = FirebaseFirestore.instance;
    String fileName = const Uuid().v4();
    final jobCollection = db.collection("Jobs");

    await jobCollection.doc(fileName).set({
      'workplaceid': job.workPlaceId,
      'id': fileName,
      'fee': job.fee,
      'explain': job.explain,
      'createdat': job.createdat,
      'status': job.status,
      'maxpersoncount': job.maxpersoncount,
      'personcount': job.personcount,
      'applicationcount': job.applicationcount,
    });
  }

  Future<Job> getJob(String jobid) async {
    final db = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await db.collection('Jobs').doc(jobid).get();

    Timestamp dateStampt = documentSnapshot['createdat'];
    DateTime date = dateStampt.toDate();

    Job job = Job(
      jobId: documentSnapshot.id,
      fee: documentSnapshot['fee'],
      explain: documentSnapshot['explain'],
      workPlaceId: documentSnapshot['workplaceid'],
      createdat: date,
      status: documentSnapshot['status'],
      maxpersoncount: documentSnapshot['maxpersoncount'],
      personcount: documentSnapshot['personcount'],
      applicationcount: documentSnapshot['applicationcount'],
    );

    return job;
  }

  Future<List<JobAndWorkPlace>> getJobs() async {
    final db = FirebaseFirestore.instance;
    List<String> workPlaceId = [];
    List<JobAndWorkPlace> jobs = [];
    final uid = FirebaseAuth.instance.currentUser!.uid.toString();

    QuerySnapshot<Map<String, dynamic>> querySnapshotWorkplaces =
        await db.collection('WorkPlaces').where('owner', isEqualTo: uid).where('status', isEqualTo: 0).get();
    //status değerleri 0 : aktif 1: silinmiş

    if (querySnapshotWorkplaces.docs.isEmpty) {
      return jobs;
    }
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshotWorkplaces.docs) {
      workPlaceId.add(documentSnapshot.id);
    }

    List<QuerySnapshot<Map<String, dynamic>>> snapshots = await Future.wait([
      db.collection('Jobs').where('workplaceid', whereIn: workPlaceId).where('status', isEqualTo: 0).get(),
      db.collection('Jobs').where('workplaceid', whereIn: workPlaceId).where('status', isEqualTo: 2).get(),
    ]);

    List<QueryDocumentSnapshot<Map<String, dynamic>>> combinedDocs = [];
    for (var snapshot in snapshots) {
      combinedDocs.addAll(snapshot.docs);
    }

    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in combinedDocs) {
      String workPlaceId = documentSnapshot['workplaceid'];
      DocumentSnapshot<Map<String, dynamic>> workPlaceSnapshot =
          querySnapshotWorkplaces.docs.firstWhere((element) => element.id == workPlaceId);
      String workPlacePhoto = workPlaceSnapshot['workplacephoto'];
      String workPlaceName = workPlaceSnapshot['name'];
      int applicationCount = documentSnapshot['applicationcount'];
      JobAndWorkPlace job = JobAndWorkPlace(
        jobId: documentSnapshot.id,
        fee: documentSnapshot['fee'],
        workPlaceName: workPlaceName,
        workPlacePhoto: workPlacePhoto,
        applicationCount: applicationCount,
      );
      jobs.add(job);
    }

    return jobs;
  }

  Future<List<JobAndWorkPlace>> getJobsStudent() async {
    final db = FirebaseFirestore.instance;
    List<JobAndWorkPlace> jobs = [];
    //final uid = FirebaseAuth.instance.currentUser!.uid.toString();

    QuerySnapshot<Map<String, dynamic>> querySnapshotWorkplaces =
        await db.collection('WorkPlaces').where('status', isEqualTo: 0).get();

    if (querySnapshotWorkplaces.docs.isEmpty) {
      return jobs;
    }

    QuerySnapshot<Map<String, dynamic>> querySnapshotJobs =
        await db.collection('Jobs').where('status', isEqualTo: 0).get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshotJobs.docs) {
      String workPlaceId = documentSnapshot['workplaceid'];
      DocumentSnapshot<Map<String, dynamic>> workPlaceSnapshot =
          querySnapshotWorkplaces.docs.firstWhere((element) => element.id == workPlaceId);
      String workPlacePhoto = workPlaceSnapshot['workplacephoto'];
      String workPlaceName = workPlaceSnapshot['name'];
      int applicationCount = documentSnapshot['applicationcount'];
      JobAndWorkPlace job = JobAndWorkPlace(
        jobId: documentSnapshot.id,
        fee: documentSnapshot['fee'],
        workPlaceName: workPlaceName,
        workPlacePhoto: workPlacePhoto,
        applicationCount: applicationCount,
      );
      jobs.add(job);
    }

    return jobs;
  }

  Future<void> updateJob(Job job) async {
    final db = FirebaseFirestore.instance;
    final jobCollection = db.collection("Jobs");

    await jobCollection.doc(job.jobId).update({
      'workplaceid': job.workPlaceId,
      'fee': job.fee,
      'explain': job.explain,
      'maxpersoncount': job.maxpersoncount,
    });
  }

  Future<bool> deleteJob(String jobId) async {
    try {
      final db = FirebaseFirestore.instance;
      final workPlaceCollection = db.collection("Jobs");

      await workPlaceCollection.doc(jobId).update({
        'status': 1,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  //Applications
  Future<String> addApplication(Application application) async {
    final db = FirebaseFirestore.instance;
    String fileName = const Uuid().v4();
    final applicationCollection = db.collection("Applications");
    final jobCollection = db.collection('Jobs');
    final uid = FirebaseAuth.instance.currentUser!.uid.toString();

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await applicationCollection.get();

    DocumentSnapshot<Map<String, dynamic>> documentSnapshotJob = await jobCollection.doc(application.jobid).get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
      if (documentSnapshot['studentid'] == uid && documentSnapshot['jobid'] == application.jobid) {
        return 'donttryagain';
      } else {
        continue;
      }
    }

    try {
      int applicationcount = documentSnapshotJob['applicationcount'];
      applicationcount += 1;
      await applicationCollection.doc(fileName).set({
        'jobid': application.jobid,
        'studentid': uid,
        'status': application.status, //statusu 0 ise beklemede statusu 1 ise onaylandı 2 ise reddedildi olacak
        'id': fileName,
        'createddat': application.createdat,
      });
      await jobCollection.doc(application.jobid).update({
        'applicationcount': applicationcount,
      });
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<List<Application>> getApplicationsStudent() async {
    List<Application> applications = [];
    final db = FirebaseFirestore.instance;
    final applicationCollection = db.collection("Applications");
    final uid = FirebaseAuth.instance.currentUser!.uid.toString();

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await applicationCollection.get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
      if (documentSnapshot['studentid'] == uid) {
        Timestamp dateStampt = documentSnapshot['createddat'];
        DateTime date = dateStampt.toDate();
        Application a = Application(
          id: documentSnapshot.id,
          status: documentSnapshot['status'],
          createdat: date,
          jobid: documentSnapshot['jobid'],
          studentid: documentSnapshot['studentid'],
        );
        applications.add(a);
      }
    }
    return applications;
  }

  Future<List<Application>> getApplicationsBusiness(String jobId) async {
    List<Application> applications = [];
    final db = FirebaseFirestore.instance;
    final applicationCollection = db.collection("Applications");

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await applicationCollection.where('jobid', isEqualTo: jobId).get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
      Timestamp dateStampt = documentSnapshot['createddat'];
      DateTime date = dateStampt.toDate();
      Application a = Application(
        id: documentSnapshot.id,
        status: documentSnapshot['status'],
        createdat: date,
        jobid: documentSnapshot['jobid'],
        studentid: documentSnapshot['studentid'],
      );
      applications.add(a);
    }
    return applications;
  }

  Future<Application> getApplication(String applicationId) async {
    final db = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await db.collection('Applications').doc(applicationId).get();
    Timestamp dateStampt = documentSnapshot['createddat'];
    DateTime date = dateStampt.toDate();
    Application a = Application(
      id: documentSnapshot.id,
      jobid: documentSnapshot['jobid'],
      studentid: documentSnapshot['studentid'],
      createdat: date,
      status: documentSnapshot['status'],
    );
    return a;
  }

  Future<String> setApplicationsStatus(int status, String applicationId) async {
    try {
      final db = FirebaseFirestore.instance;
      final applicationCollection = db.collection('Applications');
      final jobCollection = db.collection('Jobs');

      DocumentSnapshot<Map<String, dynamic>> documentSnapshotApplication =
          await applicationCollection.doc(applicationId).get();

      DocumentSnapshot<Map<String, dynamic>> documentSnapshotJob =
          await jobCollection.doc(documentSnapshotApplication['jobid']).get();

      int maxPersonCount = documentSnapshotJob['maxpersoncount'];
      int personCount = documentSnapshotJob['personcount'];

      if (status == 1) {
        if (documentSnapshotApplication['status'] == 2 || documentSnapshotApplication['status'] == 0) {
          if (maxPersonCount - personCount == 0) {
            return 'full';
          } else if (maxPersonCount - personCount == 1) {
            personCount = maxPersonCount;
            await applicationCollection.doc(applicationId).update({
              'status': status,
            });

            await jobCollection.doc(documentSnapshotApplication['jobid']).update({
              'personcount': personCount,
              'status': 2,
            });

            QuerySnapshot<Map<String, dynamic>> querySnapshot =
                await applicationCollection.where('jobid', isEqualTo: documentSnapshotApplication['jobid']).get();
            for (QueryDocumentSnapshot<Map<String, dynamic>> d in querySnapshot.docs) {
              if (d['status'] == 0) {
                await applicationCollection.doc(d.id).update({
                  'status': 2,
                });
              }
            }
            return 'full1';
          } else {
            personCount = personCount + 1;
            await applicationCollection.doc(applicationId).update({
              'status': status,
            });

            await jobCollection.doc(documentSnapshotApplication['jobid']).update({
              'personcount': personCount,
            });

            return 'success';
          }
        } else {
          return 'success1';
        }
      } else {
        if (documentSnapshotApplication['status'] == 1) {
          personCount = personCount - 1;
          await applicationCollection.doc(applicationId).update({
            'status': status,
          });
          if (documentSnapshotJob['status'] == 2) {
            await jobCollection.doc(documentSnapshotApplication['jobid']).update({
              'personcount': personCount,
              'status': 0,
            });
          } else {
            await jobCollection.doc(documentSnapshotApplication['jobid']).update({
              'personcount': personCount,
            });
          }
          return 'success';
        } else if (documentSnapshotApplication['status'] == 2) {
          return 'success';
        } else {
          await applicationCollection.doc(applicationId).update({
            'status': status,
          });
          return 'success';
        }
      }
    } catch (e) {
      return e.toString();
    }
  }
}
