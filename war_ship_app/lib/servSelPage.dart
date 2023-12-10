// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:war_ship_app/mapCustomizer.dart';
import 'main.dart';
import 'connection.dart';

class MapCustomizer extends StatefulWidget {
  State<MapCustomizer> createState() => MapCustomizerState();
}
class MapCustomizerState extends State<MapCustomizer>{
  String ipServer = "";

  void connectToSer() async{
    GridMap().init();
    
    Connection c = Connection();
    c.closeConnection();
    await c.startConnection(ipServer,9889);
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return Campo();
      }),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(171, 67, 163, 232),
        title: const Text("SERVER SELECTOR"),
      ),
      body: Center( child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 50,),
          const Text("inserisci IP server:"),
          SizedBox(width: 300, 
            height: 50,
            child: TextField(
            decoration:const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20, 20, 0, 20),
              hintText: "ip address",
              border:OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))
                
              )
            ),
            keyboardType:TextInputType.phone,
            onChanged: (value) {
              ipServer = value;
            },
            onSubmitted: (value) {connectToSer();},
            ),),
          const SizedBox(height: 50,),
          TextButton(
            onPressed: connectToSer, 
            
            style: const ButtonStyle(
              backgroundColor:MaterialStatePropertyAll(Color.fromARGB(255, 125, 194, 251)),
            ),
            child: const Text("Connect", style: TextStyle(color: Colors.black),),
            ),
        ],
      ),
      ) 
    );
  }
}