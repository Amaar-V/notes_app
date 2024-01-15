import 'package:flutter/material.dart';
import 'package:notes_app/CreatePage.dart';
import 'package:notes_app/NotesPage.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';
import 'MyAppState.dart';

var prefs;
void main() async {
  prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

final String? user = prefs.getString('userName');
final GoRouter _router = GoRouter(
  initialLocation: user!=null?(user==''?'/':'/notes'):'/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'notes',
          builder: (BuildContext context, GoRouterState state) {
            return const NotesPage();
          },
        ),
        GoRoute(
          path: 'create',
          builder: (BuildContext context, GoRouterState state) {
            return const CreatePage();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp.router(
        routerConfig: _router,
        title: 'Notes App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 82, 0, 224)),
        ),
      ),
    );
  }
}
