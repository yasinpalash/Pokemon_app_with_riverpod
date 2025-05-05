import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:testapp/models/pokemon.dart';
import 'package:testapp/widgets/pokemon_stats_Card.dart';

import '../provides/pokemon_data_providers.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonUrl;

  late FavoritePokemonsProvider _favoritePokemonsProvider;
  late List<String> _favoritePokemons;
  PokemonListTile({super.key, required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favoritePokemonsProvider = ref.watch(favoritePokemonsProvider.notifier);
    _favoritePokemons = ref.watch(favoritePokemonsProvider);
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
        onTap: (){
          if(!isLoading){
            showDialog(context: context, builder: (_){
              return PokemonStatsCard(pokemonUrl: pokemonUrl);
            });
          }
        },
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
          onPressed: () {
            if (_favoritePokemons.contains(pokemonUrl)) {
              _favoritePokemonsProvider.removePokemon(pokemonUrl);
            } else {
              _favoritePokemonsProvider.addPokemon(pokemonUrl);
            }
          },
          icon: Icon(
            _favoritePokemons.contains(pokemonUrl)
                ? Icons.favorite
                : Icons.favorite_border,
            color: Colors.red,
          ),
        ),
        subtitle: Text("Has ${pokemon?.moves?.length.toString() ?? 0} Moves "),
      ),
    );
  }
}
