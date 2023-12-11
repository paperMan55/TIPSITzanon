import 'package:flutter/material.dart';
import 'package:war_ship_app/connection.dart';
import 'main.dart';
import 'custom_icon_icons.dart';

class Game extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return GameState();
  }
}

class GameState extends State<Game>{
  void exit(){
    showDialog(context: context, builder: (_) => AlertDialog(
      title:const Text("Are you sure you want to leave the battlefield?"),
      actions: [
        TextButton(onPressed: realExit, child: const Text("yes")),
        TextButton(onPressed: (){}, child: const Text("nope")),
      ],
    ),
    barrierDismissible: true,
    );
  }
  void realExit(){
    Connection().sendMsg("EXT");
    Navigator.popUntil(context, (route) => route.isFirst);
  }
  @override
  Widget build(BuildContext context) {
    print( "dimensions ${GridMap.grid.keys.length}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Battle"),
        actions: [
          IconButton(onPressed: exit, icon:const Icon(Icons.exit_to_app_rounded))
        ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SizedBox(width: 400,height: 350,child: EnemyGrid()),
          SizedBox(width: 400,height: 350,child: Grid()),
        ],
      )
    );
  }
  Color getC(String key){
    if(GridMap.grid[key]!.isShip){
      return Colors.red;
    }
    return Colors.blue;
  }
}

class Grid extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return GridState();
  }
}
class GridState extends State<Grid>{
  
  @override
  Widget build(BuildContext context) {
    States.gridState = this;
    return CustomMultiChildLayout(
            delegate: _CascadeLayoutDelegate(),
            children: <Widget>[
              for (var key in GridMap.grid.keys)
                LayoutId(
                  id: key,
                  child:  SizedBox(
                    width: 30, height: 30,
                    child: IconButton(
                      style:ButtonStyle(backgroundColor:MaterialStatePropertyAll(getC(key)), shape:const MaterialStatePropertyAll(BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(1))))),
                      onPressed: (){ print("idk");setState(() {});}, 
                      icon: getHitIcon(key)), 
                  )
                ),
            ],
          );
  }
  Color getC(String key){
    if(GridMap.grid[key]!.isShip){
      return const Color.fromARGB(255, 121, 121, 121);
    }
    return Colors.blue;
  }
  Icon getHitIcon(String key){
    Cell? c =GridMap.grid[key];
    if(c!.isHit && c.isShip){
      return const Icon(CustomIcon.fire_station,size: 17);
    }else if(c.isHit){
      return const Icon(CustomIcon.water,size: 17);
    }
    return const Icon(CustomIcon.transparent,size: 17);
  }
  void winDialog(bool win){
    String msg = "";
    if(win){
      msg = "You won!!";
    }else{
      msg = "You lose :-(";
    }
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text(msg),
      actions: [
        TextButton(onPressed: exit, child: const Text("ok")),
      ],
    ),
    barrierDismissible: false,
    );
  }
  void left(){
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text("the other got scared and left."),
      actions: [
        TextButton(onPressed: exit, child: const Text("lol")),
      ],
    ),
    barrierDismissible: false,
    );
  }
  void yourTurn(){
    showDialog(context: context, builder: (_) => const AlertDialog(
      title:  Text("your turn!"),
    ),
    barrierDismissible: true,
    );
  }
  void exit(){
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}

class EnemyGrid extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return EnemyGridState();
  }
}
class EnemyGridState extends State<EnemyGrid>{
  @override
  Widget build(BuildContext context) {
    States.enemyGridState = this;
    return CustomMultiChildLayout(
            delegate: _CascadeLayoutDelegate(),
            children: <Widget>[
              for (var key in GridMap.grid.keys)
                LayoutId(
                  id: key,
                  child:  SizedBox(
                    width: 30, height: 30,
                    child: IconButton(
                      style:ButtonStyle(backgroundColor:MaterialStatePropertyAll(getC(key)), shape:const MaterialStatePropertyAll(BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(1))))),
                      onPressed: (){ shoot(key);setState(() {});}, 
                      icon:getHitIcon(key)),
                  )
                ),
            ],
          );
  }
  Color getC(String key){
    if(GridMap.enemyGrid[key]!.isShip){
      return const Color.fromARGB(255, 121, 121, 121);
    }
    return Colors.blue;
  }
  Icon getHitIcon(String key){
    Cell? c =GridMap.enemyGrid[key];
    if(c!.isHit && c.isShip){
      return const Icon(CustomIcon.fire_station,size: 17);
    }else if(c.isHit){
      return const Icon(CustomIcon.water,size: 17);
    }
    return const Icon(CustomIcon.transparent,size: 17);
  }
  void shoot(String key){
    if(GridMap.enemyGrid[key]!.isHit || !Connection.myTurn){
      return;
    }
    Connection.myTurn = false;
    Connection().shoot(key);
  }
}


class _CascadeLayoutDelegate extends MultiChildLayoutDelegate {
  _CascadeLayoutDelegate();
  static double sizeA = 31;
  

  @override
  void performLayout(Size size) {
    double offset = 0;

    for (var key in GridMap.grid.entries){
      layoutChild(key.key,const BoxConstraints());
      positionChild(key.key,Offset(int.parse(key.key.toString().substring(1))*sizeA , offset+ (key.key.toString().codeUnitAt(0)-65)*sizeA));
    }    
  }

  @override
  bool shouldRelayout(_CascadeLayoutDelegate oldDelegate) {
    return this != oldDelegate;
  }
}