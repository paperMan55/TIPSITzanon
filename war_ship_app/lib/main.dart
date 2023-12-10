import 'package:flutter/material.dart';
import 'package:war_ship_app/gamePage.dart';
import 'package:war_ship_app/mapCustomizer.dart';
import 'servSelPage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MapCustomizer(),
    );
  }
}



/*
1x 5
1x 4
2x 3
1x 2
map 10x10
*/


class GridMap{
  static Map<String,Cell> grid = <String,Cell>{};
  static Map<String,Cell> enemyGrid = <String,Cell>{};
  static Map<String,Ship> ships = {};
  void init(){
    ships = {"2":Ship(2,"2"),"31":Ship(3,"31"),"32":Ship(3,"32"),"4":Ship(4,"4"),"5":Ship(5,"5")};
    for(int i=0;i<10;i++){
      for(int j=1;j<=10;j++){
        grid["${String.fromCharCode(65+i)}$j"] = Cell();
        enemyGrid["${String.fromCharCode(65+i)}$j"] = Cell();
      }
    }
  }

  bool place(String key,String id, bool vertical){
    List<Cell?> cells = [];
    int? len = ships[id]?.lifes;
    Ship ship = ships[id]!;
    if(check(key, len!, vertical)){
      String ke = "";
      if(vertical){
        for(int i=0;i<len;i++){
          ke = "${String.fromCharCode(key.toString().codeUnitAt(0)-i)}${x(key)}";
          grid[ke]?.isShip = true;
          grid[ke]?.ship = ship;
          cells.add(grid[ke]);
        }
      }else{
        for(int i=0;i<len;i++){
          ke = "${key.toString().substring(0,1)}${x(key)+i}";
          grid[ke]?.isShip = true;
          grid[ke]?.ship = ship;
          cells.add(grid[ke]);  
        }
      }
      ship.setLifes(len);
      ship.setCells(cells);
      return true;
    }
    return false;
  }

  int getHit(String key){
    int tmp = grid[key]!.hit();
    if(checkDeath()){
      return 3;
    }
    return tmp;
  }

  bool check(String key,int len, bool vertical){ 
    if(vertical){
      for(int i=0;i<len;i++){
        if(y(key)-i<0 || grid["${String.fromCharCode(key.toString().codeUnitAt(0)-i)}${x(key)}"]!.isShip){
          print("nope");
          return false;
        }
      }
    }else{
      for(int i=0;i<len;i++){
        if(x(key)+i>10 || grid["${key.toString().substring(0,1)}${x(key)+i}"]!.isShip){
          print("nope");
          return false;
        }
      }
    }
    print("yes");
    return true;
  }
  int x(String key){
    return int.parse(key.toString().substring(1));
  }
  int y(String key){
    return key.toString().codeUnitAt(0)-65;
  }
  void setEnemyCell(String key, bool isShip){
    enemyGrid[key]!.isHit = true;
    enemyGrid[key]!.isShip = isShip;
  }
  bool checkDeath(){
    for (var element in ships.values) {
      if(!element.isDead() && element.cells.isNotEmpty){
        return false;
      }
    }
    return true;
  }
  void removeShipByShip(String shipId){
    for (var element in ships[shipId]!.cells) {
      element!.ship!.cells=[];
      element.isShip = false;
      element.ship = null;
    }
  }
  void removeShipByCell(String cellId){
    if(!grid[cellId]!.isShip) return;
    removeShipByShip(grid[cellId]!.ship!.id);
  }
}

class Cell{
  bool isShip = false;
  bool isHit = false;
  Ship? ship;
  int hit(){
    isHit = true;
    if(!isShip){
      return 0; // se barca mancata
    }
    bool? aff = ship?.hit();
    print("barca affondata $aff");
    if(aff!=null && aff){
      return 2; // se barca affondata
    }
    return 1; // se barca colpita
  }
}

class Ship{
  List<Cell?> cells = [];
  int lifes = 0;
  int hits = 0;
  String id = "";

  Ship(this.lifes,this.id);

  void setLifes(int l){
    lifes = l;
  }
  void setCells(List<Cell?> cells){
    this.cells = cells;
  }
  bool hit(){
    hits++;
    if(hits == lifes){
      return true;
    }
    return false;
  }
  bool isDead(){
    return hits == lifes;
  }
}

class States {
  static GridState? gridState;
  static EnemyGridState? enemyGridState;
  static CampoState? campoState;

  void setEnemyState(){
    enemyGridState!.setState(() {});
  }
  void setMyState(){
    gridState!.setState(() {});
  }
  void openGame(){
    campoState!.goToGame();
  }
}