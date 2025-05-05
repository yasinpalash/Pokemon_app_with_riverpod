


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provides/pokemon_data_providers.dart';

class PokemonStatsCard extends ConsumerWidget {
  final String pokemonUrl;

  const PokemonStatsCard({super.key, required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));
    return AlertDialog(
      title: Text("Pokemon Stats"),
      content: pokemon.when(data: (data) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Name: ${data?.name}"),
            Text("Height: ${data?.height}"),
            Text("Weight: ${data?.weight}"),
            Text(
                "Abilities: ${data?.abilities?.map((e) => e.ability?.name).join(
                    ", ")}"),
          ],
        );
      }, error: (error, stackTrace) {
        return const Center(child: Text("Error"));
      }, loading: () {
        return const Center(child: CircularProgressIndicator());
      }
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
      ],
    );
  }

}