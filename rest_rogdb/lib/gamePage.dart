import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'connection.dart';


class GamePage extends StatefulWidget{
  late Gioco game;
  GamePage(this.game);
  @override
  State<StatefulWidget> createState() {
    return GamePageState(this.game);
  }
  
}

class GamePageState extends State<GamePage>{
  late Gioco game;

  GamePageState(this.game);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${game.nome}"), actions: [IconButton(onPressed: deleteGame, icon: const Icon(Icons.delete))],),
      body: ListView(
        
        children: [
          Image.network('http://${Connection.ipaddress}/www.r0g.com/sources/${getImg(game.mainImg!)}',height: 400, width: 100,fit: BoxFit.fitHeight,),
          const SizedBox(height: 40,),
          const Text("DESCRIZIONE:", textAlign: TextAlign.center,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.amber,
                width: 300,
                padding: const EdgeInsets.all(10),
                child: Text(game.descrizione!),
              ),
            ],
          )

        ],
      ),
    );
  }
  String getImg(String s){
    if(s=="" || s=="x"){
      return "image_not_available.jpg";
    }
    return s;
  }
  void deleteGame() async {
    bool resp = await Connection().deleteGame(game.id!);
    if(!resp){
      showError("something went wrong");
      return;
    }
    Navigator.pop(context);
  }

  void showError(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 200, 99, 92),
        content: Text(msg),
      )
    );
  }
  
}

