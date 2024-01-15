import 'package:flutter/material.dart';
import 'package:surrealdb/surrealdb.dart';

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