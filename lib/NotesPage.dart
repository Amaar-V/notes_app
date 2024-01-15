import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'MyAppState.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();
    var appState = context.watch<MyAppState>();

    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      myController.dispose();
    }

    final notes = appState.notes;
    if (notes != null && notes[0]['result'].runtimeType != String) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
        ),
        body: Center(
          child: Column(children: [
            Row(
              children: [
                SearchBar(
                  controller: myController,
                  hintText: 'Search...',
                  leading: const Icon(Icons.search),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (myController.text != '') {
                      appState.search(myController.text);
                    }
                  },
                  child: const Icon(Icons.search),
                )
              ],
            ),
            const Spacer(),
            Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (var obj in notes[0]['result'])
                    Card(
                      child: Center(child: Text(obj['note'])),
                    ),
                ],
              ),
            ),
            ElevatedButton(
              child: const Text('New note'),
              onPressed: () {
                context.go('/create');
              },
            ),
            ElevatedButton(
              onPressed: () {
                //print('${appState.name()} logged out');
                appState.logout();
                context.go('/');
              },
              child: const Text('Logout'),
            ),
            Spacer(),
          ]),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
        ),
        body: Center(
          child: Column(children: [
            Row(
              children: [
                SearchBar(
                  controller: myController,
                  hintText: 'Search...',
                  leading: const Icon(Icons.search),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (myController.text != '') {
                      appState.search(myController.text);
                    }
                  },
                  child: const Icon(Icons.search),
                )
              ],
            ),
            const Spacer(),
            ElevatedButton(
              child: const Text('New note'),
              onPressed: () {
                context.go('/create');
              },
            ),
            ElevatedButton(
              onPressed: () {
                print('${appState.name()} logged out');
                appState.logout();
                context.go('/');
              },
              child: const Text('Logout'),
            ),
            const Spacer(),
          ]),
        ),
      );
    }
  }
}
