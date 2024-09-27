class Application {
  final String id;
  final String jobid;
  final String studentid;
  final int status;
  final DateTime createdat;
  Application({
    this.id = '',
    this.jobid = '',
    this.studentid = '',
    this.status = 0,
    DateTime? createdat,
  }) : createdat = createdat ?? DateTime.now();
}
