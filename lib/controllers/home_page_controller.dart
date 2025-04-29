import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:testapp/models/page_data.dart';
import 'package:testapp/models/pokemon.dart';
import 'package:testapp/services/http_service.dart';

class HomePageController extends StateNotifier<HomePageData>{

  final GetIt _getIt= GetIt.instance;

  late HTTPService _httpServer;

  HomePageController(
    super.state,
      ){
    _httpServer=_getIt.get<HTTPService>();
    _setup();
  }

  Future<void> _setup()async{
    loadData();
  }

  Future<void> loadData()async{
    if(state.data==null){
     Response? response=await _httpServer.get("https://pokeapi.co/api/v2/pokemon?limit=20&offset=0");
     print(response?.data);
     if(response !=null && response.data !=null){
      PokemonListData data=PokemonListData.fromJson(response.data);
      state=state.copyWith(data: data);

     }
    }else{

    }
  }



}


