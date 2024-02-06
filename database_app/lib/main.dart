import 'package:flutter/material.dart';

import 'dao.dart';
import 'database.dart';
import 'model.dart';
import 'widgets.dart';

void main() {
  runApp(const MyApp());
}

late final TodoDao _dao;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      debugShowMaterialGrid: false,
      title: 'FEISBUK',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.red, backgroundColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'FEISBUK'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<Todo> _todos = <Todo>[];

  @override
  initState() {
    super.initState();
    _getDao();
  }

  Future<void> _getDao() async {
    AppDatabase database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _dao = database.todoDao;
    _updateTodos();
  }

  _updateTodos() {
    _dao.getTodos().then((todos) {
      setState(() {
        _todos.clear();
        _todos.addAll(todos);
      });
    });
  }

  void _handleTodoChange(Todo todo) {
    todo.checked = !todo.checked;
    setState(() {
      _todos.remove(todo);
      if (!todo.checked) {
        _todos.add(todo);
      } else {
        _todos.insert(0, todo);
      }
    });
    _dao.updateTodo(todo);
  }

  void _handleTodoDelete(Todo todo) {
    _dao.deleteTodo(todo);
    deleteCommentsOfPost(todo.id!);
    setState(() {
      _updateTodos();
    });
  }

  void deleteCommentsOfPost(int id) {
    _dao.getCommentsByPostId(id).then((value){
      _dao.deleteComments(value);
    });
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('add Post'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'type here ...'),
            onSubmitted: (value) {
                if(value.isEmpty){
                  return;
                }
                Navigator.of(context).pop();
                _addTodoItem(value);
              },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if(_textFieldController.text.isEmpty){
                  return;
                }
                Navigator.of(context).pop();
                _addTodoItem(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void _addTodoItem(String name) {
    Todo todo = Todo(id: null, name: name, checked: false);
    _dao.insertTodo(todo);
    setState(() {
      _updateTodos();
    });
    
    _textFieldController.clear();
  }

  void resetDatabase(){
    _dao.getComments().then((value) => _dao.deleteComments(value).then((value){_updateTodos();}));
    _dao.getTodos().then((value) => _dao.deleteTodos(value).then((value){_updateTodos();}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        actions: [
          IconButton(onPressed: resetDatabase, icon: const Icon(Icons.delete_forever))
        ],
      ),
      body: Center(
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: _todos.length,
            itemBuilder: (context, index) {
              return TodoItem(
                dao: _dao,
                todo: _todos[index],
                onTodoChanged: _handleTodoChange,
                onTodoDelete: _handleTodoDelete,
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(),
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }
}
