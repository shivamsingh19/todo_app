import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/utils/dbhelper.dart';

DbHelper helper = DbHelper();

final List<String> choices = const <String>[
  'Save Todo and Back',
  'Delete Todo',
  'Back to List'
];

const mnuSave = 'Save Todo and Back';
const mnuDelete = 'Delete Todo';
const mnuBack = 'Back to List';

class TodoDetails extends StatefulWidget {
  final Todo todo;
  TodoDetails(this.todo);
  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);
}

class TodoDetailState extends State {
  Todo todo;
  TodoDetailState(this.todo);
  final _priorities = ["High", "Medium", "Low"];
  String _priority = "Low";
  TextEditingController titleContorler = TextEditingController();
  TextEditingController descriptionContorler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleContorler.text = todo.title;
    descriptionContorler.text = todo.description;
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: select,
            itemBuilder: (BuildContext context) {
              return choices.map((String choice) {
                return PopupMenuItem<String>(
                    value: choice, child: Text(choice));
              }).toList();
            },
          )
        ],
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  TextField(
                    controller: titleContorler,
                    style: textStyle,
                    onChanged: (value) => this.updateTitle(),
                    decoration: InputDecoration(
                        labelText: "Title",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: TextField(
                        controller: descriptionContorler,
                        style: textStyle,
                        onChanged: (value) => this.updatedescription(),
                        decoration: InputDecoration(
                            labelText: "Description",
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  ListTile(
                      title: DropdownButton<String>(
                    items: _priorities.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    style: textStyle,
                    value: retrivePrority(todo.priority),
                    onChanged: (value) => updatePriority(value),
                  ))
                ],
              )
            ],
          )),
    );
  }

  void select(String value) async {
    int result;
    debugPrint(value);
    switch (value) {
      case mnuSave:
        save();
        break;
      case mnuDelete:
        Navigator.pop(context, true);
        if (todo.id == null) {
          return;
        } else {
          result = await helper.deleteTodo(todo.id);
          if (result != 0) {
            AlertDialog alterDialog = AlertDialog(
              title: Text('Delete Todo'),
              content: Text('Todo has been deleted'),
            );
            showDialog(context: context, builder: (_) => alterDialog);
          }
        }
        break;
      case mnuBack:
        Navigator.pop(context, true);
        break;
    }
  }

  void save() {
    todo.date = new DateFormat.yMd().format(DateTime.now());
    debugPrint(todo.title + " tile");
    if (todo.id != null) {
      helper.updateTodo(todo);
    } else {
      helper.insertTodo(todo);
    }
    Navigator.pop(context, true);
  }

  void updatePriority(String value) {
    switch (value) {
      case 'High':
        todo.priority = 1;
        break;
      case 'Medium':
        todo.priority = 2;
        break;
      case 'Low':
        todo.priority = 3;
        break;
    }
    setState(() {
      _priority = value;
    });
  }

  String retrivePrority(int value) {
    return _priorities[value - 1];
  }

  void updateTitle() {
    todo.title = titleContorler.text;
  }

  void updatedescription() {
     todo.description = descriptionContorler.text;
  }
}
