part of 'picsum_list_bloc.dart';

@immutable
sealed class PicsumListState {}

final class PicsumListInitial extends PicsumListState {}

final class PicsumListLoading extends PicsumListState {}

final class PicsumListLoaded extends PicsumListState {
  final List<PicModel> pictures;
  final int currentPage;
  final bool hasMorePages;
  final bool isLoadingMore;

  PicsumListLoaded({required this.pictures, required this.currentPage, this.hasMorePages = true, this.isLoadingMore = false});

  PicsumListLoaded copyWith({List<PicModel>? pictures, int? currentPage, bool? hasMorePages, bool? isLoadingMore}) {
    return PicsumListLoaded(
      pictures: pictures ?? this.pictures,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

final class PicsumListError extends PicsumListState {
  final String message;

  PicsumListError({required this.message});
}
