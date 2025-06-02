import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testapp/controllers/home_page_controller.dart';
import 'package:testapp/models/page_data.dart';
import 'package:testapp/models/pokemon.dart';
import 'package:testapp/provides/pokemon_data_providers.dart';
import 'package:testapp/widgets/pokemon_card.dart';
import 'package:testapp/widgets/pokemon_list_tile.dart';

final homePageControllerProvider =
StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController(HomePageData.initial());
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late HomePageController _homePageController;
  late HomePageData _homePageData;

  final ScrollController _allPokemonListScrollController = ScrollController();

  late List<String> _favoritePokemons;

  @override
  void initState() {
    _allPokemonListScrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _allPokemonListScrollController.removeListener(_scrollListener);
    _allPokemonListScrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_allPokemonListScrollController.offset >=
        _allPokemonListScrollController.position.maxScrollExtent &&
        !_allPokemonListScrollController.position.outOfRange) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(homePageControllerProvider.notifier);
    _homePageData = ref.watch(homePageControllerProvider);
    _favoritePokemons = ref.watch(favoritePokemonsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon App'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Favorite Section Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "Favorite Pokémon",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Favorite Pokémon List
            _buildFavoriteList(context),

            // All Pokémon Section Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "All Pokémon",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // All Pokémon List
            Expanded(child: _buildAllPokemonList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteList(BuildContext context) {
    if (_favoritePokemons.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text("No Favorite Pokémon"),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _favoritePokemons.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          String pokemonUrl = _favoritePokemons[index];
          return PokemonCard(pokemonUrl: pokemonUrl);
        },
      ),
    );
  }

  Widget _buildAllPokemonList(BuildContext context) {
    return ListView.separated(
      controller: _allPokemonListScrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _homePageData.data?.results?.length ?? 0,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final pokemon = _homePageData.data!.results![index];
        return PokemonListTile(pokemonUrl: pokemon.url!);
      },
    );
  }
}
