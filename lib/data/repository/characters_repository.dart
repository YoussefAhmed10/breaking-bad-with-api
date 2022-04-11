// // import 'package:blocandapi/data/models/characters_model.dart';
// import 'package:blocandapi/data/models/characters_model.dart';
// import 'package:blocandapi/data/webservcies/characters_web_services.dart';

// class CharactersRepository {
//   final CharactersWebServices charactersWebServices;

//   CharactersRepository(this.charactersWebServices);

//   Future<List<Character>> getAllCharacters() async {
//     final characters = await charactersWebServices.getAllCharacters();
//     return characters
//         .map((character) => Character.fromJson(character))
//         .toList();
//   }
// }
