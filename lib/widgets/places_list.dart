import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/providers/grate_places.dart';
import 'package:favorite_places/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PLacesList extends ConsumerWidget {
  const PLacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: places.isEmpty
          ? const Center(
              child: Text('No places yet'),
            )
          : ListView.builder(
              itemCount: places.length,
              itemBuilder: (ctx, i) => Dismissible(
                key: ValueKey(places[i].id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) {
                  return showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Remove?'),
                      content: const Text('Are you sure?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('No'),
                          onPressed: () => Navigator.of(ctx).pop(false),
                        ),
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () => Navigator.of(ctx).pop(true),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (_) => ref
                    .read(gratePlacesProvider.notifier)
                    .removePlace(places[i].id),
                background: Container(
                  color: Theme.of(context).colorScheme.error,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                child: ListTile(
                  leading: Hero(
                    tag: places[i].id,
                    child: CircleAvatar(
                      backgroundImage: FileImage(places[i].image),
                    ),
                  ),
                  title: Text(places[i].title),
                  subtitle: Text(places[i].location.address!),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.placeDetails,
                      arguments: places[i],
                    );
                  },
                ),
              ),
            ),
    );
  }
}
