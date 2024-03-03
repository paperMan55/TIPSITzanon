import 'package:floor/floor.dart';
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
  final List<Post> _posts = <Post>[];

  @override
  initState() {
    super.initState();
    _getDao();
  }

  Future<void> _getDao() async {
    AppDatabase database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _dao = database.todoDao;
    _updatePosts();
  }

  _updatePosts() {
    _dao.getPosts().then((posts) {
      setState(() {
        _posts.clear();
        _posts.addAll(posts);
      });
    });
  }

  void _handlePostChange(Post post) {
    _textFieldController.text = post.name;
    _displayChangeDialog(post);
  }
  void _handlePostDelete(Post post) {
    _dao.deletePost(post);
    deleteCommentsOfPost(post.id!);
    setState(() {
      _updatePosts();
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
                _addPostItem(value);
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
                _addPostItem(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _displayChangeDialog(Post post) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('modify Post'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'type here ...'),
            onSubmitted: (value) {
                if(value.isEmpty){
                  return;
                }
                Post pos = Post(id: post.id, name: value);
                Navigator.of(context).pop();
                _dao.updatePost(pos);
                _textFieldController.clear();
                _updatePosts();
              },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Modify'),
              onPressed: () {
                if(_textFieldController.text.isEmpty){
                  return;
                }
                Post pos = Post(id: post.id, name: _textFieldController.text);
                Navigator.of(context).pop();
                _dao.updatePost(pos);
                _textFieldController.clear();
                _updatePosts();
              },
            ),
          ],
        );
      },
    );
  }

  void _addPostItem(String name) {
    Post post = Post(id: null, name: name);
    _dao.insertPost(post);
    setState(() {
      _updatePosts();
    });
    
    _textFieldController.clear();
  }

  void resetDatabase(){
    _dao.getComments().then((value) => _dao.deleteComments(value).then((value){_updatePosts();}));
    _dao.getPosts().then((value) => _dao.deletePosts(value).then((value){_updatePosts();}));
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
            itemCount: _posts.length,
            itemBuilder: (context, index) {
              return TodoItem(
                dao: _dao,
                post: _posts[index],
                onTodoChanged: _handlePostChange,
                onTodoDelete: _handlePostDelete,
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
