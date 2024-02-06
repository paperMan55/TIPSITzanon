import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Battleship Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _ipController,
              decoration: InputDecoration(
                labelText: 'Inserisci l\'indirizzo IP del server',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen(serverIp: _ipController.text),
                  ),
                );
              },
              child: Text('Inizia il Gioco'),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final String serverIp;

  GameScreen({required this.serverIp});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<List<String>> _playerBoard = List.generate(10, (_) => List.filled(10, ' '));
  List<List<String>> _opponentBoard = List.generate(10, (_) => List.filled(10, ' '));
  final TextEditingController _moveController = TextEditingController();
  List<String> _messages = [];
  late Socket _socket;

  @override
  void initState() {
    super.initState();
    _connectToServer();
  }

  void _connectToServer() async {
    try {
      _socket = await Socket.connect(widget.serverIp, 8080);
      _socket.listen(
        (Uint8List data) {
          final message = utf8.decode(data);
          _handleServerResponse(message);
        },
        onDone: () {
          _socket.destroy();
          print('Disconnesso dal server');
          _showDisconnectionDialog();
        },
        onError: (error) {
          print('Errore: $error');
        },
        cancelOnError: true,
      );
      _sendMessage('Connesso al server');
    } catch (e) {
      print('Errore di connessione al server: $e');
      _sendMessage('Errore di connessione al server');
    }
  }

  void _handleServerResponse(String message) {
    setState(() {
      _messages.add(message);
      // Aggiorna lo stato del gioco in base alla risposta del server
      // Esempio: _updateGameState(message);
    });
  }

  void _showDisconnectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Disconnesso'),
          content: Text('Sei stato disconnesso dal server.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                exit(0);
              },
              child: Text('Chiudi'),
            ),
          ],
        );
      },
    );
  }

  void _sendMessage(String message) {
    assert(_socket != null, "Socket must be initialized before sending a message.");
    _socket.write(message);
    _moveController.clear();
  }

  void _handlePlayerMove(String move) {
    if (move.isNotEmpty) {
      _sendMessage('MOVE:$move');
    }
  }

  Widget _buildPlayerBoardSection() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Player Board'),
          _buildGridHeaders(),
          _buildGridView(_playerBoard),
        ],
      ),
    );
  }

  Widget _buildOpponentBoardSection() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Opponent Board'),
          _buildGridView(_opponentBoard),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Column(
      children: [
        TextField(
          controller: _moveController,
          decoration: InputDecoration(
            labelText: 'Inserisci la tua mossa',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _handlePlayerMove(_moveController.text);
          },
          child: Text('Invia Mossa'),
        ),
        _buildMessageSection(),
      ],
    );
  }

  Widget _buildMessageSection() {
    return Column(
      children: _messages.map((message) => Text(message)).toList(),
    );
  }

  Widget _buildGridHeaders() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 24.0),
        for (int i = 0; i < 10; i++)
          Container(
            width: 30.0,
            child: Center(
              child: Text(
                alphabet[i],
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGridView(List<List<String>> board) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: board[0].length + 1,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
      itemCount: (board.length + 1) * board[0].length,
      itemBuilder: (context, index) {
        int row = index ~/ (board[0].length + 1);
        int col = index % (board[0].length + 1);
        return Container(
          color: _getCellColor(row, col, board),
          child: Center(
            child: _buildCellText(row, col, board),
          ),
        );
      },
    );
  }

  Color _getCellColor(int row, int col, List<List<String>> board) {
    if (row == 0 || col == 0) {
      return Colors.grey; // Grigio per i numeri/lettere
    } else {
      return board[row - 1][col - 1] == 'X' ? Colors.blue : Colors.grey;
    }
  }

  Widget? _buildCellText(int row, int col, List<List<String>> board) {
    if (row == 0 || col == 0) {
      return null; // Null per numeri/lettere
    } else {
      return Text(
        board[row - 1][col - 1],
        style: TextStyle(
          color: Colors.white,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Battleship Game'),
      ),
      body: Column(
        children: [
          _buildPlayerBoardSection(),
          _buildOpponentBoardSection(),
          _buildInputSection(),
        ],
      ),
    );
  }
}

const List<String> alphabet = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];

void main() {
  runApp(MaterialApp(
    home: MainScreen(),
  ));
}
