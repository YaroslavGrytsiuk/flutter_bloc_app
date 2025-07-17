import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app/counter/bloc/counter_bloc.dart';
import 'package:flutter_bloc_app/counter/counter_page.dart';
import 'package:flutter_bloc_app/picsum/bloc/picsum_list_bloc.dart';
import 'package:flutter_bloc_app/picsum/picsum_list_page.dart';
import 'package:flutter_bloc_app/hogwarts/hogwarts_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PicsumListBloc()..add(LoadPicsumList()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter BLoC App'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Flutter BLoC Demo', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MultiBlocProvider(
                            providers: [BlocProvider(create: (context) => CounterBloc())],
                            child: const CounterPage(title: 'Counter Page'),
                          ),
                    ),
                  );
                },
                child: const Text('Counter Demo'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PicsumListPage()));
                },
                child: const Text('Picsum Photos'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HogwartsPage()));
                },
                icon: const Icon(Icons.school),
                label: const Text('Go to Hogwarts'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
