


import 'package:dio/dio.dart';

class HTTPService{
  HTTPService();

  final _dio=Dio();


  Future<Response?> get(String endpoint)async {
    try{
      Response response=await _dio.get(endpoint);

      return response;

    }catch (e){
      print(e);
    }

    return null;
  }
}