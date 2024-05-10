// ignore_for_file: non_constant_identifier_names

import 'package:floor/floor.dart';

import 'model.dart';

@dao
abstract class TodoDao {

  @Query('SELECT * FROM Game')
  Future<List<Game>> getGames();

  @Query('SELECT * FROM Game WHERE id = :id')
  Future<Game?> findGameById(int id);

  @Query('SELECT * FROM Gamet WHERE mail_editore = :mail_editore')
  Future<List<Game>> getGamesByMail(int mail_editore);

  @insert
  Future<void> insertGame(Game game);

  @insert
  Future<void> insertGames(List<Game> games);

  @update
  Future<void> updateGame(Game game);

  @update
  Future<void> updateGames(List<Game> games);

  @delete
  Future<void> deleteGame(Game games);

  @delete
  Future<void> deleteGames(List<Game> games);

  @Query('SELECT * FROM Developer')
  Future<List<Developer>> getDevelopers();

  @Query('SELECT * FROM Developer WHERE e_mail = :e_mail')
  Future<Developer?> findDeveloperById(int e_mail);

  @insert
  Future<void> insertDeveloper(Developer developer);

  @insert
  Future<void> insertDevelopers(List<Developer> developers);

  @update
  Future<void> updateDeveloper(Developer developer);

  @update
  Future<void> updateDevelopers(List<Developer> developers);

  @delete
  Future<void> deleteDeveloper(Developer developers);

  @delete
  Future<void> deleteDevelopers(List<Developer> developers);

  @insert
  Future<void> insertServer(Server server);
  
  @delete
  Future<void> deleteServer(Server server);

  @Query('SELECT * FROM Server')
  Future<List<Server>> getServers();
}
