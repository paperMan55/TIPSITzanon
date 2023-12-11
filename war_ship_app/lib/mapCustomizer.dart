import 'package:flutter/material.dart';
import 'package:war_ship_app/custom_icon_icons.dart';
import 'package:war_ship_app/main.dart';
import 'connection.dart';
import 'gamePage.dart';


class Campo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CampoState();
  }
}

class CampoState extends State<Campo> {
  Map<String,bool> isPlaced = {"2":false,"31":false,"32":false,"4":false,"5":false};
  Color readyCol = const Color.fromARGB(255, 255, 122, 112);
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
    for (bool a in isPlaced.values) {
      if(!a){
        othShip();
        return;
      }
    }
    readyCol = const Color.fromARGB(255, 143, 229, 146);
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
        automaticallyImplyLeading: false,
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
              backgroundColor: getShipC("5"),
              onPressed: (){isPlacing="5";},
              child: const Text("5"),
            ),
          ),
          const SizedBox(width: 20,),
          SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              backgroundColor: getShipC("4"),
              onPressed: (){isPlacing="4";},
              child: const Text("4"),
            ),
          ),
          const SizedBox(width: 20,),
          SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              backgroundColor: getShipC("31"),
              onPressed: (){isPlacing="31";},
              child: const Text("3"),
            ),
          ),
          const SizedBox(width: 20,),
          SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              backgroundColor: getShipC("32"),
              onPressed: (){isPlacing="32";},
              child: const Text("3"),
            ),
          ),
          const SizedBox(width: 20,),
          SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              backgroundColor: getShipC("2"),
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
              backgroundColor: readyCol,
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
  Color getShipC(String key){
    if(isPlaced[key]!){
      return const Color.fromARGB(255, 143, 229, 146);
    }
    return const Color.fromARGB(255, 255, 122, 112);
  }
  void othShip(){
    showDialog(context: context, builder: (_) =>const  AlertDialog(
      title: Text("you need to place all the ships."),
    ),
    barrierDismissible: true,
    );
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