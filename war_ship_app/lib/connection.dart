import 'dart:io';
import 'dart:typed_data';
import 'main.dart';

class Connection{
  static Socket? s;
  static String ip = "";
  static bool ready = false;
  static bool myTurn = false;

  Future<void> startConnection(String ip, int port) async {
    Connection.ip = ip;
    s = await Socket.connect(ip, port);
    
    s?.listen((Uint8List data) async {
      String a = String.fromCharCodes(data);
      treatData(a);
    });
  }
  void sendMsg(String msgO){
    s?.write("$msgO\n");
  }

  void stopConnection(){
    s?.close();
  }
  void treatData(String input){
    if(input.length<3) return;
    int f =checkConc(input);
    
    String command = input.substring(0,3);
    String value = input.substring(3,f-1);
    switch(command){
      case "CON": //riconnettiti a ...
        stopConnection();
        startConnection(ip, int.parse(value));
        break;
      case "HIT": //mi hanno sparato
        int res = GridMap().getHit(value);
        print("        colpito re $res");
        States().setMyState();
        if(res == 3){
          States.gridState!.winDialog(false);
          print("perso");
          sendMsg("WIN$value");
        }else if(res==0){
          sendMsg("RSN$value");
        }else{
          sendMsg("RSP$value");
        }
        myTurn = true;
        States.gridState!.yourTurn();
        break;
      case "RSP": //risposta positiva
        GridMap().setEnemyCell(value, true);
        States().setEnemyState();
        break;
      case "RSN": //risposta negativa
        GridMap().setEnemyCell(value, false);
        States().setEnemyState();
        break;
      case "LGO":
        if(value == "1"){
          myTurn = true;
        }
        States().openGame();
      case "WIN":
        GridMap().setEnemyCell(value, true);
        States().setEnemyState();
        States.gridState!.winDialog(true);
        print("vinto!");
      case "EXT":
        States.gridState!.left();
    }
    treatData(input.substring(f+1));
  }
  void shoot(String key){
    GridMap.enemyGrid[key]!.isHit=true;
    sendMsg("HIT$key");
  }
  int checkConc(String value){
    print(value);
    int i = 0;
    for (var element in value.codeUnits) {
      if(String.fromCharCode(element) == '\n'){
        break;
      }
      i++;
    }
    return i;
  }
  void closeConnection(){
    try {
      s!.close();
    } catch (e) {
      print("ops");
    }
  }
}