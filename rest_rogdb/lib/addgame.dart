import 'package:flutter/material.dart';
import 'package:rest_rogdb/account.dart';

import 'connection.dart';


class AddPage extends StatefulWidget{
  const AddPage({super.key, });
  @override
  State<StatefulWidget> createState() {
    return AddPageState();
  }
}

class AddPageState extends State<AddPage>{
  late Connection conn;
  Map<String,dynamic> utenti = {"response":0};
  String nome = "";
  String cognome = "";
  String reparto = "";
  TextEditingController controllerN = TextEditingController();
  TextEditingController controllerDe = TextEditingController();
  TextEditingController controllerPr = TextEditingController();
  TextEditingController controllerD = TextEditingController();
  TextEditingController controllerSc = TextEditingController();
  TextStyle textStyle =const TextStyle(
    height: 2,
    fontSize: 18
  );
  AddPageState(){
    conn = Connection();
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 217, 234, 236),
        title: const Text("Game")
      ),

      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: controllerN,
              decoration: const InputDecoration(
                  hintText: "name",
                  contentPadding: EdgeInsets.only(left: 30),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                ),
            ),
            const SizedBox(height: 30,),
            TextField(
              controller: controllerDe,
              decoration: const InputDecoration(
                  hintText: "descrizione",
                  contentPadding: EdgeInsets.only(left: 30),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                ),
            ),
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                SizedBox(width: 150, child:TextField(
                keyboardType: TextInputType.number,
                controller: controllerPr,
                decoration: const InputDecoration(
                    
                    hintText: "prezzo",
                    contentPadding: EdgeInsets.only(left: 30),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                  ),
                ),),
                const SizedBox(height: 30,),
                SizedBox(width: 150, child: TextField(
                  keyboardType: TextInputType.number,
                  controller: controllerSc,
                  decoration: const InputDecoration(
                      hintText: "sconto",
                      contentPadding: EdgeInsets.only(left: 30),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                    ),
                  ),)
              ],
            ),
            const SizedBox(height: 30,),
            
            TextField(
              keyboardType: TextInputType.datetime,
              controller: controllerD,
              readOnly: true,
              onTap: () {showDateaPicker();},
              decoration: const InputDecoration(
                  hintText: "data",
                  
                  contentPadding: EdgeInsets.only(left: 30),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                ),
            ),
            TextButton(onPressed: upload, child: const Text("login"))
          ],
        )
        
      ),
    );
  }

  void upload() async{
    String? mail = Account().getEmail();
    if(mail == null){
      showError("not logged");
      return;
    }
    printYellow(controllerPr.text);
    bool res = await Connection().uploadGame(controllerN.text, controllerDe.text, controllerPr.text, controllerSc.text, mail, "x", controllerD.text);
    showError(res?"added":"not added");
  }

  void showDateaPicker() async{
    DateTime? date = await showDatePicker(context: context,
      initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.utc(DateTime.now().year+5)
    );
    if(date != null){
      controllerD.text = date.toString().split(" ")[0];
    }else if(controllerD.text == ""){
      controllerD.text = DateTime.now().toString().split(" ")[0];
    }
  }
  void printYellow(String msg){
    String a = "";
    for (var line in msg.split("\n")) {
      a+="\x1B[33m$line\x1B[0m\n";
    }
    print(a);
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