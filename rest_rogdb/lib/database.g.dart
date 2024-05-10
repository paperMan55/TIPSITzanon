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
            'CREATE TABLE IF NOT EXISTS `Developer` (`e_mail` TEXT NOT NULL, `nome` TEXT NOT NULL, `sede` TEXT NOT NULL, `password` TEXT, PRIMARY KEY (`e_mail`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Comment` (`id` INTEGER NOT NULL, `nome` TEXT NOT NULL, `descrizione` TEXT NOT NULL, `prezzo` REAL NOT NULL, `sconto` INTEGER NOT NULL, `mail_editore` INTEGER NOT NULL, `main_img` TEXT NOT NULL, `valutazione` REAL NOT NULL, `data_pubblicazione` TEXT NOT NULL, FOREIGN KEY (`mail_editore`) REFERENCES `Developer` (`e_mail`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Server` (`ipaddress` TEXT NOT NULL, PRIMARY KEY (`ipaddress`))');

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
        _gameInsertionAdapter = InsertionAdapter(
            database,
            'Comment',
            (Game item) => <String, Object?>{
                  'id': item.id,
                  'nome': item.nome,
                  'descrizione': item.descrizione,
                  'prezzo': item.prezzo,
                  'sconto': item.sconto,
                  'mail_editore': item.mail_editore,
                  'main_img': item.main_img,
                  'valutazione': item.valutazione,
                  'data_pubblicazione': item.data_pubblicazione
                }),
        _developerInsertionAdapter = InsertionAdapter(
            database,
            'Developer',
            (Developer item) => <String, Object?>{
                  'e_mail': item.e_mail,
                  'nome': item.nome,
                  'sede': item.sede,
                  'password': item.password
                }),
        _serverInsertionAdapter = InsertionAdapter(database, 'Server',
            (Server item) => <String, Object?>{'ipaddress': item.ipaddress}),
        _gameUpdateAdapter = UpdateAdapter(
            database,
            'Comment',
            ['id'],
            (Game item) => <String, Object?>{
                  'id': item.id,
                  'nome': item.nome,
                  'descrizione': item.descrizione,
                  'prezzo': item.prezzo,
                  'sconto': item.sconto,
                  'mail_editore': item.mail_editore,
                  'main_img': item.main_img,
                  'valutazione': item.valutazione,
                  'data_pubblicazione': item.data_pubblicazione
                }),
        _developerUpdateAdapter = UpdateAdapter(
            database,
            'Developer',
            ['e_mail'],
            (Developer item) => <String, Object?>{
                  'e_mail': item.e_mail,
                  'nome': item.nome,
                  'sede': item.sede,
                  'password': item.password
                }),
        _gameDeletionAdapter = DeletionAdapter(
            database,
            'Comment',
            ['id'],
            (Game item) => <String, Object?>{
                  'id': item.id,
                  'nome': item.nome,
                  'descrizione': item.descrizione,
                  'prezzo': item.prezzo,
                  'sconto': item.sconto,
                  'mail_editore': item.mail_editore,
                  'main_img': item.main_img,
                  'valutazione': item.valutazione,
                  'data_pubblicazione': item.data_pubblicazione
                }),
        _developerDeletionAdapter = DeletionAdapter(
            database,
            'Developer',
            ['e_mail'],
            (Developer item) => <String, Object?>{
                  'e_mail': item.e_mail,
                  'nome': item.nome,
                  'sede': item.sede,
                  'password': item.password
                }),
        _serverDeletionAdapter = DeletionAdapter(
            database,
            'Server',
            ['ipaddress'],
            (Server item) => <String, Object?>{'ipaddress': item.ipaddress});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Game> _gameInsertionAdapter;

  final InsertionAdapter<Developer> _developerInsertionAdapter;

  final InsertionAdapter<Server> _serverInsertionAdapter;

  final UpdateAdapter<Game> _gameUpdateAdapter;

  final UpdateAdapter<Developer> _developerUpdateAdapter;

  final DeletionAdapter<Game> _gameDeletionAdapter;

  final DeletionAdapter<Developer> _developerDeletionAdapter;

  final DeletionAdapter<Server> _serverDeletionAdapter;

  @override
  Future<List<Game>> getGames() async {
    return _queryAdapter.queryList('SELECT * FROM Game',
        mapper: (Map<String, Object?> row) => Game(
            id: row['id'] as int,
            nome: row['nome'] as String,
            descrizione: row['descrizione'] as String,
            prezzo: row['prezzo'] as double,
            sconto: row['sconto'] as int,
            mail_editore: row['mail_editore'] as int,
            main_img: row['main_img'] as String,
            valutazione: row['valutazione'] as double,
            data_pubblicazione: row['data_pubblicazione'] as String));
  }

  @override
  Future<Game?> findGameById(int id) async {
    return _queryAdapter.query('SELECT * FROM Game WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Game(
            id: row['id'] as int,
            nome: row['nome'] as String,
            descrizione: row['descrizione'] as String,
            prezzo: row['prezzo'] as double,
            sconto: row['sconto'] as int,
            mail_editore: row['mail_editore'] as int,
            main_img: row['main_img'] as String,
            valutazione: row['valutazione'] as double,
            data_pubblicazione: row['data_pubblicazione'] as String),
        arguments: [id]);
  }

  @override
  Future<List<Game>> getGamesByMail(int mail_editore) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Gamet WHERE mail_editore = ?1',
        mapper: (Map<String, Object?> row) => Game(
            id: row['id'] as int,
            nome: row['nome'] as String,
            descrizione: row['descrizione'] as String,
            prezzo: row['prezzo'] as double,
            sconto: row['sconto'] as int,
            mail_editore: row['mail_editore'] as int,
            main_img: row['main_img'] as String,
            valutazione: row['valutazione'] as double,
            data_pubblicazione: row['data_pubblicazione'] as String),
        arguments: [mail_editore]);
  }

  @override
  Future<List<Developer>> getDevelopers() async {
    return _queryAdapter.queryList('SELECT * FROM Developer',
        mapper: (Map<String, Object?> row) => Developer(
            e_mail: row['e_mail'] as String,
            nome: row['nome'] as String,
            sede: row['sede'] as String,
            password: row['password'] as String?));
  }

  @override
  Future<Developer?> findDeveloperById(int e_mail) async {
    return _queryAdapter.query('SELECT * FROM Developer WHERE e_mail = ?1',
        mapper: (Map<String, Object?> row) => Developer(
            e_mail: row['e_mail'] as String,
            nome: row['nome'] as String,
            sede: row['sede'] as String,
            password: row['password'] as String?),
        arguments: [e_mail]);
  }

  @override
  Future<List<Server>> getServers() async {
    return _queryAdapter.queryList('SELECT * FROM Server',
        mapper: (Map<String, Object?> row) =>
            Server(ipaddress: row['ipaddress'] as String));
  }

  @override
  Future<void> insertGame(Game game) async {
    await _gameInsertionAdapter.insert(game, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertGames(List<Game> games) async {
    await _gameInsertionAdapter.insertList(games, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertDeveloper(Developer developer) async {
    await _developerInsertionAdapter.insert(
        developer, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertDevelopers(List<Developer> developers) async {
    await _developerInsertionAdapter.insertList(
        developers, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertServer(Server server) async {
    await _serverInsertionAdapter.insert(server, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateGame(Game game) async {
    await _gameUpdateAdapter.update(game, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateGames(List<Game> games) async {
    await _gameUpdateAdapter.updateList(games, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateDeveloper(Developer developer) async {
    await _developerUpdateAdapter.update(developer, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateDevelopers(List<Developer> developers) async {
    await _developerUpdateAdapter.updateList(
        developers, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteGame(Game games) async {
    await _gameDeletionAdapter.delete(games);
  }

  @override
  Future<void> deleteGames(List<Game> games) async {
    await _gameDeletionAdapter.deleteList(games);
  }

  @override
  Future<void> deleteDeveloper(Developer developers) async {
    await _developerDeletionAdapter.delete(developers);
  }

  @override
  Future<void> deleteDevelopers(List<Developer> developers) async {
    await _developerDeletionAdapter.deleteList(developers);
  }

  @override
  Future<void> deleteServer(Server server) async {
    await _serverDeletionAdapter.delete(server);
  }
}
