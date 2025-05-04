import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:testapp/models/pokemon.dart';

import '../provides/pokemon_data_providers.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonUrl;
  const PokemonListTile({super.key, required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonData = ref.watch(pokemonDataProvider(pokemonUrl));

    return pokemonData.when(
      data: (data) {
        return _tileUI(context, false, data);
      },
      error: (error, stackTrace) {
        return const Center(child: Text("Error"));
      },
      loading: () {
        return _tileUI(context, true, null);
      },
    );
  }

  Widget _tileUI(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListTile(
        leading:
            pokemon != null
                ? CircleAvatar(
                  backgroundImage: NetworkImage(pokemon.sprites!.frontDefault!),
                )
                : const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.pets),
                ),
        title: Text(
          pokemon != null ? pokemon.name!.toUpperCase() : "Loading...",
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(Icons.favorite_border),
        ),
        subtitle: Text("Has ${pokemon?.moves?.length.toString() ?? 0} Moves "),
      ),
    );
  }
}
