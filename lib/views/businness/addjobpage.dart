import 'package:customizable_counter/customizable_counter.dart';
import 'package:flutter/material.dart';
import 'package:jobbiteproject/models/job.dart';
import 'package:jobbiteproject/models/workplace.dart';
import 'package:jobbiteproject/services/firebaseservices.dart';
import 'package:jobbiteproject/services/helper.dart';
import 'package:jobbiteproject/views/businness/businnessmainpage.dart';
import 'package:jobbiteproject/views/customappbar.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  TextEditingController selectedWorkPlaceController = TextEditingController();
  TextEditingController explainController = TextEditingController();
  TextEditingController payController = TextEditingController();
  TextEditingController personCountController = TextEditingController();

  List<WorkPlace> workPlaces = [];

  @override
  void initState() {
    super.initState();
    _loadWorkplaceData();
  }

  void _loadWorkplaceData() async {
    workPlaces = await FirebaseServices().getWorkPlaces();
    setState(() {}); // Update the UI to reflect the loaded data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backButton: true,
        signOutButton: false,
      ),
      body: workPlaces.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                hint: const Text("İş Yeri Seç"),
                                value: selectedWorkPlaceController.text.isNotEmpty
                                    ? selectedWorkPlaceController.text
                                    : null,
                                onChanged: (value) {
                                  setState(() {
                                    selectedWorkPlaceController.text = value!;
                                  });
                                },
                                items: [
                                  const DropdownMenuItem<String>(
                                    value: '',
                                    child: const Text(''),
                                  ),
                                  ...workPlaces.map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e.id,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(e.workPlacePhoto),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(e.name),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: TextField(
                      maxLines: 3, // İstediğiniz satır sayısını belirtin
                      keyboardType: TextInputType.multiline,
                      controller: explainController,
                      decoration: const InputDecoration(
                        labelText: 'İş Detayı',
                        hintText: 'İş Detayı Giriniz',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: TextField(
                      controller: payController,
                      decoration: const InputDecoration(
                        labelText: 'Saatlik Ücret',
                        hintText: 'Saatlik Ücret Bilgisi Giriniz',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1),
                    child: Text('İşe Alınacak Kişi Sayısı : '),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                    child: CustomizableCounter(
                      borderColor: Colors.black,
                      textColor: Colors.black,
                      backgroundColor: Colors.white,
                      buttonText: "İşe Alınacak Kişi Sayısı",
                      showButtonText: false,
                      textSize: 18,
                      count: 0,
                      step: 1,
                      minCount: 0,
                      maxCount: 10,
                      incrementIcon: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      decrementIcon: const Icon(
                        Icons.remove,
                        color: Colors.black,
                      ),
                      onCountChange: (c) {
                        setState(() {
                          int personcount = c.toInt();
                          personCountController.text = personcount.toString();
                        });
                      },
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (int.parse(personCountController.text) != 0) {
                          Job job = Job(
                            explain: explainController.text,
                            fee: int.parse(payController.text),
                            workPlaceId: selectedWorkPlaceController.text,
                            maxpersoncount: int.parse(personCountController.text),
                          );
                          await FirebaseServices().addJob(job);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BusinnessMainPage(pagenumber: 1),
                            ),
                          );
                        } else {
                          Helper.showMessage(context, 'Lütfen Kişi Sayısı Bilgisini Giriniz');
                        }
                      },
                      child: const Text("Kaydet"))
                ],
              ),
            ),
    );
  }
}
