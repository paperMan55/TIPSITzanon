//CLASSE SERVER_TCP.DART

import 'dart:io';
Socket? player1;
Socket? player2;
void main() async {
  // Creazione del server che ascolta su tutte le interfacce IPv4 sulla porta 8080
  final server = await ServerSocket.bind('0.0.0.0', 8080);
  print('Server in ascolto su ${server.address}:${server.port}');
  // Gestione delle connessioni in arrivo
  await for (var socket in server) {
    handleConnection(socket);
  }
}

void handleConnection(Socket socket) {
  print("connesso");
  // ignore: prefer_conditional_assignment
  if(player1 == null ){
    player1 = socket;
  }else{
    player2 = socket;
  }


  // Notifica della connessione del client e invio del messaggio di benvenuto
  print('Client connesso: ${socket.remoteAddress}:${socket.remotePort}');

  socket.listen(
    (List<int> data) {
      final message = String.fromCharCodes(data);
      if(player1 == socket){
        player2?.write(message);
      }else{
        player1?.write(message);
      }
      print('Ricevuto: $message');
    },
    onDone: () {
      // Notifica della disconnessione del client
      print('Client disconnesso');
      socket.close();
    },
    onError: (error) {
      // Gestione degli errori e chiusura del socket in caso di errore
      print('Errore: $error');
      socket.close();
    },
    cancelOnError: true,
  );
}