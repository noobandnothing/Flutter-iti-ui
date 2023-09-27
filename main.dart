import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'favpage.dart';
import 'mainpage.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class Shit extends ChangeNotifier {
  int counter0 = 0;
  int counter1 = 0;
  void increaseCounter0() {
    counter0++;
    notifyListeners();
  }

  void increaseCounter1() {
    counter1++;
    notifyListeners();
  }

  get getC0 => counter0;
  get getC1 => counter1;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const MainPage(),
        '/favPage': (context) => const FavPage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Favourite Provider Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
