part of 'character_detail_bloc.dart';

@immutable
sealed class CharacterDetailState {}

final class CharacterDetailInitial extends CharacterDetailState {}

final class CharacterDetailLoading extends CharacterDetailState {}

final class CharacterDetailLoaded extends CharacterDetailState {
  final HogwartsCharacterModel character;

  CharacterDetailLoaded({required this.character});
}

final class CharacterDetailError extends CharacterDetailState {
  final String message;

  CharacterDetailError({required this.message});
}
