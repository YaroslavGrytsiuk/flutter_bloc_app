import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app/hogwarts/bloc/character_detail_bloc.dart';
import 'package:flutter_bloc_app/model/hogwarts_character_model.dart';

class CharacterDetailPage extends StatelessWidget {
  final String characterId;

  const CharacterDetailPage({super.key, required this.characterId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CharacterDetailBloc()..add(LoadCharacterDetail(characterId: characterId)),
      child: const CharacterDetailView(),
    );
  }
}

class CharacterDetailView extends StatelessWidget {
  const CharacterDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CharacterDetailBloc, CharacterDetailState>(
          builder: (context, state) {
            if (state is CharacterDetailLoaded) {
              return Text(state.character.name.isEmpty ? 'Character Details' : state.character.name);
            }
            return const Text('Character Details');
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<CharacterDetailBloc, CharacterDetailState>(
        builder: (context, state) {
          if (state is CharacterDetailInitial || state is CharacterDetailLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is CharacterDetailError) {
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
          } else if (state is CharacterDetailLoaded) {
            return _buildCharacterDetails(state.character);
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }

  Widget _buildCharacterDetails(HogwartsCharacterModel character) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Character Image and Basic Info
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Character Image
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey.shade200,
                        child:
                            character.image.isNotEmpty
                                ? Image.network(
                                  character.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.person, size: 80);
                                  },
                                )
                                : const Icon(Icons.person, size: 80),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Character Name
                  Text(
                    character.name.isEmpty ? 'Unknown Character' : character.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Status Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
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
          ),

          const SizedBox(height: 16),

          // Personal Information
          _buildInfoSection('Personal Information', [
            if (character.actor.isNotEmpty) _buildInfoRow('Actor', character.actor),
            if (character.species.isNotEmpty) _buildInfoRow('Species', character.species),
            if (character.gender.isNotEmpty) _buildInfoRow('Gender', character.gender),
            if (character.dateOfBirth != null) _buildInfoRow('Date of Birth', character.dateOfBirth!),
            if (character.yearOfBirth != null) _buildInfoRow('Year of Birth', character.yearOfBirth.toString()),
            if (character.ancestry.isNotEmpty) _buildInfoRow('Ancestry', character.ancestry),
          ]),

          const SizedBox(height: 16),

          // Hogwarts Information
          _buildInfoSection('Hogwarts Information', [
            if (character.house.isNotEmpty) _buildInfoRow('House', character.house),
            if (character.patronus.isNotEmpty) _buildInfoRow('Patronus', character.patronus),
          ]),

          const SizedBox(height: 16),

          // Physical Description
          _buildInfoSection('Physical Description', [
            if (character.eyeColour.isNotEmpty) _buildInfoRow('Eye Colour', character.eyeColour),
            if (character.hairColour.isNotEmpty) _buildInfoRow('Hair Colour', character.hairColour),
          ]),

          const SizedBox(height: 16),

          // Wand Information
          if (character.wand.wood.isNotEmpty || character.wand.core.isNotEmpty || character.wand.length != null)
            _buildInfoSection('Wand Information', [
              if (character.wand.wood.isNotEmpty) _buildInfoRow('Wood', character.wand.wood),
              if (character.wand.core.isNotEmpty) _buildInfoRow('Core', character.wand.core),
              if (character.wand.length != null) _buildInfoRow('Length', '${character.wand.length}" inches'),
            ]),

          const SizedBox(height: 16),

          // Alternate Names
          if (character.alternateNames.isNotEmpty)
            _buildInfoSection('Alternate Names', [_buildInfoRow('Names', character.alternateNames.join(', '))]),

          const SizedBox(height: 16),

          // Alternate Actors
          if (character.alternateActors.isNotEmpty)
            _buildInfoSection('Alternate Actors', [_buildInfoRow('Actors', character.alternateActors.join(', '))]),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text('$label:', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
    );
  }
}
