//CLASSE CLIENT_FLUTTER.DART

///Terminale: creare una matrice 10x10
///ed assegnare ad ogni casella un numero
///per identificare la nava. Es: 5 = portaerei.
///Quindi sulla casella della matrice,
///dove é riportato 5 ci sarà la portaerei

/// ************************************************
/// - PORTAEREI = 5 CASSELE
/// - CORAZZATA = 4 CASSELE
/// - SOTTOMARINO = 3 CASSELE
/// - CACCIATORPEDINIERE = 2 CASSELE
/// - SOMMERGIBILE = 1 CASELLA
/// ************************************************

// i due client dovranno ricere le istruzioni di gico +
// gli armamenti che dispongono

import 'dart:io';
import 'dart:convert';

// Creazione di un menù
void printMenu() {
  print("Seleziona un'opzione:");
  print("1: Posizionamento");
  print("2: Aggiorna mappa");
  print("3: esci");
}

var spazioVuotoAscii = String.fromCharCode(32);
List<String> alphabet = [
  '-',
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'L'
]; //riga orizontale

///////// PORTAEREI /////////////
// posizione 1 portaerei
int portaereiRowStart = 0;
int portaereiColStart = 0;

/// posizione 2 portaerei
int portaereiRowStartSecond = 0;
int portaereiColStartSecond = 0;

/// posizione 3 portaerei
int portaereiRowStartThird = 0;
int portaereiColStartThird = 0;

/// posizione 4 portaerei
int portaereiRowStartFourth = 0;
int portaereiColStartFourth = 0;
//posizione 5 portaerei
int portaereiRowEnd = 0;
int portaereiColEnd = 0;

///////// CORAZZATA /////////////
// posizione 1 corazzata
int corazzataRowStart = 0;
int corazzataColStart = 0;

/// posizione 2 corazzata
int corazzataRowStartSecond = 0;
int corazzataColStartSecond = 0;

/// posizione 3 corazzata
int corazzataRowStartThird = 0;
int corazzataColStartThird = 0;

//posizione 4 corazzata
int corazzataRowEnd = 0;
int corazzataColEnd = 0;

///////// SOTTOMARINO /////////////
// posizione 1 sottomarino
int sottomarinoRowStart = 0;
int sottomarinoColStart = 0;

/// posizione 2 sottomarino
int sottomarinoRowStartSecond = 0;
int sottomarinoColStartSecond = 0;

//posizione 3 sottomarino
int sottomarinoRowEnd = 0;
int sottomarinoColEnd = 0;

///////// CACCIATORPEDINIERE /////////////
// posizione 1 ciacciatorpediniere
int cacciatorpediniereRowStart = 0;
int cacciatorpediniereColStart = 0;
//posizione 3 sottomarino
int cacciatorpediniereRowEnd = 0;
int cacciatorpediniereColEnd = 0;

///////// SOMMERGIBILE /////////////
// posizione 1 sommergibile
int sommergibileRowStart = 0;
int sommergibileRowEnd = 0;
int sommergibileColStart = 0;
int sommergibileColEnd = 0;

List<int> listaDiInteri = [];
bool chooseEseguito = true;
//scelta case menu
int scelta = 5;
void aggiungiIntero(int valore) {
  listaDiInteri.add(valore);
}


// Metodo per ottenere la lista di interi
String ottieniLista() {
  print('Inserisci la lista di interi separati da spazi:');
  String input = stdin.readLineSync()!;

  // Aggiungi gli interi presenti nella lista
  for (var i = 0; i < listaDiInteri.length; i++) {
    input += ' ${listaDiInteri[i]}';
  }

  // Chiedi all'utente se vuole inviare i dati al server
  print('Vuoi inviare i dati al server? (Sì/No)');
  String risposta = stdin.readLineSync()!.toLowerCase();
  if ((risposta == 'si')) {
    print('invio al server');
    scelta = 0;
  } else {
    choose();
  }
  return input;
}

void inviaListaAlServer(Socket socket, String lista) {
  socket.write(lista);
}

