import 'package:flutter/material.dart';
import 'package:jobbiteproject/models/workplace.dart';
import 'package:jobbiteproject/views/businness/workplaceupdatepage.dart';

class WorkPlaceUpdateController {
  Future<WorkPlace> WorkPlaceUpdatePageView(BuildContext context, String workPlaceId) async {
    WorkPlace updatedWorkPlace = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkPlaceUpdatePage(workPlaceId: workPlaceId),
      ),
    );
    return updatedWorkPlace;
  }
}
