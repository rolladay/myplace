import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:myplace/providers/user_place_provider.dart';
import 'package:myplace/screens/place_add.dart';
import '../models/place.dart';
import '../widgets/place_list.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() {
    return _PlaceScreenState();
  }
}

// final List<Place> places = [];
class _PlaceScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> placesFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    placesFuture = ref.read(userPlaceProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlaceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Place'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddNewPlace(),
              ),
            ),
          ),
        ],
      ),
      body: userPlaces.isEmpty
          ? const Center(
              child: Text(
                'No Items',
                style: TextStyle(color: Colors.white),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: placesFuture,
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? const Center(child: CircularProgressIndicator())
                        : PlaceList(places: userPlaces),
              ),
            ),
    );
  }
}
