import 'dart:io';

import 'package:flutter/material.dart';

class Nave {
  final String nome;
  final int lunghezza;
  bool affondata;

  Nave(this.nome, this.lunghezza) : affondata = false;
}

class HomePage extends StatefulWidget {
  final String ip;
  const HomePage({Key? key, required this.ip} ) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(ip);
}

class _HomePageState extends State<HomePage> {
  late Socket socket;
  bool mioTurno = false;
  bool orizzontale = true;
  List<String> _mappaGiocoUtente = List.filled(100, '-');
  List<String> _mappaGiocoAvversario = List.filled(100, '-');
  List<Nave> _navi = [
    Nave("Portaerei", 5),
    Nave("Corazzata", 4),
    Nave("Sottomarino", 3),
    Nave("Cacciatorpediniere", 2),
    Nave("Sommergibile", 1),
  ];

  int _tentativi = 0;
  bool _posizionamentoNaviCompletato = false;
  bool start = false;
  bool enemyStart = false;

  void _mostraMessaggio(String messaggio) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(messaggio),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _posizionaNave(Nave nave, int indiceInizio, bool orizzontale) {
    int indice = indiceInizio;

    for (int i = 0; i < nave.lunghezza; i++) {
      if (_mappaGiocoUtente[indice] != '-') {
        _mostraMessaggio("Posizione già occupata. Riprova.");
        return;
      }
      _mappaGiocoUtente[indice] = "N";
      indice = orizzontale ? indice + 1 : indice + 10;
    }

    setState(() {
      nave.affondata = false;
      _navi.remove(nave);
      if (_navi.isEmpty) {
        _posizionamentoNaviCompletato = true;
        _mostraMessaggio("Posizionamento delle navi completato!");
      }
    });
  }

  void _attaccaNave(int indice) {
    if(!mioTurno){
      _mostraMessaggio("aspetta il tuo turno!");
      return;
    }
    if (_mappaGiocoAvversario[indice] == 'X' || _mappaGiocoAvversario[indice] == 'O') {
      _mostraMessaggio("Hai già attaccato questa posizione!");
      return;
    }
    setState(() {
      _tentativi++;
      socket.write("hit nave  $indice");
      mioTurno = false;
    });
  }

