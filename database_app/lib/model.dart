import 'package:floor/floor.dart';

@entity
class Todo {
  Todo({required this.id, required this.name, this.checked = false});

  @primaryKey
  final int? id;

  final String name;
  bool checked;
}

@entity
class Post {
  Post({required this.id, required this.name});

  @primaryKey
  final int? id;

  final String name;
}

@entity
class Comment {
  Comment({required this.id, required this.name, required this.postid});

  @primaryKey
  final int? id;

  @ForeignKey(childColumns: ["postid"], parentColumns: ["id"], entity: Post)
  final int postid;

  final String name;
}
