import 'package:floor/floor.dart';

import 'model.dart';

@dao
abstract class TodoDao {

  @Query('SELECT * FROM Comment')
  Future<List<Comment>> getComments();

  @Query('SELECT * FROM Comment WHERE id = :id')
  Future<Comment?> findCommentById(int id);

  @Query('SELECT * FROM Comment WHERE postid = :id')
  Future<List<Comment>> getCommentsByPostId(int id);

  @insert
  Future<void> insertComment(Comment item);

  @insert
  Future<void> insertComments(List<Comment> items);

  @update
  Future<void> updateComment(Comment item);

  @update
  Future<void> updateComments(List<Comment> items);

  @delete
  Future<void> deleteComment(Comment items);

  @delete
  Future<void> deleteComments(List<Comment> itemss);

  @Query('SELECT * FROM Post')
  Future<List<Post>> getPosts();

  @Query('SELECT * FROM Post WHERE id = :id')
  Future<Post?> findPostById(int id);

  @insert
  Future<void> insertPost(Post item);

  @insert
  Future<void> insertPosts(List<Post> items);

  @update
  Future<void> updatePost(Post item);

  @update
  Future<void> updatePosts(List<Post> items);

  @delete
  Future<void> deletePost(Post items);

  @delete
  Future<void> deletePosts(List<Post> itemss);
}
