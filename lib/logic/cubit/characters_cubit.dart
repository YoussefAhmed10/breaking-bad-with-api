// ignore_for_file: avoid_print

import 'package:blocandapi/data/models/char_qoutes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:blocandapi/data/models/characters_model.dart';
import 'package:blocandapi/data/webservcies/characters_web_services.dart';

import 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  CharactersCubit(this.charactersWebServices) : super(CharactersInitial());

  final CharactersWebServices charactersWebServices;

  Future<List<Character>> getAllCharacters() async {
    final characters = await charactersWebServices.getAllCharacters();
    return characters
        .map((character) => Character.fromJson(character))
        .toList();
  }

  List<Character> characters = [];

  List<Character> getAllCharacter() {
    emit(CharactersLoading());
    getAllCharacters().then((characters) {
      emit(CharactersLoaded(characters));
      this.characters = characters;
    }).catchError((error) {
      print(error.toString());
      emit(CharactersError(error.toString()));
    });

    return characters;
  }

  Future<List<Quotes>> getQuotesOfCharacter(String charName) async {
    final characterquotes =
        await charactersWebServices.getQuotesOfCharacter(charName);
    return characterquotes.map((quote) => Quotes.fromJson(quote)).toList();
  }

  List<Quotes> quote = [];

  List<Quotes> getQuotes(String charName) {
    getQuotesOfCharacter(charName).then((quote) {
      emit(CharacterQuotesLoaded(quote));
      this.quote = quote;
    }).catchError((error) {
      print(error.toString());
    });

    return quote;
  }
}
