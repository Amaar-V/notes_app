import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'NotesPage.dart';
import 'MyAppState.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();
    var appState = context.watch<MyAppState>();
    final user = appState.userName;

    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      myController.dispose();
    }

    //TODO fix this
    // if (user != '') {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => const NotesPage()),
    //   );
    // }
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
