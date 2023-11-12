import 'package:flutter/material.dart';
import '../models/place.dart';
import '../screens/place_detail.dart';

class PlaceList extends StatelessWidget {
  const PlaceList({
    super.key,
    required this.places,
  });

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 26.0,
                backgroundImage: FileImage(places[index].image),
                //백그라운드이미지는 위젯이 아닌, 이미지 프로바이더를 받기 때문에
              ),
            ),
            title: Text(
              places[index].name,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(places[index].location.address, style: TextStyle(color: Colors.limeAccent),),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MyPlaceDetailScreen(
                  place: places[index],
                ),
              ),
            ),
          );
        });
  }
}
