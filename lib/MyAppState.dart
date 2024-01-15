import 'package:flutter/material.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppState extends ChangeNotifier {
  var userName = '';
  final client = SurrealDB('ws://localhost:8000/rpc')..connect();
  var prefs;
  var notes;

  MyAppState() {
    main();
  }

  void main() async {
    await client.wait();
    // use test namespace and test database
    await client.use('dev', 'main');
    // authenticate with user and pass
    await client.signin(user: 'root', pass: 'root');

    await client.query(
        'DEFINE ANALYZER notes_analyzer TOKENIZERS blank,class,camel,punct FILTERS snowball(english);');
    await client.query(
        'DEFINE INDEX note_content ON notes FIELDS note SEARCH ANALYZER notes_analyzer BM25(1.2,0.75) HIGHLIGHTS;');

    prefs = await SharedPreferences.getInstance();
    final String? user = prefs.getString('userName');
    if (user != null) userName = user;
    print('starting user is $userName');
  }

  void add(String note) async {
    final data = {'name': userName, 'note': note};
    print('adding $userName with $note');
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

  void login(String name) async {
    userName = name;
    await prefs.setString('userName', name);
  }

  void logout() async {
    userName = '';
    await prefs.setString('userName', '');
  }

  void search(String query) async {
    notes = await client.query(
        'SELECT name,note FROM notes WHERE name==\'$userName\' AND note @0@ \'$query\'');
    notifyListeners();
  }
}
