import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app/hogwarts/bloc/spells_bloc.dart';
import 'package:flutter_bloc_app/model/spell_model.dart';

class SpellsPage extends StatelessWidget {
  const SpellsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Spells'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: BlocBuilder<SpellsBloc, SpellsState>(
        builder: (context, state) {
          if (state is SpellsInitial || state is SpellsLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is SpellsError) {
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
          } else if (state is SpellsLoaded) {
            return _buildSpellsList(state.spells);
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }

  Widget _buildSpellsList(List<SpellModel> spells) {
    if (spells.isEmpty) {
      return const Center(child: Text('No spells found', style: TextStyle(fontSize: 16)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: spells.length,
      itemBuilder: (context, index) {
        final spell = spells[index];
        return _buildSpellCard(spell);
      },
    );
  }

  Widget _buildSpellCard(SpellModel spell) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_fix_high, color: Colors.deepPurple, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    spell.name.isEmpty ? 'Unknown Spell' : spell.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                ),
              ],
            ),
            if (spell.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(spell.description, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
