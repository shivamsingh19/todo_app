import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/screens/todolist.dart';
import 'package:todo_app/utils/dbhelper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // List<Todo> todos = List<Todo>();
    // DbHelper helper = DbHelper();
    // helper
    //     .intializaDb()
    //     .then((result) => helper.getTodos().then((result) => todos = result));
    // DateTime today = DateTime.now();
    // Todo todo = Todo("Buy apples", 3, today.toString(), "Make Some");

    // var result = helper.insertTodo(todo);
    return MaterialApp(
      title: 'Todos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(title: 'Todos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TodoList(),
    );
  }
}
