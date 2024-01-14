import 'package:surrealdb/surrealdb.dart';

void main(List<String> args) async {
  final client = SurrealDB('ws://localhost:8000/rpc')..connect();

  await client.wait();
  // use test namespace and test database
  // TODO: create surreal ql file
  await client.use('dev', 'main');
  // authenticate with user and pass
  await client.signin(user: 'root', pass: 'root');

  //add(client, 'Amaar', 'hello');
  get(client, 'Amaar');
}

void add(SurrealDB client, String name, String note) async {
  final data = {'name': name, 'note': note};
  var addition = await client.create('notes', data);
  print(addition);
}

void get(SurrealDB client, String name) async {
  final userNotes =
      await client.query('SELECT * FROM notes WHERE name==\'$name\'');
  print(userNotes);
}
