part of 'spells_bloc.dart';

@immutable
sealed class SpellsState {}

final class SpellsInitial extends SpellsState {}

final class SpellsLoading extends SpellsState {}

final class SpellsLoaded extends SpellsState {
  final List<SpellModel> spells;

  SpellsLoaded({required this.spells});
}

final class SpellsError extends SpellsState {
  final String message;

  SpellsError({required this.message});
}
