// ignore_for_file: no_logic_in_create_state, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rest_rogdb/account.dart';
import 'package:rest_rogdb/model.dart';

import 'connection.dart';
import 'login.dart';
import 'addgame.dart';
import 'gamePage.dart';
import 'dao.dart';
import 'database.dart';

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
        colorScheme: ColorScheme.fromSeed(
          background: const Color.fromARGB(255, 219, 219, 219), 
          seedColor: const Color.fromARGB(255, 2, 2, 2),
        ),
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
    return MyHomePageState(title);
  }
}

class MyHomePageState extends State<MyHomePage>{
  bool secondFase = false;
  double heightSize = 400;
  final String title;
  bool remember = false;
  List<Server> servers = [];
  TextEditingController textcontroller = TextEditingController();

  MyHomePageState( this.title){
    Future(() async{
      TodoDao dao = await getDao();
      servers = await dao.getServers();
      setState(() {});
    },);
    Future.delayed(const Duration(seconds: 3),
    (){
      setState(() {
        heightSize = 200;
        secondFase = true;
      });
    }
    );
  }
  
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(actions: [
        DropdownButton(
            hint: const Text("servers"),
            icon: const Icon(Icons.link),
            items: servers.map<DropdownMenuItem<Server>>((Server value) {
            return DropdownMenuItem<Server>(
              value: value,
              child: Text(value.ipaddress),
            );
          }).toList(), 
          onChanged: (value){
            textcontroller.text = value!.ipaddress;
          })
      ]),
      body: ListView(
        children: [
          const SizedBox(height: 70,),
          AnimatedContainer(duration: const Duration(milliseconds: 1000),
            height: heightSize,
            width: 500,
            curve: Curves.easeIn,
            child: Image.asset("images/LogoAnim.gif", fit: BoxFit.fitHeight,),
            
          ),
          const SizedBox(height: 70,),
          Center(
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
                //border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)),)
              ),),
          ),
        ),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Checkbox(value: remember, onChanged: (value){setState(() {
          remember = !remember;
        });}),const Text("remember me")],
        )
        
        ],
      ),
      floatingActionButton: IconButton(
        style: ButtonStyle(
          iconColor: MaterialStateColor.resolveWith((states) =>const Color.fromARGB(255, 0, 0, 0)),
        ),
        onPressed: (){
          goToPage2();
        },
        icon:const Icon(Icons.arrow_circle_right_outlined, size: 50,)),
    );
  }

  void goToPage2() async{
    try{
      await http.get(Uri.parse('http://${textcontroller.text}/Rest.php')).timeout(const Duration(seconds: 3));
    }catch(e){
      showError("impossibile raggiungere server");
      print("errore");
      return;
    }
    Connection.ipaddress = textcontroller.text;
    if(remember){
      TodoDao dao = await getDao();
      dao.insertServer(Server(ipaddress: textcontroller.text));
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) {return const Page2(); })).then((value) {setState(() {});});
  }
  Future<TodoDao> getDao() async {
    AppDatabase database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    return database.todoDao;
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
  const Page2({super.key});
  @override
  State<StatefulWidget> createState() {
    return Page2State();
  }
}

class Page2State extends State<Page2>{
  late Connection conn;
  late TodoDao dao;

  Map<String,dynamic> utenti = {"response":0};
  TextEditingController textcontroller = TextEditingController();
  TextStyle textStyle =const TextStyle(
    height: 2,
    fontSize: 18
  );
  Page2State(){
    getDao();
    conn = Connection();
    update();
    
  }
  Future<void> getDao() async {
    AppDatabase database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    dao = database.todoDao;
  }

  void update(){
    Future(()async {
      
      String? mail = Account().getEmail();
      if(mail == null){
        setState(() {});
        return;
      }
      
      utenti = await conn.readGamesOf(mail, textcontroller.text); 
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 217, 234, 236),
        title: Row(
          children: [
            SizedBox(
              width: 220,
              child: TextField(
                controller: textcontroller,
                onSubmitted: (value){update();},
                decoration: const InputDecoration(
                  hintText: "search",
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
        actions: [IconButton(onPressed: goToLogin, icon: const Icon(Icons.account_circle_rounded))],
      ), 
      body: (Account().getEmail() == null?notLogged():gameList()),
      floatingActionButton: getAddButton(),
    );
  }

  Widget? getAddButton(){
    if(Account().getEmail() != null){
      return IconButton( onPressed: goToAddPage, icon: const Icon(Icons.add));
    }
    return null;
  }

  Widget notLogged(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_off_outlined,size: 200,),
          const Text("You need to"),
          TextButton(onPressed: goToLogin, child: const Text("login")),
        ],
      ),
    );
  }

  Widget gameList(){
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: listLength(),
      itemBuilder: (context, index) {
        return Column(
          
          children: [
            GestureDetector(
              onTap: () {
                goToGame(utenti["records"][index].id,
                utenti["records"][index]);
              },
              child: SizedBox(
                height: 100,
                width: 350,
                
                //padding:const EdgeInsets.all(10),
                /*decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 181, 181, 181),
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),*/
                child: Card(
                  
                  shadowColor: Colors.black,
                  child: Padding(padding: const  EdgeInsets.all(8), 
                    child: Row(children: [ 
                    
                    Image.network('http://${Connection.ipaddress}/www.r0g.com/sources/${getImg(utenti["records"][index].mainImg)}',height: 100,width: 100,fit: BoxFit.fitHeight,),
                    
                    const SizedBox(width: 20,),
                    Column(
                      children: [
                        Text(getName(utenti["records"][index].nome),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                        const SizedBox(height: 15,),
                        getScontato(utenti["records"][index])
                        
                      ],
                    ),
                    ],),
                    )
                  )
              ),
            ),
            const SizedBox(height: 20,)
          ],
        );
      });
  }
  Widget getScontato(Gioco game){
    if(game.sconto!=0){
      double scontato = game.prezzo! - (game.prezzo! * game.sconto! / 100);

      return Row(children: [
            Text('${game.prezzo}', style:  (game.sconto != 0?const TextStyle(decoration: TextDecoration.lineThrough):null),),
            const SizedBox(width: 5,),
            Text("$scontato€")
          ],);
    }
    return Text('${game.prezzo}€');
  }
  String getName(String name){
    if(name.length>22){
      return "${name.substring(0,21)}...";
    }
    return name;
  }

  void goToAddPage(){
    Navigator.push(context, MaterialPageRoute(builder:(context) {return const AddPage(); })).then((value) {update();});
  }
  void goToLogin(){
    Navigator.push(context, MaterialPageRoute(builder:(context) {return const LoginPage(); })).then((value) {update();});
  }
  void goToGame(int id, Gioco a){
    Navigator.push(context, MaterialPageRoute(builder:(context) {return GamePage(a); })).then((value) {update();});
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

