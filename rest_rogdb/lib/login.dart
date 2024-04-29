import 'package:flutter/material.dart';
import 'package:rest_rogdb/account.dart';
import 'package:rest_rogdb/register.dart';
import 'main.dart';
import 'connection.dart';


class LoginPage extends StatefulWidget{
  const LoginPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage>{
  late Connection conn;
  Map<String,dynamic> utenti = {"response":0};
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  TextStyle textStyle =const TextStyle(
    height: 2,
    fontSize: 18
  );
  LoginPageState(){
    conn = Connection();
    
  }
  void login(){
    Future(()async {
      utenti = await conn.login( mailcontroller.text,passwordcontroller.text);
      
      if(utenti["response"] == 200){
        
        Account account = Account();
        account.setName( utenti["records"][0].name);
        account.setEmail( utenti["records"][0].mail);
        account.setSede( utenti["records"][0].sede);
        
        Navigator.push(context, MaterialPageRoute(builder: (context){return Page2();}));
      }else if(utenti["response"] == 400){
        showError("password sbagliata");
      }else{
        showError("account inesistente");
      }
      
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 217, 234, 236),
        title: const Text("LOGIN")
      ),

      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(40),
          children: [
            const Icon(Icons.person, size: 100,),
            const SizedBox(height: 10,),
            TextField(
              
              controller: mailcontroller,
              decoration: const InputDecoration(
                  hintText: "e_mail",
                  contentPadding: EdgeInsets.only(left: 30),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)),)
                ),
            ),
            const SizedBox(height: 30,),
            TextField(
              obscureText: true,
              obscuringCharacter: '☻',
              controller: passwordcontroller,
              decoration: const InputDecoration(
                  hintText: "password",
                  contentPadding: EdgeInsets.only(left: 30),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)),)
                ),
            ),
            const SizedBox(height: 70,),
            ElevatedButton(style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith((states) =>const Color.fromARGB(255, 255, 255, 255)),
              backgroundColor: MaterialStateColor.resolveWith((states) =>const Color.fromARGB(255, 0, 0, 0))), 
                onPressed: login, child: const Text("login")
            ),
            TextButton(onPressed: logout, child: const Text("logout")),
            TextButton(onPressed: register, child: const Text("register"))
          ],
        )
        
      ),
    );
  }
  void logout(){
    Account.e_mail = null;
    Account.name = null;
    Account.sede = null;
  }
  void register(){
    Navigator.push(context, MaterialPageRoute(builder: (context){return RegisterPage();}));
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