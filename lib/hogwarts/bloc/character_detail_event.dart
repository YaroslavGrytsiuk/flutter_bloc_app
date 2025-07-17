part of 'character_detail_bloc.dart';

@immutable
sealed class CharacterDetailEvent {}

class LoadCharacterDetail extends CharacterDetailEvent {
  final String characterId;

  LoadCharacterDetail({required this.characterId});
}
