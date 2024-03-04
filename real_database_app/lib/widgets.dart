import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'model.dart';

import 'dao.dart';
import 'database.dart';

class TodoItem extends StatefulWidget {
  TodoItem({
    required this.post,
    required this.onTodoChanged,
    required this.onTodoDelete,
    required this.dao,
  }) : super(key: ObjectKey(post));

  final Post post;
  final Function onTodoChanged;
  final Function onTodoDelete;
  final TodoDao dao;
  
  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return  TodoItemState(post, onTodoChanged, onTodoDelete, dao);
  }
}

class TodoItemState extends State<TodoItem>{
  final Post post;
  final Function onTodoChanged;
  final Function onTodoDelete;
  final TodoDao dao;
  final TextEditingController _textFieldController = TextEditingController();
  List<Comment> realComments = [];

  TodoItemState(this.post,this.onTodoChanged,this.onTodoDelete, this.dao){
    getComments(post.id!);
  }
  void getComments(int id) async {
    dao.getCommentsByPostId(id).then((value) {setState(() {
      realComments = value;
    });});
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      
      margin: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color:  Color.fromARGB(255, 175, 216, 249),
      ),
      child: Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
            color:  Color.fromARGB(255, 86, 174, 246),
      ),
          child: ListTile(
          onLongPress: (() {
            //onTodoDelete(todo);
            _displayOptions();
          }),
          leading: CircleAvatar(child: Text(post.name[0])),
          title: Text(post.name),
        ),
        ),
        SizedBox(
          width: 250,
          height: clampDouble(realComments.length*20, 0, 100),
          child: ListView.builder(
              
              padding: const EdgeInsets.symmetric(vertical: 0),
              itemCount: realComments.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 20,
                  child: Text(realComments[index].name),
                );
              }),
        ),
        IconButton(onPressed: _displayDialog, icon: const Icon(Icons.message))
      ],
    ),
    );
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('add comment'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'type here ...'),
            onSubmitted: (value) {
                Navigator.of(context).pop();
                _addTodoComment(value);
              },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Comment'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoComment(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _displayOptions() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 80,
            child: Column(
              
              children: [
                SizedBox(
                  height: 40,
                  width: 300,
                  child: TextButton(onPressed: (){Navigator.of(context).pop();onTodoChanged(post);}, child: const Text("modify")),
                ),
                SizedBox(
                  height: 40,
                  width: 300,
                  child: TextButton(onPressed: (){Navigator.of(context).pop();onTodoDelete(post);}, child: const Text("delete")),
                ),
              ],
            ),
          )
        );
      },
    );
  }
  void _addTodoComment(String name) {
    print(post.id);
    Comment com = Comment(id: null, name: "-> $name", postid: post.id!);
    dao.insertComment(com).then((value){getComments(post.id!);});
    
    _textFieldController.clear();
  }
}
