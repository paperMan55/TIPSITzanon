import 'package:flutter/material.dart';
import 'package:war_ship_app/custom_icon_icons.dart';
import 'package:war_ship_app/main.dart';
import 'connection.dart';
import 'gamePage.dart';

class LobbySelection extends StatefulWidget {
  const LobbySelection({super.key, required this.title, required this.servIp});
  final String title;
  final String servIp;

  @override
  State<LobbySelection> createState() => _LobbySelectionState(servIp);
}

class _LobbySelectionState extends State<LobbySelection> {
  _LobbySelectionState(String indIp){
    ip = indIp;
  }

  String msg = "waiting";
  String ip = "";
  void _incrementCounter() async {
    /*
    Connection c = Connection();
    await c.startConnection(ip,9889);
    */
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return Campo();
      }),
    );

  }
  void check(){
    Connection().sendMsg("ambrogio");
  }
  @override
  Widget build(BuildContext context) {
    GridMap().init();
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
        title: Text(widget.title),
      ),
      body: Center(
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'msg:',
            ),
            Text(
              msg,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      
      floatingActionButton: Row(
        children: [
          Image.asset("lib/images/zpp4.png", width: 100),
          const SizedBox(width: 100),
          SizedBox(
            key:const Key("aaa"),
            width: 100,
            child: FloatingActionButton(
              onPressed: check,
              tooltip: 'stupido',
              child: const Text("send MSG"),
            ),
          ),
          SizedBox(
            key:const Key("bbb"),
            width: 100,
            child: FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'connect',
              child: const Text("Connect"),
            ),
          ),
        ],
      ),
    );
  }
}


class Campo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CampoState();
  }
}

class CampoState extends State<Campo> {
  Map<String,bool> isPlaced = {"2":false,"31":false,"32":false,"4":false,"5":false};

  String isPlacing = "";
  bool placeVertical = true;
  String goText = "PRONTO";

  void place(String key){
    if(GridMap.grid[key]!.isShip){
      isPlaced[GridMap.grid[key]!.ship!.id] = false;
      GridMap().removeShipByCell(key);
      return;
    }
    if(isPlaced[isPlacing]!){
      return;
    }
    bool res = GridMap().place(key, isPlacing, placeVertical);
    if(res){
      isPlaced[isPlacing] = true;
    }
  }
  void goToGame(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return Game();
      }),
      
    );
  }
  void getReady(){
    goText = "waiting..";
    Connection().sendMsg("RDY");
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    GridMap();
    States.campoState = this;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title:const Text("antonio"),
      ),
      body: CustomMultiChildLayout(
      delegate: _CascadeLayoutDelegate(),
      children: <Widget>[
        for (var entries in GridMap.grid.entries)

          LayoutId(
            id: entries.key,
            child:SizedBox( 
              width: 30,
              height: 30,
              child: IconButton(
                style:ButtonStyle(backgroundColor:MaterialStatePropertyAll(getC(entries.key)), shape:const MaterialStatePropertyAll(BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(1))))),
                onPressed: (){place(entries.key); setState(() {});} , 
                icon:const Icon(CustomIcon.transparent)),
            ),
          ),
      ],
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(                                              // ship selection
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              onPressed: (){isPlacing="5";},
              child: const Text("5"),
            ),
          ),
          const SizedBox(width: 20,),
          SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              onPressed: (){isPlacing="4";},
              child: const Text("4"),
            ),
          ),
          const SizedBox(width: 20,),
          SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              onPressed: (){isPlacing="31";},
              child: const Text("3"),
            ),
          ),
          const SizedBox(width: 20,),
          SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              onPressed: (){isPlacing="32";},
              child: const Text("3"),
            ),
          ),
          const SizedBox(width: 20,),
          SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              onPressed: (){isPlacing="2";},
              child: const Text("2"),
            ),
          ),
          ],
        ),
        const SizedBox(height: 20,),
        Row(                                              // orientation & other
        children: [
          const SizedBox(width: 100),
          SizedBox(
            width: 100,
            child: FloatingActionButton(
              onPressed: getReady,
              child: Text(goText),
            ),
          ),
          SizedBox(
            width: 100,
            child: FloatingActionButton(
              onPressed: (){placeVertical  = !placeVertical;setState(() {});},
              child: getOrientIcon(),
            ),
          ),
        ],
      ),
      ],
    )
    );
  }
  Icon getOrientIcon(){
    if(placeVertical){
      return const Icon(Icons.arrow_upward_rounded);
    }
    return const Icon(Icons.arrow_forward_rounded);
  }
  Color getC(String key){
    if(GridMap.grid[key]!.isShip){
      return Colors.red;
    }
    return Colors.blue;
  }
  
}

class _CascadeLayoutDelegate extends MultiChildLayoutDelegate {
  _CascadeLayoutDelegate();
  static double sizeA = 31;
  

  @override
  void performLayout(Size size) {
      for (var entries in GridMap.grid.entries){
        layoutChild(entries.key,const BoxConstraints());
        positionChild(entries.key,Offset(int.parse(entries.key.toString().substring(1))*sizeA, (entries.key.toString().codeUnitAt(0)-65)*sizeA));
      }    
  }

  
  @override
  bool shouldRelayout(_CascadeLayoutDelegate oldDelegate) {
    return this != oldDelegate;
  }
}