import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:testapp/provides/pokemon_data_providers.dart';
import 'package:testapp/widgets/pokemon_stats_Card.dart';

import '../models/pokemon.dart';

class PokemonCard extends ConsumerWidget {
  final String pokemonUrl;
  late FavoritePokemonsProvider _favoritePokemonsProvider;

  PokemonCard({super.key, required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favoritePokemonsProvider = ref.watch(favoritePokemonsProvider.notifier);
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));
    return pokemon.when(
      data: (data) {
        return _card(context, false, data);
      },
      loading: () {
        return _card(context, true, null);
      },
      error: (error, stackTrace) {
        return Text("Error : $error");
      },
    );
  }

  Widget _card(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading,
      ignoreContainers: true,
      child: GestureDetector(
        onTap: () {
          if (!isLoading) {
            showDialog(
              context: context,
              builder: (_) {
                return PokemonStatsCard(pokemonUrl: pokemonUrl);
              },
            );
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pokemon?.name?.toUpperCase() ?? "Pokemon",

                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                  ),
                  Text(
                    "#${pokemon?.id.toString() ?? "0"}",

                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),

              pokemon?.sprites?.frontDefault != null
                  ? Image.network(pokemon!.sprites!.frontDefault!)
                  : SizedBox(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${pokemon?.moves?.length.toString() ?? 0} Moves ",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _favoritePokemonsProvider.removePokemon(pokemonUrl);
                    },
                    child: Icon(Icons.favorite, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
