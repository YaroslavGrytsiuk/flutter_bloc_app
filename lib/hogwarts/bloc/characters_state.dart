part of 'characters_bloc.dart';

@immutable
sealed class CharactersState {}

final class CharactersInitial extends CharactersState {}

final class CharactersLoading extends CharactersState {}

final class CharactersLoaded extends CharactersState {
  final List<HogwartsCharacterModel> characters;
  final String title;

  CharactersLoaded({required this.characters, required this.title});
}

final class CharactersError extends CharactersState {
  final String message;

  CharactersError({required this.message});
}
