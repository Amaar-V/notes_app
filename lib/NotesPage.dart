import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CreatePage.dart';
import 'MyAppState.dart';


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