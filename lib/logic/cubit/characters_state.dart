import '../../data/models/char_qoutes.dart';
import '../../data/models/characters_model.dart';

abstract class CharactersState {}

class CharactersInitial extends CharactersState {}

class CharactersLoading extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final List<Character> chracters;

  CharactersLoaded(this.chracters);
}

class CharactersError extends CharactersState {
  final String error;

  CharactersError(this.error);
}

class CharacterQuotesLoaded extends CharactersState {
  final List<Quotes> quote;

  CharacterQuotesLoaded(this.quote);
}

class CharacterQuotesError extends CharactersState {
  CharacterQuotesError();
}
