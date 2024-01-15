import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'LoginPage.dart';
import 'MyAppState.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Notes App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 82, 0, 224)),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
