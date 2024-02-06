//CLASSE GAME_LOGIC.DART

import 'dart:math';
import 'package:flutter/material.dart';

class BattleshipGameLogic {
  late List<List<String>> playerBoard;
  late List<List<String>> opponentBoard;
  late List<List<bool>> moves;
  late List<List<bool>> opponentMoves; // Aggiunto
  late List<String> messages;

  void initializeGame() {
    // Inizializzazione delle strutture dati del gioco
    playerBoard = List.generate(10, (_) => List.filled(10, ' '));
    opponentBoard = List.generate(10, (_) => List.filled(10, ' '));
    moves = List.generate(10, (_) => List.filled(10, false));
    opponentMoves = List.generate(10, (_) => List.filled(10, false)); // Aggiunto
    messages = [];

    // Altri passaggi di inizializzazione se necessario
  }

  List<List<String>> getPlayerBoard() {
    return playerBoard;
  }

  List<List<String>> getOpponentBoard() {
    return opponentBoard;
  }

  void placeShipsRandomly() {
    final Random random = Random();

    for (int shipSize = 5; shipSize >= 1; shipSize--) {
      bool shipPlaced = false;

      while (!shipPlaced) {
        // Genera posizione e orientamento casuali
        final int row = random.nextInt(10);
        final int col = random.nextInt(10);
        final bool isVertical = random.nextBool();

        if (canPlaceShip(row, col, shipSize, isVertical)) {
          // Posiziona la nave sul tabellone del giocatore
          placeShip(row, col, shipSize, isVertical);
          shipPlaced = true;
        }
      }
    }
  }

  bool canPlaceShip(int row, int col, int shipSize, bool isVertical) {
    // Verifica se è possibile posizionare la nave senza sovrapposizioni
    if (isVertical) {
      if (row + shipSize > 10) {
        return false; // La nave non rientra nel tabellone
      }

      for (int i = row; i < row + shipSize; i++) {
        if (playerBoard[i][col] == 'X') {
          return false; // Sovrapposizione con un'altra nave
        }
      }
    } else {
      if (col + shipSize > 10) {
        return false; // La nave non rientra nel tabellone
      }

      for (int j = col; j < col + shipSize; j++) {
        if (playerBoard[row][j] == 'X') {
          return false; // Sovrapposizione con un'altra nave
        }
      }
    }

    return true;
  }

  void placeShip(int row, int col, int shipSize, bool isVertical) {
    // Posiziona la nave sul tabellone del giocatore
    if (isVertical) {
      for (int i = row; i < row + shipSize; i++) {
        playerBoard[i][col] = 'X';
      }
    } else {
      for (int j = col; j < col + shipSize; j++) {
        playerBoard[row][j] = 'X';
      }
    }
  }

  void processMove(String move) {
  try {
    final coordinates = move.split(',');
    final int row = int.parse(coordinates[0]);
    final int col = int.parse(coordinates[1]);

    if (row < 0 || row >= 10 || col < 0 || col >= 10) {
      messages.add('Coordinate non valide. Riprova.');
      return;
    }

    if (opponentMoves[row][col]) {
      messages.add('Hai già effettuato una mossa in questa posizione. Riprova.');
      return;
    }

    opponentMoves[row][col] = true;

    if (opponentBoard[row][col] == 'X') {
      messages.add('Colpito! Hai colpito una nave avversaria!');
      if (checkIfShipSunk(row, col)) {
        messages.add('Hai affondato una nave avversaria!');
      }
    } else {
      messages.add('Mancato! Nessuna nave in questa posizione.');
    }

    // Altre logiche per il turno successivo o fine del gioco
    // ...

  } catch (e) {
    messages.add('Input non valido. Riprova.');
  }
}

  bool isGameOver() {
  for (var row in opponentBoard) {
    for (var cell in row) {
      if (cell == 'X') {
        return false;
      }
    }
  }
  return true;
}

bool checkIfShipSunk(int row, int col) {
  // Verifica se la nave alle coordinate specificate è affondata
  final String shipType = opponentBoard[row][col];
  for (var i = 0; i < opponentBoard.length; i++) {
    for (var j = 0; j < opponentBoard[i].length; j++) {
      if (opponentBoard[i][j] == shipType && !opponentMoves[i][j]) {
        return false;
      }
    }
  }
  return true;
}
}

Widget _buildGameBoard(List<List<String>> board, String title) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              SizedBox(width: 30.0),
              for (var i = 0; i < 10; i++)
                Container(
                  width: 30.0,
                  height: 30.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(String.fromCharCode('A'.codeUnitAt(0) + i)),
                ),
            ],
          ),
          for (var row = 0; row < board.length; row++) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30.0,
                  height: 30.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text('${row + 1}'),
                ),
                for (var cell in board[row]) ...[
                  Container(
                    width: 30.0,
                    height: 30.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: _getColorePerCella(cell),
                    ),
                    child: Text(cell),
                  ),
                  SizedBox(width: 4.0),
                ],
              ],
            ),
            SizedBox(height: 4.0),
          ],
        ],
      ),
    ),
  );
}

Widget _buildMessagesList(List<String> messages) {
  return Container(
    padding: EdgeInsets.all(8.0),
    child: ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(messages[index]),
        );
      },
    ),
  );
}

Color _getColorePerCella(String cella) {
  switch (cella) {
    case ' ':
      return Colors.lightBlue;
    case 'O':
      return Colors.grey;
    case 'X':
      return Colors.red;
    default:
      return Colors.green;
  }
}
