part of 'picsum_list_bloc.dart';

@immutable
sealed class PicsumListEvent {}

class LoadPicsumList extends PicsumListEvent {}

class LoadMorePicsumList extends PicsumListEvent {}

class RefreshPicsumList extends PicsumListEvent {}
