import 'package:flutter/material.dart';

import '../models/place.dart';
import 'map.dart';

class MyPlaceDetailScreen extends StatelessWidget {
  const MyPlaceDetailScreen({super.key, required this.place});

  final Place place;

  String get locationImage {
    final lat = place.location.latitude;
    final lng = place.location.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:black%7Clabel:A%7C$lat,$lng&key=AIzaSyDtW8E5nQcMna_abqEoX9_QsLpeGxB0d4g';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
      body: Stack(
        children: [
          Image.file(
            //이 이미지파일이 스택의 위드 하이트 를 결정하고 있지?
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 500.0,
          ),
          Positioned(
            bottom: 0,
            //이 자식인 컬럼이 이 스택의 바닥에서 시작한다
            left: 0,
            right: 0,
            //이렇게 하면 어떻게 되갔어?

            child: Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MapScreen(
                        location: place.location,
                        isSelecting: false,
                      ),
                    ),
                  ),
                  child: CircleAvatar(
                    foregroundImage: NetworkImage(locationImage),
                    radius: 50,
                  ),
                ),
                Container(
                  height: 60,
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    place.location.address,
                    style: const TextStyle(color: Colors.limeAccent),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
