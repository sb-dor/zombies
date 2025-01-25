import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:zombies/assets.dart';

import 'zombies_game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final game = ZombieGame();
  runApp(MyApp(game: game,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,required this.game});

  final ZombieGame game;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(game: game),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key,required this.game});

  final ZombieGame game;

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: game,
    );
  }
}
