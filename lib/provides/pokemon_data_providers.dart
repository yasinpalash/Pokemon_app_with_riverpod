import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:testapp/models/pokemon.dart';
import 'package:testapp/services/database_service.dart';
import 'package:testapp/services/http_service.dart';

final pokemonDataProvider = FutureProvider.family<Pokemon?, String>((
  ref,
  url,
) async {
  HTTPService _httpService = GetIt.instance.get<HTTPService>();
  Response? response = await _httpService.get(url);
  print("Response from API: $url");
  print(response?.data);
  if (response != null && response.data != null) {
    return Pokemon.fromJson(response.data);
  }

  return null;
});

final favoritePokemonsProvider =
    StateNotifierProvider<FavoritePokemonsProvider, List<String>>((ref) {
      return FavoritePokemonsProvider([]);
    });

class FavoritePokemonsProvider extends StateNotifier<List<String>> {
  final DatabaseService _databaseService =
      GetIt.instance.get<DatabaseService>();

  String FAVORITE_POKEMONS_KEY = "favorite_pokemons";
  FavoritePokemonsProvider(super._state) {
    _setup();
  }
  Future<void> _setup() async {

    List<String>?result =
        await _databaseService.getList(FAVORITE_POKEMONS_KEY);

    state=result??[];

  }

  void addPokemon(String url) {
    state = [...state, url];
    _databaseService.saveList(FAVORITE_POKEMONS_KEY, state);
  }

  void removePokemon(String url) {
    state = state.where((element) => element != url).toList();
    _databaseService.saveList(FAVORITE_POKEMONS_KEY, state);
  }
}
