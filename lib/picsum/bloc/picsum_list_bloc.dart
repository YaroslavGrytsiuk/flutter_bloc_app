import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/pic_model.dart';
import '../services/picsum_service.dart';

part 'picsum_list_event.dart';
part 'picsum_list_state.dart';

class PicsumListBloc extends Bloc<PicsumListEvent, PicsumListState> {
  final PicsumService _picsumService;

  PicsumListBloc({PicsumService? picsumService}) : _picsumService = picsumService ?? PicsumService(), super(PicsumListInitial()) {
    on<LoadPicsumList>(_onLoadPicsumList);
    on<LoadMorePicsumList>(_onLoadMorePicsumList);
    on<RefreshPicsumList>(_onRefreshPicsumList);
  }

  Future<void> _onLoadPicsumList(LoadPicsumList event, Emitter<PicsumListState> emit) async {
    emit(PicsumListLoading());
    try {
      final pictures = await _picsumService.getPictures(page: 1);
      emit(PicsumListLoaded(pictures: pictures, currentPage: 1, hasMorePages: pictures.length >= 20));
    } catch (e) {
      emit(PicsumListError(message: e.toString()));
    }
  }

  Future<void> _onLoadMorePicsumList(LoadMorePicsumList event, Emitter<PicsumListState> emit) async {
    final currentState = state;
    if (currentState is PicsumListLoaded && currentState.hasMorePages && !currentState.isLoadingMore) {
      // Set loading state
      emit(currentState.copyWith(isLoadingMore: true));

      try {
        final nextPage = currentState.currentPage + 1;
        final newPictures = await _picsumService.getPictures(page: nextPage);

        final allPictures = [...currentState.pictures, ...newPictures];

        emit(
          currentState.copyWith(pictures: allPictures, currentPage: nextPage, hasMorePages: allPictures.length < 80, isLoadingMore: false),
        );
      } catch (e) {
        emit(PicsumListError(message: e.toString()));
      }
    }
  }

  Future<void> _onRefreshPicsumList(RefreshPicsumList event, Emitter<PicsumListState> emit) async {
    try {
      final pictures = await _picsumService.getPictures(page: 1);
      emit(PicsumListLoaded(pictures: pictures, currentPage: 1, hasMorePages: pictures.length >= 20));
    } catch (e) {
      emit(PicsumListError(message: e.toString()));
    }
  }
}
