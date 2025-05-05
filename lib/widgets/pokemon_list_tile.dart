
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
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          onTap: () {
            if (!isLoading) {
              showDialog(
                context: context,
                builder: (_) => PokemonStatsCard(pokemonUrl: pokemonUrl),
              );
            }
          },
          leading: Hero(
            tag: pokemonUrl,
            child: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.blue.shade50,
              backgroundImage: pokemon?.sprites?.frontDefault != null
                  ? NetworkImage(pokemon!.sprites!.frontDefault!)
                  : null,
              child: pokemon?.sprites?.frontDefault == null
                  ? const Icon(Icons.pets, color: Colors.grey)
                  : null,
            ),
          ),
          title: Text(
            pokemon?.name?.toUpperCase() ?? "LOADING...",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            "Has ${pokemon?.moves?.length ?? 0} Moves",
            style: const TextStyle(fontSize: 13, color: Colors.black54),
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
              color: Colors.redAccent,
            ),
          ),
        ),
      ),
    );
  }
}