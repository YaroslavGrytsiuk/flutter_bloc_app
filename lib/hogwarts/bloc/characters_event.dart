part of 'characters_bloc.dart';

@immutable
sealed class CharactersEvent {}

class LoadAllCharacters extends CharactersEvent {}

class LoadHogwartsStudents extends CharactersEvent {}

class LoadHogwartsStaff extends CharactersEvent {}
