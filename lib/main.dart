import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surrealdb/surrealdb.dart';

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
        home: LoginPage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var userName = '';
  final client = SurrealDB('ws://localhost:8000/rpc')..connect();
  var notes;

  MyAppState() {
    main();
  }

  void main() async {
    await client.wait();
    // use test namespace and test database
    // TODO: create surreal ql file
    await client.use('dev', 'main');
    // authenticate with user and pass
    await client.signin(user: 'root', pass: 'root');
  }

  void add(String note) async {
    final data = {'name': userName, 'note': note};
    await client.create('notes', data);
    notifyListeners();
  }

  void get() async {
    notes = await client.query('SELECT * FROM notes WHERE name==\'$userName\'');
    notifyListeners();
  }

  String name() {
    return userName;
  }

  void login(String name) {
    userName = name;
  }

  void logout() {
    userName = '';
  }

  void search(String query) {}
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();
    var appState = context.watch<MyAppState>();

    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      myController.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(children: [
          Expanded(
            child: TextFormField(
              controller: myController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter name',
              ),
            ),
          ),
          ElevatedButton(
            child: const Text('Login'),
            onPressed: () {
              appState.login(myController.text);
              myController.clear();
              print('${appState.name()} logged in');
              appState.get();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotesPage()),
              );
            },
          ),
          Spacer(),
        ]),
      ),
    );
  }
}

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Center(
        child: Column(children: [
          const SearchBar(
            hintText: 'Search...',
          ),
          const Spacer(),
          Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (var obj in appState.notes[0]['result'])
                  ListTile(
                    title: Text(obj['note']),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            child: const Text('New note'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreatePage()),
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              print('${appState.name()} logged out');
              appState.logout();
              Navigator.pop(context);
            },
            child: const Text('Logout'),
          ),
          Spacer(),
        ]),
      ),
    );
  }
}

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();
    var appState = context.watch<MyAppState>();

    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      myController.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: Center(
        child: Column(children: [
          Expanded(
            child: TextFormField(
              controller: myController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter note',
              ),
            ),
          ),
          ElevatedButton(
            child: const Text('Create'),
            onPressed: () {
              appState.add(myController.text);
              appState.get();
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            child: const Text('Discard'),
            onPressed: () {
              appState.get();
              Navigator.pop(context);
            },
          ),
          const Spacer(),
        ]),
      ),
    );
  }
}
