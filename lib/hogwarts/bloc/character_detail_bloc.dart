import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/hogwarts_character_model.dart';
import '../services/hogwarts_service.dart';

part 'character_detail_event.dart';
part 'character_detail_state.dart';

class CharacterDetailBloc extends Bloc<CharacterDetailEvent, CharacterDetailState> {
  final HogwartsService _hogwartsService;

  CharacterDetailBloc({HogwartsService? hogwartsService})
    : _hogwartsService = hogwartsService ?? HogwartsService(),
      super(CharacterDetailInitial()) {
    on<LoadCharacterDetail>(_onLoadCharacterDetail);
  }

  Future<void> _onLoadCharacterDetail(LoadCharacterDetail event, Emitter<CharacterDetailState> emit) async {
    emit(CharacterDetailLoading());
    try {
      final character = await _hogwartsService.getCharacterById(event.characterId);
      emit(CharacterDetailLoaded(character: character));
    } catch (e) {
      emit(CharacterDetailError(message: e.toString()));
    }
  }
}
