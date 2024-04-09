// ignore_for_file: no_logic_in_create_state, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rest_rogdb/account.dart';

import 'connection.dart';
import 'login.dart';
import 'addgame.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      showSemanticsDebugger: false,
      title: 'REST',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:const  MyHomePage(title: 'REST test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<StatefulWidget> createState() {
    return MyHomePageState(title: title);
  }
}

class MyHomePageState extends State<MyHomePage>{
  MyHomePageState({required this.title});
  final String title;
  TextEditingController textcontroller = TextEditingController();
  
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: const Text("REST ROGdb"),backgroundColor: const Color.fromARGB(255, 217, 234, 236),),
      body: Center(
        child: SizedBox(
          width: 300,
          child: TextField(
            controller: textcontroller,
            onSubmitted: (value) {
              goToPage2();
            },
            decoration: const InputDecoration(
              hintText: "ip address",
              contentPadding: EdgeInsets.only(left: 30),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
            ),),
        ),
      ),
      floatingActionButton: IconButton(
        style: ButtonStyle(
          iconColor: MaterialStateColor.resolveWith((states) =>Colors.white),
          backgroundColor: MaterialStateColor.resolveWith((states) =>const Color.fromARGB(255, 217, 234, 236),)
        ),
        onPressed: (){
          goToPage2();
        },
        icon:const Icon(Icons.arrow_forward_ios_sharp)),
    );
  }
  void goToPage2() async{
    try{
      final response = await http.get(Uri.parse('http://${textcontroller.text}/Rest.php?codice=')).timeout(const Duration(seconds: 3));
    }catch(e){
      showError("impossibile raggiungere server");
      print("errore");
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder:(context) {return LoginPage(ipaddress: textcontroller.text); }));
  }

  void showError(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        backgroundColor: const Color.fromARGB(255, 200, 99, 92),
        content: Text(msg),
      )
    );
  }
}


class Page2 extends StatefulWidget{
  final String ipaddress;
  const Page2({super.key, required this.ipaddress});
  @override
  State<StatefulWidget> createState() {
    return Page2State(ipaddress);
  }
}

class Page2State extends State<Page2>{
  final String ipaddress;
  late Connection conn;
  Map<String,dynamic> utenti = {"response":0};
  String nome = "";
  String cognome = "";
  String reparto = "";
  TextEditingController textcontroller = TextEditingController();
  TextStyle textStyle =const TextStyle(
    height: 2,
    fontSize: 18
  );
  Page2State(this.ipaddress){
    conn = Connection(ipaddress);
    update();
    
  }
  void update(){
    Future(()async {
      
      String? mail = Account().getEmail();
      if(mail == null){
        showError("not Logged");
        return;
      }
      utenti = await conn.readGamesOf(mail); 
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 217, 234, 236),
        title: Row(
          children: [
            SizedBox(
              width: 220,
              child: TextField(
                controller: textcontroller,
                onSubmitted: (value){update();},
                decoration: const InputDecoration(
                  hintText: "code",
                  contentPadding: EdgeInsets.only(left: 30),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                ),
              ),
            ),
            IconButton(onPressed: (){update();},
              highlightColor: const Color.fromARGB(255, 96, 138, 210),
              icon: const Icon(Icons.search_sharp))
          ],
        ),
      ),

      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: listLength(),
          itemBuilder: (context, index) {
            return Column(
              
              children: [
                Container(
                  height: 100,
                  width: 350,
                  padding:const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 217, 234, 236),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Row(children: [ 
                    //se x o null allora fai altro, e devo scoprire come dare le misure
                    Image.network('http://$ipaddress/www.r0g.com/sources/${getImg(utenti["records"][index].mainImg)}',height: 100,width: 100,fit: BoxFit.fitWidth,),
                    
                    const SizedBox(width: 50,), 
                    Text(utenti["records"][index].nome)],),
                ),
                const SizedBox(height: 20,)
              ],
            );
          })
        
      ),
      floatingActionButton: IconButton( onPressed: goToAddPage, icon: const Icon(Icons.add)),
    );
  }

  void goToAddPage(){
    Navigator.push(context, MaterialPageRoute(
      builder:(context) {
        return AddPage(ipaddress: ipaddress); 
      })
    );
  }

  String getImg(String s){
    if(s=="" || s=="x"){
      return "image_not_available.jpg";
    }
    return s;
  }
  int listLength(){
    int ris = 0;
    try{
      ris = utenti["records"].length;
    }catch(e){
      print(" lol 0");
      return 0;
    }
    print("fatto $ris");
    return ris;
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


