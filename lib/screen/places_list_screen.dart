import 'package:favorite_places/providers/grate_places.dart';
import 'package:favorite_places/utils/app_routes.dart';
import 'package:favorite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PacesListScreen extends ConsumerStatefulWidget {
  const PacesListScreen({super.key});

  @override
  ConsumerState<PacesListScreen> createState() => _PacesListScreenState();
}

class _PacesListScreenState extends ConsumerState<PacesListScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(gratePlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final gratePlaces = ref.watch(gratePlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Great Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.placeForm);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _placesFuture,
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : PLacesList(
                    places: gratePlaces,
                  ),
      ),
    );
  }
}
