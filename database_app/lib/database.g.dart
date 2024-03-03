// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TodoDao? _todoDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Comment` (`id` INTEGER, `postid` INTEGER NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Post` (`id` INTEGER, `name` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TodoDao get todoDao {
    return _todoDaoInstance ??= _$TodoDao(database, changeListener);
  }
}

class _$TodoDao extends TodoDao {
  _$TodoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _commentInsertionAdapter = InsertionAdapter(
            database,
            'Comment',
            (Comment item) => <String, Object?>{
                  'id': item.id,
                  'postid': item.postid,
                  'name': item.name
                }),
        _postInsertionAdapter = InsertionAdapter(database, 'Post',
            (Post item) => <String, Object?>{'id': item.id, 'name': item.name}),
        _commentUpdateAdapter = UpdateAdapter(
            database,
            'Comment',
            ['id'],
            (Comment item) => <String, Object?>{
                  'id': item.id,
                  'postid': item.postid,
                  'name': item.name
                }),
        _postUpdateAdapter = UpdateAdapter(database, 'Post', ['id'],
            (Post item) => <String, Object?>{'id': item.id, 'name': item.name}),
        _commentDeletionAdapter = DeletionAdapter(
            database,
            'Comment',
            ['id'],
            (Comment item) => <String, Object?>{
                  'id': item.id,
                  'postid': item.postid,
                  'name': item.name
                }),
        _postDeletionAdapter = DeletionAdapter(database, 'Post', ['id'],
            (Post item) => <String, Object?>{'id': item.id, 'name': item.name});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Comment> _commentInsertionAdapter;

  final InsertionAdapter<Post> _postInsertionAdapter;

  final UpdateAdapter<Comment> _commentUpdateAdapter;

  final UpdateAdapter<Post> _postUpdateAdapter;

  final DeletionAdapter<Comment> _commentDeletionAdapter;

  final DeletionAdapter<Post> _postDeletionAdapter;

  @override
  Future<List<Comment>> getComments() async {
    return _queryAdapter.queryList('SELECT * FROM Comment',
        mapper: (Map<String, Object?> row) => Comment(
            id: row['id'] as int?,
            name: row['name'] as String,
            postid: row['postid'] as int));
  }

  @override
  Future<Comment?> findCommentById(int id) async {
    return _queryAdapter.query('SELECT * FROM Comment WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Comment(
            id: row['id'] as int?,
            name: row['name'] as String,
            postid: row['postid'] as int),
        arguments: [id]);
  }

  @override
  Future<List<Comment>> getCommentsByPostId(int id) async {
    return _queryAdapter.queryList('SELECT * FROM Comment WHERE postid = ?1',
        mapper: (Map<String, Object?> row) => Comment(
            id: row['id'] as int?,
            name: row['name'] as String,
            postid: row['postid'] as int),
        arguments: [id]);
  }

  @override
  Future<List<Post>> getPosts() async {
    return _queryAdapter.queryList('SELECT * FROM Post',
        mapper: (Map<String, Object?> row) =>
            Post(id: row['id'] as int?, name: row['name'] as String));
  }

  @override
  Future<Post?> findPostById(int id) async {
    return _queryAdapter.query('SELECT * FROM Post WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            Post(id: row['id'] as int?, name: row['name'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertComment(Comment item) async {
    await _commentInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertComments(List<Comment> items) async {
    await _commentInsertionAdapter.insertList(items, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertPost(Post item) async {
    await _postInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertPosts(List<Post> items) async {
    await _postInsertionAdapter.insertList(items, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateComment(Comment item) async {
    await _commentUpdateAdapter.update(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateComments(List<Comment> items) async {
    await _commentUpdateAdapter.updateList(items, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePost(Post item) async {
    await _postUpdateAdapter.update(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePosts(List<Post> items) async {
    await _postUpdateAdapter.updateList(items, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteComment(Comment items) async {
    await _commentDeletionAdapter.delete(items);
  }

  @override
  Future<void> deleteComments(List<Comment> itemss) async {
    await _commentDeletionAdapter.deleteList(itemss);
  }

  @override
  Future<void> deletePost(Post items) async {
    await _postDeletionAdapter.delete(items);
  }

  @override
  Future<void> deletePosts(List<Post> itemss) async {
    await _postDeletionAdapter.deleteList(itemss);
  }
}
