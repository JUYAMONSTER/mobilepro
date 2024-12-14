import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class LaundryPage extends StatefulWidget {
  @override
  _LaundryPageState createState() => _LaundryPageState();
}

class _LaundryPageState extends State<LaundryPage> {
  GoogleMapController? mapController;
  LatLng? _currentLocation;
  Set<Marker> _markers = {};
  Location _location = Location();

  final String _placesApiKey = 'AIzaSyCsW8vzkt0_i2bukgR-yhw8HfB2PIRclbA';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationData = await _location.getLocation();
      setState(() {
        _currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
      });
      _loadLaundromats(); // 위치를 가져온 후 세탁소 검색
    } catch (e) {
      print("위치 정보를 가져오는 데 실패했습니다: $e");
    }
  }

  Future<void> _loadLaundromats() async {
    if (_currentLocation == null) return;

    String url = 'https://places.googleapis.com/v1/places:searchNearby';

    // 요청 본문 설정
    final body = json.encode({
      "includedTypes": ["laundry"], // 세탁소의 유형을 지정
      "maxResultCount": 10,
      "locationRestriction": {
        "circle": {
          "center": {
            "latitude": _currentLocation!.latitude,
            "longitude": _currentLocation!.longitude
          },
          "radius": 5000.0 // 5km 반경
        }
      }
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': _placesApiKey,
        'X-Goog-FieldMask': 'places.displayName,places.formattedAddress,places.location'
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['places'] != null) {
        var places = data['places'];

        setState(() {
          _markers.clear();
          for (var place in places) {
            double lat = place['location']['latitude'];
            double lng = place['location']['longitude'];
            String name = place['displayName']['text'];
            String address = place['formattedAddress'];

            _markers.add(
              Marker(
                markerId: MarkerId(name),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(
                  title: name,
                  snippet: address,
                ),
              ),
            );
          }
        });
      } else {
        print('Error fetching places: ${data['status']}');
      }
    } else {
      print('Failed to load places: ${response.reasonPhrase}');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentLocation != null) {
      mapController?.moveCamera(CameraUpdate.newLatLng(_currentLocation!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('세탁소 찾기'),
      ),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _currentLocation!,
          zoom: 16.0,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
