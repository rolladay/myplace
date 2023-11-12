import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myplace/models/place.dart';
import 'package:myplace/providers/user_place_provider.dart';
import 'package:myplace/widgets/image_input.dart';
import 'package:myplace/widgets/location_input.dart';

class AddNewPlace extends ConsumerStatefulWidget {
  const AddNewPlace({super.key});



  @override
  ConsumerState<AddNewPlace> createState() => _AddNewPlaceState();
}

class _AddNewPlaceState extends ConsumerState<AddNewPlace> {
  final _titleController = TextEditingController();
  File? selectedImage;
  PlaceLocation? selectedLocation;

  void savePlace() {
    final enteredText = _titleController.text;

    if (enteredText.isEmpty || selectedImage == null || selectedLocation == null) {
      return;
      //I can put some error reaction here
    }

    ref.read(userPlaceProvider.notifier).addPlace(
          title: enteredText,
          image: selectedImage!,
          location: selectedLocation!,
        );
    Navigator.of(context).pop();
    print(ref.read(userPlaceProvider));
    print('heelo');
  }

  //내가 쓴 코드...
  void onPickImage(File image) {
    selectedImage = image;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  label: Text(
                    'title',
                  ),
                ),
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 16.0,
              ),
              ImageInput(onPickImage: onPickImage
                  //     (image) {
                  //   selectedImage = image;
                  // },
                  ),
              const SizedBox(
                height: 16.0,
              ),
              LocationInput(
                onSelectLocation: (location) {
                  selectedLocation = location;
                },
              ),
              // 그러니까...
              const SizedBox(
                height: 16.0,
              ),
              SizedBox(
                width: 150.0,
                child: ElevatedButton.icon(
                  onPressed: savePlace,
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Add Place',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
