import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jobbiteproject/views/customappbar.dart';

class MapPage extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final String? purposeofarrival;

  // Normal constructor
  const MapPage({Key? key})
      : latitude = null,
        longitude = null,
        purposeofarrival = null,
        super(key: key);

  // Constructor with latitude and longitude
  const MapPage.withLocation(
      {required double latitude, required double longitude, Key? key, required String purposeofarrival})
      : latitude = latitude,
        longitude = longitude,
        purposeofarrival = purposeofarrival,
        super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // İşaretçileri tutmak için küme oluşturuyoruz

  Set<Marker> markers = {};
  String? purposeofarrival = '';
  bool buttonvisible = true;

  late CameraPosition initialCameraPosition;
  late Future<Position> position;

  @override
  void initState() {
    super.initState();
    purposeofarrival = widget.purposeofarrival;
    if (purposeofarrival == 'look') {
      buttonvisible = false;
    } else if (purposeofarrival == 'update') {
      buttonvisible = true;
    } else {
      buttonvisible = true;
    }
    if (widget.latitude != null && widget.longitude != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('initial'),
          position: LatLng(widget.latitude!, widget.longitude!),
          infoWindow: InfoWindow(
            title: 'İşaretçi',
            snippet: 'Lat: ${widget.latitude}, Lng: ${widget.longitude}',
          ),
        ),
      );
      initialCameraPosition = CameraPosition(
        target: LatLng(widget.latitude!, widget.longitude!),
        zoom: 15,
      );
    } else {
      position = getCurrentLocation();
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceenabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceenabled) {
      return Future.error('location service disenabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Future.error('error');
      }
    }
    Position p = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return p;
  }

  @override
  Widget build(BuildContext context) {
    if (purposeofarrival == 'look') {
      return Scaffold(
        appBar: CustomAppBar(backButton: true, signOutButton: false),
        body: Column(
          children: [
            Visibility(
              visible: buttonvisible,
              child: const Expanded(
                flex: 5,
                child: Text(
                  'İşyeri Konumunu Seçmek İçin Haritadaki İşyeri konumuna Uzunca Dokununuz',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
            Expanded(
              flex: 95,
              child: GoogleMap(
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (GoogleMapController controller) async {
                  /*controller = controller;
                  Position position = await getCurrentLocation();
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(position.latitude, position.longitude),
                        zoom: 15,
                      ),
                    ),
                  );*/
                },
                markers: markers,
                onLongPress: _addMarker,
                myLocationEnabled: false,
              ),
            ),
          ],
        ),
        floatingActionButton: buttonvisible
            ? FloatingActionButton(
                onPressed: () {
                  _saveLocationInfo();
                },
                child: const Icon(Icons.save),
              )
            : null,
        floatingActionButtonLocation: buttonvisible ? FloatingActionButtonLocation.startFloat : null,
      );
    } else {
      return FutureBuilder<Position>(
          future: position,
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
              final Position p = snapshot.data!;
              return Scaffold(
                appBar: CustomAppBar(backButton: true, signOutButton: false),
                body: Column(
                  children: [
                    Visibility(
                      visible: buttonvisible,
                      child: const Expanded(
                        flex: 5,
                        child: Text(
                          'İşyeri Konumunu Seçmek İçin Haritadaki İşyeri konumuna Uzunca Dokununuz',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 95,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(target: LatLng(p.latitude, p.longitude), zoom: 15),
                        onMapCreated: (GoogleMapController controller) async {},
                        markers: markers,
                        onLongPress: _addMarker,
                        myLocationEnabled: true,
                      ),
                    ),
                  ],
                ),
                floatingActionButton: buttonvisible
                    ? FloatingActionButton(
                        onPressed: () {
                          _saveLocationInfo();
                        },
                        child: const Icon(Icons.save),
                      )
                    : null,
                floatingActionButtonLocation: buttonvisible ? FloatingActionButtonLocation.startFloat : null,
              );
            }
          });
    }
  }

  // Uzun tıklama yapıldığında çalışacak metot
  void _addMarker(LatLng point) {
    setState(() {
      if (buttonvisible) {
        markers.clear(); // Önceki işaretçileri temizle
        markers.add(
          Marker(
            markerId: MarkerId(point.toString()),
            position: point,
            infoWindow: InfoWindow(
              title: 'İşaretçi',
              snippet: 'Lat: ${point.latitude}, Lng: ${point.longitude}',
            ),
          ),
        );
      }
    });
  }

  // Adres ve koordinatları alıp bir metot aracılığıyla gönderme
  void _saveLocationInfo() async {
    if (markers.isEmpty) return;

    final marker = markers.first;
    final addresses = await placemarkFromCoordinates(
      marker.position.latitude,
      marker.position.longitude,
    );

    final first = addresses.first;
    final address =
        '${first.name}, ${first.subLocality}, ${first.locality}, ${first.administrativeArea}, ${first.country}';

    // Seçilen konumu geri döndür
    Navigator.pop(
      context,
      {
        'address': address,
        'latitude': marker.position.latitude,
        'longitude': marker.position.longitude,
      },
    );
  }
}
