import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app/counter/bloc/counter_bloc.dart';
import 'package:flutter_bloc_app/counter/bloc/counter_event.dart';
import 'package:flutter_bloc_app/counter/bloc/counter_state.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key, required this.title});
  final String title;

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    final CounterBloc counterBloc = context.read<CounterBloc>();

    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Center(
        child: BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('You have pushed the button this many times:'),
                Text('${state.count}', style: Theme.of(context).textTheme.headlineMedium),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Column(
        spacing: 14.0,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: const Key('counterPage_increment_floatingActionButton'),
            onPressed: () => counterBloc.add(CounterIncrementEvent()),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            heroTag: const Key('counterPage_decrement_floatingActionButton'),
            onPressed: () => counterBloc.add(CounterDecrementEvent()),
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          FloatingActionButton(
            heroTag: const Key('counterPage_reset_floatingActionButton'),
            onPressed: () => counterBloc.add(CounterResetEvent()),
            tooltip: 'Reset',
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