  void _visualizzaMessaggioFineGioco(String messaggio) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Fine del gioco"),
          content: Text(messaggio),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _ripartiGioco();
              },
              child: Text("Rigioca"),
            ),
          ],
        );
      },
    );
  }

  void _ripartiGioco() {
    setState(() {
      start = false;
      enemyStart = false;
      mioTurno = false;
      _mappaGiocoUtente = List.filled(100, '-');
      _mappaGiocoAvversario = List.filled(100, '-');
      _navi = [
        Nave("Portaerei", 5),
        Nave("Corazzata", 4),
        Nave("Sottomarino", 3),
        Nave("Cacciatorpediniere", 2),
        Nave("Sommergibile", 1),
      ];
      _tentativi = 0;
      _posizionamentoNaviCompletato = false;
    });
  }

  Widget _buildPosizionamentoNaviGUI() {
    return Column(
      children: [
        // Nuova parte per la griglia di posizionamento
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            "Posiziona le navi sulla griglia:",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 10,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
          itemCount: _mappaGiocoUtente.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Aggiungi la logica per selezionare la nave da posizionare
                if (_navi.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Seleziona la nave"),
                      content: DropdownButton<Nave>(
                        items: _navi
                            .map((nave) => DropdownMenuItem<Nave>(
                                  value: nave,
                                  child: Text(nave.nome),
                                ))
                            .toList(),
                        onChanged: (nave) {
                          if (nave != null) {
                            // Verifica se la nave può essere posizionata
                            if (index + nave.lunghezza - 1 < 100 &&
                                _mappaGiocoUtente
                                    .sublist(index, index + nave.lunghezza)
                                    .every((cella) => cella == '-')) {
                              _posizionaNave(nave, index, orizzontale);
                              stampaGriglia();
                              Navigator.pop(context);
                            } else {
                              _mostraMessaggio("Impossibile posizionare la nave in questa posizione. Riprova.");
                            }
                          }
                        },
                      ),
                    ),
                  );
                } else {
                  _mostraMessaggio("Tutte le navi sono già posizionate!");
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  _mappaGiocoUtente[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
        // Aggiunto pulsante per iniziare la partita dopo aver posizionato le navi
        ElevatedButton(
          onPressed: () {
            if (!_posizionamentoNaviCompletato) {
              _mostraMessaggio("Devi posizionare tutte le navi prima di iniziare la partita!");
              return;
            }
            _mostraMessaggio("Inizia la partita!");
            socket.write("start     "); //dice all altro che lo sto aspettando
            start = true;  //io sono pronto
            setState(() {});
          },
          child:const Text("Inizia la partita"),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              orizzontale = ! orizzontale;
            });
          },
          child: Text(orizzontale?"orizzontale":"verticale"),
        ),
      ],
    );
  }
  void stampaGriglia(){
    String a = "";
    for(int i=0;i<100;i++){
      a+="${_mappaGiocoUtente[i]} | ";
      if(i+1%10 == 0){
        print(a);
        print("-------------------------------------------");
        a = "";
      }
    }
  }
  bool hoPerso(){
    if(_mappaGiocoUtente.contains("N")){
      return false;
    }
    _mostraMessaggio("hai persoo :-(");
    return true;
  }
  Widget _buildGiocoInCorsoGUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Tentativi: $_tentativi",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        // Griglia dell'avversario
        SizedBox(
          height: 400,
          width: 400,
          child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 10,
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 2.0,
          ),
          itemCount: _mappaGiocoAvversario.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Logica per attaccare la nave dell'avversario
                _attaccaNave(index);
                // Altri passaggi necessari
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _mappaGiocoAvversario[index] == '-'
                      ? Colors.blue
                      : _mappaGiocoAvversario[index] == 'O'
                          ? Colors.grey
                          : Colors.red,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  _mappaGiocoAvversario[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
        ),
        // Spaziatura tra le griglie
        SizedBox(height: 20),
        // Griglia dell'utente
        SizedBox(
          height: 200,
          width: 200,
          child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 10,
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 2.0,
          ),
          itemCount: _mappaGiocoUtente.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Logica per mostrare informazioni sulla nave (affondata o colpita)
                String cella = _mappaGiocoUtente[index];
                if (cella != '-') {
                  Nave naveCorrispondente =
                      _navi.firstWhere((nave) => nave.nome[0] == cella);
                  String messaggio = naveCorrispondente.affondata
                      ? "Hai affondato la nave ${naveCorrispondente.nome}!"
                      : "Hai colpito la nave ${naveCorrispondente.nome}!";
                  _mostraMessaggio(messaggio);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _mappaGiocoUtente[index] == '-'
                      ? Colors.blue
                      : _mappaGiocoUtente[index] == 'O'
                          ? Colors.grey
                          : _mappaGiocoUtente[index] == 'N'
                          ? Colors.purple
                          : Colors.red,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  _mappaGiocoUtente[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
        )
      ],
    );
  }

  void connect(String ip) async{
    socket = await Socket.connect(ip, 8080);  //127.0.0.1
    print('Connected to server');
    socket.listen(
      (List<int> data) {
        String message = String.fromCharCodes(data);

        String operazione = message;
        String indice = "";
        if(message.length>10){
          operazione = message.substring(0,10);
          indice = message.substring(10);
        }

        switch(operazione){
          case "start     ":
          print("partito");
          enemyStart = true;
          if(start){
            _mostraMessaggio("E' il tuo turno!");
            mioTurno = true;
          }else{
            mioTurno = false;
          }
          break;
          case "hit nave  ":
          print("aio");
          verificaPosizione(indice);
          break;
          case "colpito   ":
          print("evai coplito");
          _mappaGiocoAvversario[int.parse(indice)] = "X";
          break;
          case "mancato   ":
          print("no mancato");
          _mappaGiocoAvversario[int.parse(indice)] = "O";
          break;
          case "perso     ":
          _visualizzaMessaggioFineGioco(" VINTOOOOOO !!!!");
          break;
        }
        setState(() {});
      },
      cancelOnError: true,
    );
  }

  void verificaPosizione(String indice){
    mioTurno = true;
    _mostraMessaggio("E' il tuo turno!");
    var colpito = _mappaGiocoUtente[int.parse(indice)];
    if(colpito=="-"){
      socket.write("mancato   $indice");
      _mappaGiocoUtente[int.parse(indice)] = "O";
    }else{
      
      _mappaGiocoUtente[int.parse(indice)] = "X";
      if(hoPerso()){
        socket.write("perso     ");
        _visualizzaMessaggioFineGioco(" PERSO !!!");
      }
      socket.write("colpito   $indice");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'B A T T L E - S H I P',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24.0),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: start && enemyStart
              ? _buildGiocoInCorsoGUI()
              : _buildPosizionamentoNaviGUI(),
        ),
      ),
    );
  }

  _HomePageState(String ip){
    connect(ip);
  }
}
class SelectIp extends StatelessWidget{
  String aaa= "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Server"),),
      body: Column(
        children: [
          TextField(onChanged: (value) {
            aaa=value;
          },),
          ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(ip: aaa) ));}, child: const Text("Connect")),
        ],
      ),
    );
    
  }

}