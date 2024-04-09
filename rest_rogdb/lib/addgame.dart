import 'package:flutter/material.dart';
import 'package:rest_rogdb/account.dart';
import 'main.dart';
import 'connection.dart';


class AddPage extends StatefulWidget{
  final String ipaddress;
  const AddPage({super.key, required this.ipaddress});
  @override
  State<StatefulWidget> createState() {
    return AddPageState(ipaddress);
  }
}

class AddPageState extends State<AddPage>{
  final String ipaddress;
  late Connection conn;
  Map<String,dynamic> utenti = {"response":0};
  String nome = "";
  String cognome = "";
  String reparto = "";
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextStyle textStyle =const TextStyle(
    height: 2,
    fontSize: 18
  );
  AddPageState(this.ipaddress){
    conn = Connection(ipaddress);
    
  }
  void login(){
    Future(()async {
      utenti = await conn.login( mailcontroller.text,passwordcontroller.text);
      
      if(utenti["response"] == 200){
        
        Account account = Account();
        
        account.setName( utenti["records"][0].name);
        
        account.setEmail( utenti["records"][0].mail);
        account.setSede( utenti["records"][0].sede);
        Navigator.push(context, MaterialPageRoute(builder: (context){return Page2(ipaddress: ipaddress);}));
      }
      
      
    });
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
              controller: mailcontroller,
              decoration: const InputDecoration(
                  hintText: "name",
                  contentPadding: EdgeInsets.only(left: 30),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                ),
            ),
            const SizedBox(height: 30,),
            TextField(
              controller: passwordcontroller,
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
                controller: passwordcontroller,
                decoration: const InputDecoration(
                    hintText: "prezzo",
                    contentPadding: EdgeInsets.only(left: 30),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                  ),
                ),),
                const SizedBox(height: 30,),
                SizedBox(width: 150, child: TextField(
                  controller: passwordcontroller,
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
              controller: passwordcontroller,
              decoration: const InputDecoration(
                  hintText: "data",
                  contentPadding: EdgeInsets.only(left: 30),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                ),
            ),
            TextButton(onPressed: login, child: const Text("login"))
          ],
        )
        
      ),
    );
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