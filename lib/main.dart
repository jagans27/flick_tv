import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/animation_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AnimationProvider())],
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Gilroy'),
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
