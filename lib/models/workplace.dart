class WorkPlace {
  final String id;
  final String workPlacePhoto;
  final String name;
  final String adresses;
  final double latidude;
  final double longitude;
  final String workplaceType;
  final String owner;
  final DateTime createdat;
  final int status;

  WorkPlace({
    this.id = '',
    this.workPlacePhoto = '',
    this.name = '',
    this.adresses = '',
    this.latidude = 0,
    this.longitude = 0,
    this.workplaceType = '',
    this.owner = '',
    this.status = 0,
    DateTime? createdat,
  }) : createdat = createdat ?? DateTime.now();
}
