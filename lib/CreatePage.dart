import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'MyAppState.dart';


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
              context.go('/notes');
            },
          ),
          ElevatedButton(
            child: const Text('Discard'),
            onPressed: () {
              appState.get();
              context.go('/notes');
            },
          ),
          const Spacer(),
        ]),
      ),
    );
  }
}