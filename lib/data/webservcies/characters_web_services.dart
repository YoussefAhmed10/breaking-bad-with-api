// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

class CharactersWebServices {
  late Dio dio;

  CharactersWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: 'https://www.breakingbadapi.com/api/',

      receiveDataWhenStatusError: true,
      connectTimeout: 20 * 1000, // 60 seconds,
      receiveTimeout: 20 * 1000,
    );

    dio = Dio(options);
  }

  Future<List<dynamic>> getAllCharacters() async {
    try {
      Response response = await dio.get('characters');
      return response.data;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getQuotesOfCharacter(String charName) async {
    try {
      Response response = await dio.get(
        'quote',
        queryParameters: {
          'author': charName,
        },
      );
      return response.data;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
