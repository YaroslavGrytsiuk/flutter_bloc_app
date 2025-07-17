import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app/hogwarts/bloc/characters_bloc.dart';
import 'package:flutter_bloc_app/model/hogwarts_character_model.dart';
import 'package:flutter_bloc_app/hogwarts/character_detail_page.dart';

class CharactersPage extends StatelessWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CharactersBloc, CharactersState>(
          builder: (context, state) {
            if (state is CharactersLoaded) {
              return Text(state.title);
            }
            return const Text('Characters');
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<CharactersBloc, CharactersState>(
        builder: (context, state) {
          if (state is CharactersInitial || state is CharactersLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is CharactersError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}', style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Go Back')),
                ],
              ),
            );
          } else if (state is CharactersLoaded) {
            return _buildCharactersList(state.characters);
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }

  Widget _buildCharactersList(List<HogwartsCharacterModel> characters) {
    if (characters.isEmpty) {
      return const Center(child: Text('No characters found', style: TextStyle(fontSize: 16)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return _buildCharacterCard(context, character);
      },
    );
  }

  Widget _buildCharacterCard(BuildContext context, HogwartsCharacterModel character) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CharacterDetailPage(characterId: character.id)));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Character Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey.shade200,
                  child:
                      character.image.isNotEmpty
                          ? Image.network(
                            character.image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.person, size: 40);
                            },
                          )
                          : const Icon(Icons.person, size: 40),
                ),
              ),
              const SizedBox(width: 16),
              // Character Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name.isEmpty ? 'Unknown' : character.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    if (character.house.isNotEmpty) _buildInfoRow('House', character.house),
                    if (character.actor.isNotEmpty) _buildInfoRow('Actor', character.actor),
                    if (character.species.isNotEmpty) _buildInfoRow('Species', character.species),
                    if (character.patronus.isNotEmpty) _buildInfoRow('Patronus', character.patronus),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (character.hogwartsStudent) _buildChip('Student', Colors.blue),
                        if (character.hogwartsStaff) _buildChip('Staff', Colors.green),
                        if (character.wizard) _buildChip('Wizard', Colors.purple),
                        if (character.alive) _buildChip('Alive', Colors.orange) else _buildChip('Deceased', Colors.red),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text('$label: $value', style: const TextStyle(fontSize: 14, color: Colors.grey)),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    );
  }
}
