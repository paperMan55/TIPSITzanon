import 'package:flutter/material.dart';
import 'package:rest_rogdb/account.dart';

import 'connection.dart';


class RegisterPage extends StatefulWidget{
  const RegisterPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage>{
  late Connection conn;
  Map<String,dynamic> utenti = {"response":0};
  TextEditingController controllerMail = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerSede = TextEditingController();
  TextEditingController controllerPass = TextEditingController();
  TextEditingController controllerRepe = TextEditingController();
  TextStyle textStyle =const TextStyle(
    height: 2,
    fontSize: 18
  );
  RegisterPageState(){
    conn = Connection();
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 217, 234, 236),
        title: const Text("Register")
      ),

      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: controllerMail,
              decoration: const InputDecoration(
                  hintText: "e_mail",
                  contentPadding: EdgeInsets.only(left: 30),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                ),
            ),
            const SizedBox(height: 30,),
            TextField(
              controller: controllerName,
              decoration: const InputDecoration(
                  hintText: "name",
                  contentPadding: EdgeInsets.only(left: 30),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                ),
            ),
            const SizedBox(height: 30,),
            TextField(
              controller: controllerSede,
              decoration: const InputDecoration(
                  hintText: "sede",
                  contentPadding: EdgeInsets.only(left: 30),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                ),
            ),
            const SizedBox(height: 30,),
            
            TextField(
              controller: controllerPass,
              obscureText: true,
              obscuringCharacter: "☻",
              decoration: const InputDecoration(
                  hintText: "password",

                  contentPadding: EdgeInsets.only(left: 30),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                ),
            ),
            const SizedBox(height: 30,),
            TextField(
              controller: controllerRepe,
              obscureText: true,
              obscuringCharacter: "☻",
              decoration: const InputDecoration(
                  hintText: "repeat password",
                  contentPadding: EdgeInsets.only(left: 30),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                ),
            ),
            TextButton(onPressed: upload, child: const Text("register"))
          ],
        )
        
      ),
    );
  }

  void upload() async{
    var conn = Connection();
    if(controllerPass.text == controllerRepe.text){
      bool res = await conn.register(controllerMail.text, controllerName.text, controllerSede.text, controllerPass.text);
      if(!res){
        showError("something is wrong");
      }else{
        Account.e_mail = controllerMail.text;
        Account.name = controllerName.text;
        Account.sede = controllerSede.text;
        Navigator.pop(context);
      } 
    }else{
      showError("passwords are not the same");
    }
    
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