import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapPageGecici extends StatefulWidget {
  const MapPageGecici({Key? key}) : super(key: key);

  @override
  State<MapPageGecici> createState() => _MapPageGeciciState();
}

class _MapPageGeciciState extends State<MapPageGecici> {
  GoogleMapController? controller;
  Set<Marker> _markers = {}; // İşaretçileri tutmak için küme oluşturuyoruz
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
    return await Geolocator.getCurrentPosition();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 11,
        ),
        onMapCreated: (GoogleMapController controller) async {
          controller = controller;
          Position position = await getCurrentLocation();
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 15,
              ),
            ),
          );
        },
        markers: _markers,
        onLongPress: _addMarker,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveLocationInfo();
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  // Uzun tıklama yapıldığında çalışacak metot
  void _addMarker(LatLng point) {
    setState(() {
      _markers.clear(); // Önceki işaretçileri temizle
      _markers.add(
        Marker(
          markerId: MarkerId(point.toString()),
          position: point,
          infoWindow: InfoWindow(
            title: 'İşaretçi',
            snippet: 'Lat: ${point.latitude}, Lng: ${point.longitude}',
          ),
        ),
      );
    });
  }

  // Adres ve koordinatları alıp bir metot aracılığıyla gönderme
  void _saveLocationInfo() async {
    if (_markers.isEmpty) return;

    final marker = _markers.first;
    final addresses = await placemarkFromCoordinates(
      marker.position.latitude,
      marker.position.longitude,
    );

    final first = addresses.first;
    final address =
        '${first.name}, ${first.subLocality}, ${first.locality}, ${first.administrativeArea}, ${first.country}';

    // Adresi ve koordinatları göndermek için bir metot çağrılabilir
    _sendLocationInfo(
        address, marker.position.latitude, marker.position.longitude);
  }

  // Bu metotun gerçekleştireceği işlem örneğin bir API çağrısı veya veritabanı güncellemesi olabilir
  void _sendLocationInfo(String address, double latitude, double longitude) {
    print('Address: $address');
    print('Latitude: $latitude, Longitude: $longitude');
  }
}