void main() async {
  var socket = await Socket.connect('127.0.0.1', 8080);  //127.0.0.1
  print('Connected to server');

  //choose(); // Avvia il menu del client
  /*
  stdin.transform(utf8.decoder).listen((String input) {
    String lista = ottieniLista();
    inviaListaAlServer(socket, lista);
  });
  */

  socket.listen(
    (List<int> data) {
      var message = String.fromCharCodes(data).trim();
      socket.write("ricevuto");
      print('Received from server: $message');
    },
    onDone: () {
      print('Server disconnected');
      exit(0);
    },
    onError: (error) {
      print('Error with server: $error');
      exit(1);
    },
    cancelOnError: true,
  );
}

void drawMap() {
  for (var i = 0; i < 11; i++) {
    stdout.write('|   ${alphabet[i]}   ');
  }
  print('');
  print(
      '-------------------------------------------------------------------------------------');
  for (int row = 0; row < 10; row++) {
    stdout.write('|   $row   ');
    for (int column = 0; column < 10; column++) {
      if (portaereiRowStart == row && portaereiColStart == column ||
          portaereiRowEnd == row && portaereiColEnd == column ||
          portaereiRowStartSecond == row && portaereiColStartSecond == column ||
          portaereiRowStartThird == row && portaereiColStartThird == column ||
          portaereiRowStartFourth == row && portaereiColStartFourth == column) {
        stdout.write('|   5   ');
      } else if (corazzataRowStart == row && corazzataColStart == column ||
          corazzataRowEnd == row && corazzataColEnd == column ||
          corazzataRowStartSecond == row && corazzataColStartSecond == column ||
          corazzataRowStartThird == row && corazzataColStartThird == column) {
        stdout.write('|   4   ');
      } else if (sottomarinoRowStart == row && sottomarinoColStart == column ||
          sottomarinoRowEnd == row && sottomarinoColEnd == column ||
          sottomarinoRowStartSecond == row &&
              sottomarinoColStartSecond == column) {
        stdout.write('|   3   ');
      } else if (cacciatorpediniereRowStart == row &&
              cacciatorpediniereColStart == column ||
          cacciatorpediniereRowEnd == row &&
              cacciatorpediniereColEnd == column) {
        stdout.write('|   2   ');
      } else if (sommergibileRowStart == row &&
              sommergibileColStart == column ||
          sommergibileRowEnd == row && sommergibileColEnd == column) {
        stdout.write('|   1   ');
      } else {
        stdout.write('|   $spazioVuotoAscii   ');
      }
    }
    print('');
  }
  print(
      '-------------------------------------------------------------------------------------');
}

List<Map<String, dynamic>> shipTypes = [
  {'type': 'Portaerei', 'size': 5},
  {'type': 'Corazzata', 'size': 4},
  {'type': 'Sottomarino', 'size': 3},
  {'type': 'Cacciatorpediniere', 'size': 2},
  {'type': 'Sommergibile', 'size': 1},
];

void matrix() {
  try {
    for (var shipType in shipTypes) {
      stdout.write('***** $shipType *****');
      print('');

      for (int i = 0; i < shipType['size']; i++) {
        stdout.write('Posizione orizzontale $shipType[$i] 0 - 9: ');
        int row = int.parse(stdin.readLineSync()!); // y
        aggiungiIntero(row);

        stdout.write('Posizione verticale $shipType[$i] A - L: ');
        String column = stdin.readLineSync()!.toUpperCase(); // x
        int col = alphabet.indexOf(column);
        aggiungiIntero(col);
      }
    }
  } catch (e) {
    print('Inserire un valore compreso tra 0 - 9 o A - L');
  }
}


// stampa lista
void choose() {
  do {
    printMenu();
    stdout.write("Inserisci il numero dell'opzione desiderata: ");
    scelta = int.parse(stdin.readLineSync()!);
    switch (scelta) {
      case 1:
        print("Hai selezionato l'opzione posizionamento.");
        matrix();
        break;
      case 2:
        print("Hai selezionato l'opzione aggiornamento.");
        drawMap();
        break;
      case 3:
        print("Hai selezionato l'opzione esci.");
        ottieniLista();
        break;
      default:
        print("Scelta non valida.");
        break;
    }
  } while (scelta != 0);
}
