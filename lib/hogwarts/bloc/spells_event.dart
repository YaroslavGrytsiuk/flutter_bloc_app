part of 'spells_bloc.dart';

@immutable
sealed class SpellsEvent {}

class LoadAllSpells extends SpellsEvent {}
