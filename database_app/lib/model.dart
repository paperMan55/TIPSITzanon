import 'package:floor/floor.dart';

@entity
class Post {
  Post({required this.id, required this.name});

  @primaryKey
  final int? id;

  final String name;
}

@Entity(tableName: "Comment", foreignKeys: [
  ForeignKey(childColumns: ["postid"], parentColumns: ["id"], entity: Post, onDelete: ForeignKeyAction.cascade),
])
class Comment {
  Comment({required this.id, required this.name, required this.postid});

  @primaryKey
  final int? id;

  @ColumnInfo(name: "postid")
  final int postid;

  final String name;
}
