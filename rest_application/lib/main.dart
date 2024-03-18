// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      appBar: AppBar(title: const Text("REST client"),backgroundColor: const Color.fromARGB(255, 217, 234, 236),),
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
      final response = await http.get(Uri.parse('http://${textcontroller.text}/Rest.php?codice=')).timeout(const Duration(seconds: 5));
    }catch(e){
      showError("impossibile raggiungere server");
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder:(context) {return Page2(ipaddress: textcontroller.text); }));
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
    return Page2State(ipaddress: ipaddress);
  }
}

class Page2State extends State<Page2>{


  final String ipaddress;
  String nome = "";
  String cognome = "";
  String reparto = "";
  TextEditingController textcontroller = TextEditingController();
  TextStyle textStyle =const TextStyle(
    height: 2,
    fontSize: 18
  );

  Page2State({required this.ipaddress});

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
                onSubmitted: (value){fetchData(textcontroller.text);},
                decoration: const InputDecoration(
                  hintText: "code",
                  contentPadding: EdgeInsets.only(left: 30),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                ),
              ),
            ),
            IconButton(onPressed: (){fetchData(textcontroller.text);},
              highlightColor: const Color.fromARGB(255, 96, 138, 210),
              icon: const Icon(Icons.search_sharp))
          ],
        ),
      ),

      body: Center(
        child: SizedBox(
          height: 170,
          width: 300,
          child: Column(
            children: [
              Container(
                padding:const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 217, 234, 236),
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Row(children: [ Text("NOME:", style: textStyle,), const SizedBox(width: 50,), Text(nome)],),
              ),
              const SizedBox(height: 10,),
              Container(
                padding:const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 217, 234, 236),
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Row(children: [ Text("COGNOME:", style: textStyle,), const SizedBox(width: 13,),Text(cognome)],),
              ),
              const SizedBox(height: 10,),
              Container(
                padding:const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 217, 234, 236),
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Row(children: [ Text("REPARTO:", style: textStyle,), const SizedBox(width: 25,),Text(reparto)],),
              ),
            ],
          ),
        )
      ),
    );
    
  }

  Future<void> fetchData(String codice) async {
    try{
      final response = await http.get(Uri.parse('http://$ipaddress/Rest.php?codice=$codice'));
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['stato'] == 'ERRORE') {
          clearAll();
          showError("URL non valido");  
        } else if (jsonResponse['stato'] == 'OK-2') { 
          clearAll();
          showError("codice inesistente");
        } else {
          setState(() {
            nome = jsonResponse['nome'];
            cognome = jsonResponse['cognome'];
            reparto = jsonResponse['reparto'];
          });
        }
      } else {
        showError("impossibile caricare");
        throw Exception('Failed to load data');
      }
    }catch(e){
      print(e);
    }
  }
  void clearAll(){
    setState(() {
      nome = "";
      cognome = "";
      reparto = "";
    });
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
