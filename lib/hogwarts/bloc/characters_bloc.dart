import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/hogwarts_character_model.dart';
import '../services/hogwarts_service.dart';

part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final HogwartsService _hogwartsService;

  CharactersBloc({HogwartsService? hogwartsService}) : _hogwartsService = hogwartsService ?? HogwartsService(), super(CharactersInitial()) {
    on<LoadAllCharacters>(_onLoadAllCharacters);
    on<LoadHogwartsStudents>(_onLoadHogwartsStudents);
    on<LoadHogwartsStaff>(_onLoadHogwartsStaff);
  }

  Future<void> _onLoadAllCharacters(LoadAllCharacters event, Emitter<CharactersState> emit) async {
    emit(CharactersLoading());
    try {
      final characters = await _hogwartsService.getAllCharacters();
      emit(CharactersLoaded(characters: characters, title: 'All Characters'));
    } catch (e) {
      emit(CharactersError(message: e.toString()));
    }
  }

  Future<void> _onLoadHogwartsStudents(LoadHogwartsStudents event, Emitter<CharactersState> emit) async {
    emit(CharactersLoading());
    try {
      final characters = await _hogwartsService.getHogwartsStudents();
      emit(CharactersLoaded(characters: characters, title: 'Hogwarts Students'));
    } catch (e) {
      emit(CharactersError(message: e.toString()));
    }
  }

  Future<void> _onLoadHogwartsStaff(LoadHogwartsStaff event, Emitter<CharactersState> emit) async {
    emit(CharactersLoading());
    try {
      final characters = await _hogwartsService.getHogwartsStaff();
      emit(CharactersLoaded(characters: characters, title: 'Hogwarts Staff'));
    } catch (e) {
      emit(CharactersError(message: e.toString()));
    }
  }
}
