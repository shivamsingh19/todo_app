import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/screens/tododetails.dart';
import 'package:todo_app/utils/dbhelper.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoListState();
}

class TodoListState extends State {
  DbHelper helper = DbHelper();
  List<Todo> todos;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = List<Todo>();
      getData();
    }
    return Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          naviagteToDetails(Todo('', 3, ''));
        },
        tooltip: "Add new item",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView todoListItems() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getColor(this.todos[position].priority),
                child: Text(this.todos[position].priority.toString()),
              ),
              title: Text(this.todos[position].title),
              subtitle: Text(this.todos[position].date),
              onTap: () {
                debugPrint("Tapped on" + this.todos[position].id.toString());
                naviagteToDetails(this.todos[position]);
              },
            ),
          );
        });
  }

  void getData() {
    final dbfuture = helper.intializaDb();
    dbfuture.then((result) {
      final todosFuture = helper.getTodos();
      todosFuture.then((result) {
        List<Todo> todoList = List<Todo>();
        count = result.length;
        for (int i = 0; i < count; i++) {
          todoList.add(Todo.formObject(result[i]));
          debugPrint(todoList[i].title);
        }
        setState(() {
          todos = todoList;
          count = count;
        });
        debugPrint("item" + count.toString());
      });
    });
  }

  Color getColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.orange;
        break;
      case 3:
        return Colors.green;
        break;
      default:
        return Colors.green;
    }
  }

  void naviagteToDetails(Todo todo) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodoDetails(todo)));
    if (result == true) {
      getData();
    }
  }
}
