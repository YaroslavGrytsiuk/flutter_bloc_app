import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/picsum_list_bloc.dart';
import '../model/pic_model.dart';

class PicsumListPage extends StatelessWidget {
  const PicsumListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the top-level PicsumListBloc provided in main.dart
    return const PicsumListView();
  }
}

class PicsumListView extends StatelessWidget {
  const PicsumListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picsum Photos'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: BlocBuilder<PicsumListBloc, PicsumListState>(
        builder: (context, state) {
          if (state is PicsumListInitial || state is PicsumListLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is PicsumListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text('Error loading pictures', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(state.message, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PicsumListBloc>().add(LoadPicsumList());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is PicsumListLoaded) {
            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      final bloc = context.read<PicsumListBloc>();
                      bloc.add(RefreshPicsumList());
                      await bloc.stream.firstWhere((s) => s is PicsumListLoaded || s is PicsumListError);
                    },
                    child: ListView.builder(
                      itemCount: state.pictures.length + (state.isLoadingMore ? 1 : 0) + (!state.hasMorePages ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < state.pictures.length) {
                          final picture = state.pictures[index];
                          _paginateList(index, context);
                          return PictureListTile(picture: picture);
                        } else if (state.isLoadingMore) {
                          // Show loader at the bottom during pagination
                          return const Padding(padding: EdgeInsets.all(16.0), child: Center(child: CircularProgressIndicator.adaptive()));
                        } else if (!state.hasMorePages) {
                          // Show "No more items" when reached the end
                          return Container(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              'No more photos',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w500),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _paginateList(int index, BuildContext context) {
    final bloc = BlocProvider.of<PicsumListBloc>(context);
    if (bloc.state is PicsumListLoaded) {
      final state = bloc.state as PicsumListLoaded;
      if (index == state.pictures.length - 5 && state.hasMorePages && !state.isLoadingMore) {
        bloc.add(LoadMorePicsumList());
      }
    }
  }
}

class PictureListTile extends StatelessWidget {
  final PicModel picture;

  const PictureListTile({super.key, required this.picture});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            picture.downloadUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
                child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.error, color: Colors.red),
              );
            },
          ),
        ),
        title: Text('Photo by ${picture.author}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [const SizedBox(height: 4), Text('ID: ${picture.id}'), Text('Size: ${picture.width} x ${picture.height}')],
        ),
        onTap: () => _onListTileTap(context),
      ),
    );
  }

  void _onListTileTap(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          picture.downloadUrl,
                          width: MediaQuery.of(context).size.width * 0.8,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
                              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.error, color: Colors.red),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Photo by ${picture.author}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 8),
                    Text('ID: ${picture.id}', style: const TextStyle(fontSize: 16)),
                    Text('Size: ${picture.width} x ${picture.height}', style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
