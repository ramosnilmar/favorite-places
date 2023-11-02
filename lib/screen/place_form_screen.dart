import 'dart:io';

import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/providers/grate_places.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceFormScreen extends ConsumerStatefulWidget {
  const PlaceFormScreen({super.key});

  @override
  ConsumerState<PlaceFormScreen> createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends ConsumerState<PlaceFormScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _submitForm() {
    final enteredTitle = _titleController.text;

    if (enteredTitle.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null) {
      return;
    }

    ref.read(gratePlacesProvider.notifier).addPlace(
          enteredTitle,
          _selectedImage!,
          _selectedLocation!,
        );

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new place'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Title'),
                    controller: _titleController,
                  ),
                  const SizedBox(height: 10),
                  ImageInput(
                    onPickImage: (image) {
                      _selectedImage = image;
                    },
                  ),
                ],
              ),
            ),
            LocationInput(
              onSelectPlace: (location) {
                _selectedLocation = location;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Add Place'),
            )
          ],
        ),
      ),
    );
  }
}
