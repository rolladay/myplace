import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:myplace/models/place.dart';
import 'package:myplace/screens/map.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});
  final void Function(PlaceLocation location) onSelectLocation;
  // 이게 이미지인풋에서도 쓴 방법이지만, 부모함수가 어떤 걸 선택했는지 알게 하기 위한 방법이거든...?
  //이건 좀 공부를 많이 하자. 이걸 이해하자...

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? pickedLocation;
  bool isGettingLocation = false;

  String get locationImage {
    if (pickedLocation == null) {
      return '';
    }
    final lat = pickedLocation!.latitude;
    final lng = pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:black%7Clabel:A%7C$lat,$lng&key=AIzaSyDtW8E5nQcMna_abqEoX9_QsLpeGxB0d4g';
  }

  void saveLocation(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyDtW8E5nQcMna_abqEoX9_QsLpeGxB0d4g');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    print(resData);
    final address = resData['results'][0]['formatted_address'];

    setState(() {
      pickedLocation =
          PlaceLocation(latitude: lat, longitude: lng, address: address);
      isGettingLocation = false;
    });
    widget.onSelectLocation(pickedLocation!);
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      isGettingLocation = true;
    });

    locationData = await location.getLocation();

    final longitude = locationData.longitude;
    final latitude = locationData.latitude;

    if (longitude == null || latitude == null) {
      return;
    }

    saveLocation(
      latitude,
      longitude,
    );
  }

  void selectOnMap() async {
    final pickedLoacation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(),
      ),
    );
    if (pickedLoacation == null) {
      return;
    }
    saveLocation(pickedLoacation.latitude, pickedLoacation.longitude);


  }

  @override
  Widget build(BuildContext context) {
    Widget locationContent = isGettingLocation
        ? const CircularProgressIndicator()
        : const Text(
            'No Location Chosen',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          );

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.2,
              color: Colors.white,
            ),
          ),
          height: 160.0,
          width: double.infinity,
          child: pickedLocation != null
              ? Image.network(
                  locationImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
              : locationContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: Icon(Icons.location_on),
              label: Text('My Location'),
            ),
            TextButton.icon(
              onPressed: selectOnMap,
              icon: Icon(Icons.map),
              label: Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }
}
