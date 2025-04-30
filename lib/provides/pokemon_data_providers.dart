import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:testapp/models/pokemon.dart';
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
