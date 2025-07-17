import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app/hogwarts/bloc/characters_bloc.dart';
import 'package:flutter_bloc_app/hogwarts/bloc/spells_bloc.dart';
import 'package:flutter_bloc_app/hogwarts/characters_page.dart';
import 'package:flutter_bloc_app/hogwarts/spells_page.dart';

class HogwartsPage extends StatelessWidget {
  const HogwartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hogwarts'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade100, Colors.deepPurple.shade300],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.school, size: 80, color: Colors.deepPurple),
                const SizedBox(height: 20),
                const Text('Welcome to Hogwarts', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                const SizedBox(height: 40),
                _buildHogwartsButton(context, 'All Characters', Icons.people, () => _navigateToCharacters(context, CharacterType.all)),
                const SizedBox(height: 16),
                _buildHogwartsButton(
                  context,
                  'Hogwarts Students',
                  Icons.school,
                  () => _navigateToCharacters(context, CharacterType.students),
                ),
                const SizedBox(height: 16),
                _buildHogwartsButton(context, 'Hogwarts Staff', Icons.work, () => _navigateToCharacters(context, CharacterType.staff)),
                const SizedBox(height: 16),
                _buildHogwartsButton(context, 'All Spells', Icons.auto_fix_high, () => _navigateToSpells(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHogwartsButton(BuildContext context, String text, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 250,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple.shade50,
          foregroundColor: Colors.deepPurple.shade700,
          elevation: 4,
          shadowColor: Colors.deepPurple.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void _navigateToCharacters(BuildContext context, CharacterType type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BlocProvider(create: (context) => CharactersBloc()..add(_getCharacterEvent(type)), child: const CharactersPage()),
      ),
    );
  }

  void _navigateToSpells(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(create: (context) => SpellsBloc()..add(LoadAllSpells()), child: const SpellsPage()),
      ),
    );
  }

  CharactersEvent _getCharacterEvent(CharacterType type) {
    switch (type) {
      case CharacterType.all:
        return LoadAllCharacters();
      case CharacterType.students:
        return LoadHogwartsStudents();
      case CharacterType.staff:
        return LoadHogwartsStaff();
    }
  }
}

enum CharacterType { all, students, staff }
