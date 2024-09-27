import 'package:flutter/material.dart';
import 'package:jobbiteproject/models/workplace.dart';
import 'package:jobbiteproject/services/firebaseservices.dart';
import 'package:jobbiteproject/views/businness/addworkplace.dart';
import 'package:jobbiteproject/views/businness/workplacedetailspage.dart';

class WorkplacesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<WorkPlace>>(
        future: FirebaseServices().getWorkPlaces(),
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
            final List<WorkPlace> workplaces = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: workplaces.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                        child: ItemWidget(
                          workPlace: workplaces[index],
                          context: context,
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddWorkplace(),
                          ),
                        );
                      },
                      child: const Text('İşyeri Ekle'),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    Key? key,
    required this.workPlace,
    required this.context,
  }) : super(key: key);

  final WorkPlace workPlace;
  final BuildContext context;

  void _handleTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkPlaceDetailsPage(workPlaceId: workPlace.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _handleTap,
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
                child: Text(
                  workPlace.name,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  workPlace.workplaceType,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
