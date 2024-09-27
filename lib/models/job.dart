class Job {
  final String jobId;
  final String workPlaceId;
  final String explain;
  final int fee;
  final DateTime createdat;
  final int status;
  final int maxpersoncount;
  final int personcount;
  final int applicationcount;

  Job({
    this.jobId = '',
    this.explain = '',
    this.fee = 0,
    this.workPlaceId = '',
    this.status = 0,
    this.maxpersoncount = 0,
    this.personcount = 0,
    this.applicationcount = 0,
    DateTime? createdat,
  }) : createdat = createdat ?? DateTime.now();
}
