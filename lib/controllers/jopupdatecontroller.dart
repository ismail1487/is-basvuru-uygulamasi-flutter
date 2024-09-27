import 'package:flutter/material.dart';
import 'package:jobbiteproject/models/job.dart';
import 'package:jobbiteproject/views/businness/jobupdatepage.dart';

class JobUpdateController {
  Future<Job> JobUpdatePageView(BuildContext context, String jobId) async {
    Job updatedJob = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobUpdatePage(jobId: jobId),
      ),
    );
    return updatedJob;
  }
}
