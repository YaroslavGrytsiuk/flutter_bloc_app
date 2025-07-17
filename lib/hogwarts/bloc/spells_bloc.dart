import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/spell_model.dart';
import '../services/hogwarts_service.dart';

part 'spells_event.dart';
part 'spells_state.dart';

class SpellsBloc extends Bloc<SpellsEvent, SpellsState> {
  final HogwartsService _hogwartsService;

  SpellsBloc({HogwartsService? hogwartsService}) : _hogwartsService = hogwartsService ?? HogwartsService(), super(SpellsInitial()) {
    on<LoadAllSpells>(_onLoadAllSpells);
  }

  Future<void> _onLoadAllSpells(LoadAllSpells event, Emitter<SpellsState> emit) async {
    emit(SpellsLoading());
    try {
      final spells = await _hogwartsService.getAllSpells();
      emit(SpellsLoaded(spells: spells));
    } catch (e) {
      emit(SpellsError(message: e.toString()));
    }
  }
}
