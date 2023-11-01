import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

/// Flutter code sample for [CustomMultiChildLayout].

void main() => runApp( Phoenix(child:MyApp()));


class MyApp extends StatefulWidget {
  
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp>{
  late Campo campo;
  @override
  Widget build(BuildContext context) {
    campo = Campo(context);
    return MaterialApp(
      home: Directionality(
        // TRY THIS: Try changing the direction here and hot-reloading to
        // see the layout change.
        textDirection: TextDirection.ltr,
        
        child: Scaffold(
          appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("CAMPO MINATO"),
          actions: [
            IconButton(onPressed: () => { Phoenix.rebirth(context) }, icon: Icon(Icons.replay_outlined)),

            ],
          ),
          body: campo,
        ),
      ),
    );
  }
}

/// Lays out the children in a cascade, where the top corner of the next child
/// is a little above (`overlap`) the lower end corner of the previous child.
///
/// Will relayout if the text direction changes.



class Campo extends StatefulWidget {
  late BuildContext context;
  Campo(BuildContext cont){
    context = cont;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CampoState(context);
  }
   
}
class CampoState extends State<Campo>{
   static String curS = "a";
   static int height = 15;
   static int width = 9;
   late BuildContext context;
   late List<List<CellProp>> cells;
   Buttons _colors = Buttons();

  int setNearBOmbxCasella(int i, int j) {
    int tot = 0;
    if (i - 1 >= 0 &&
        j - 1 >= 0 &&
        i - 1 < width &&
        j - 1 < height &&
        cells[i - 1][j - 1].IsBomb()) {
      tot++;
    }
    if (i - 1 >= 0 &&
        j >= 0 &&
        i - 1 < width &&
        j < height &&
        cells[i - 1][j].IsBomb()) {
      tot++;
    }
    if (i - 1 >= 0 &&
        j + 1 >= 0 &&
        i - 1 < width &&
        j + 1 < height &&
        cells[i - 1][j + 1].IsBomb()) {
      tot++;
    }
    if (i >= 0 &&
        j - 1 >= 0 &&
        i < width &&
        j - 1 < height &&
        cells[i][j - 1].IsBomb()) {
      tot++;
    }
    if (i >= 0 &&
        j + 1 >= 0 &&
        i < width &&
        j + 1 < height &&
        cells[i][j + 1].IsBomb()) {
      tot++;
    }
    if (i + 1 >= 0 &&
        j - 1 >= 0 &&
        i + 1 < width &&
        j - 1 < height &&
        cells[i + 1][j - 1].IsBomb()) {
      tot++;
    }
    if (i + 1 >= 0 &&
        j >= 0 &&
        i + 1 < width &&
        j < height &&
        cells[i + 1][j].IsBomb()) {
      tot++;
    }
    if (i + 1 >= 0 &&
        j + 1 >= 0 &&
        i + 1 < width &&
        j + 1 < height &&
        cells[i + 1][j + 1].IsBomb()) {
      tot++;
    }
    return tot;
  }
  
  
  CampoState(BuildContext cont){
    context = cont;
    cells = List.generate(width, (index) => List.generate(height, (index) => new CellProp(false, 3,context)));
  }

  @override
  Widget build(BuildContext context) {
    
    for (int i = 0; i < width; i++) {
      for (var j = 0; j < height; j++) {
        bool b = Random().nextInt(10) > 7;
        cells[i][j].setBomb(b);
      }
    }

    for (var i = 0; i < width; i++) {
      for (var j = 0; j < height; j++) {
        cells[i][j].setNum(setNearBOmbxCasella(i, j));
        _colors.addButt(i.toString()+"."+j.toString(), cells[i][j]) ; // per creare le varie istanze in seguito perche in altri modi non riesco
      }
    }

    

    return CustomMultiChildLayout(
      delegate: _CascadeLayoutDelegate(
        colors: _colors.getMap(),
        cells: cells,
        sizeC: CellProp.size_,
      ),
      children: <Widget>[
        // Create all of the colored boxes in the colors map.
        for (final MapEntry<String, CellProp> entry in _colors.getMap().entries)
          // The "id" can be any Object, not just a String.
    LayoutId(
        id: entry.key,
        child:  SizedBox(
          height: CellProp.size_,
          width: CellProp.size_,
          child: TextButton(

                style: ButtonStyle(
                    backgroundColor: getC(entry.key)),
                    onPressed:()=> pressed(entry.key),
                    onLongPress: () => longPressed(entry.key),
                  child: Text(entry.value.numBomb().toString()),
              ),
            ),
        ),
          
      ],
    );
  }
  
  void pressed(String id){
    Buttons b = Buttons();
    b.see(id);
  }
  void longPressed(String id){
    Buttons b = Buttons();
    b.flag(id);
  }

  MaterialStateProperty<Color> getC(String pos){
    // ignore: prefer_function_declarations_over_variables
    final col = (Set<MaterialState> st){
      return  Buttons().getColor(pos);
    };
    return MaterialStateProperty.resolveWith(col);
  }
}





class _CascadeLayoutDelegate extends MultiChildLayoutDelegate {
  _CascadeLayoutDelegate({
    required this.colors,
    required this.cells,
    required this.sizeC,
  });

  final Map<String, CellProp> colors;
  final List<List<CellProp>> cells;
  final double sizeC;
  // Perform layout will be called when re-layout is needed.
  @override
  void performLayout(Size size) {
    // First get the FlutterView.
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize;
    double width = size.width;


    double realSize = sizeC+1;
    double offs = (width - realSize*cells.length)/2;
    for (var i = 0; i < cells.length; i++) {
      for (var j = 0; j < cells[0].length; j++) {
        String id = i.toString()+"."+j.toString();
        layoutChild(id, BoxConstraints(maxHeight: realSize, maxWidth: realSize),
      );
      positionChild(id, Offset(40 + i*realSize,100 + j*realSize));
      }
    }
  }

  // shouldRelayout is called to see if the delegate has changed and requires a
  // layout to occur. Should only return true if the delegate state itself
  // changes: changes in the CustomMultiChildLayout attributes will
  // automatically cause a relayout, like any other widget.
  @override
  bool shouldRelayout(_CascadeLayoutDelegate oldDelegate) {
    return this != oldDelegate;
  }
}

class CellProp {
  static bool isCanceling = false;
  static double size_ = 30;
  final Color flaggedC = Colors.yellow;
  final Color bombedC = Colors.red;
  final Color normalC = Colors.blue;
  final Color seenC = const Color.fromARGB(255, 166, 213, 252);
  bool isFlagged = false;
  bool isSeen = false;
  bool isBomb = true;
  int numB = 0;
  late Color c;
  String t = "a";
  late BuildContext context;

  CellProp(bool isBomba, int num, BuildContext contextt) {
    isBomb = isBomba;
    numB = num;
    c = normalC;
    context = contextt;
  }
  bool IsBomb() {
    return isBomb;
  }

  int numBomb() {
    return numB;
  }

  void setNum(int n) {
    numB = n;
  }
  void setBomb(bool b) {
    isBomb = b;
  }
  Color getColor(){
    return c;
  }
  void setFlagged(bool f){
    isFlagged = f;
    if(f){
      c = flaggedC;
    }else{
      c = normalC;
    }
  }
  void cancel(){
    isCanceling = false;
    Phoenix.rebirth(context);
    
  }
  void see(){
    if(IsBomb()){
      print("bomb");
      c = bombedC;
      if(!isCanceling){
        isCanceling = true;
        Future.delayed(const Duration(seconds: 2),cancel);
      }
      
    }else{
      print(numBomb());
      c = seenC;
    }
  }
}

class Buttons{
  static Map<String,CellProp> buttonsProp = {};

  Map<String,CellProp> getMap(){
    return buttonsProp;
  }
  Color getColor(String pos){
    return buttonsProp[pos]!.getColor();
  }
  void addButt(String pos, CellProp p){
    buttonsProp[pos] = p;
  }
  void flag(String pos){
    
    buttonsProp[pos]!.setFlagged(!buttonsProp[pos]!.isFlagged);
    
  }

  void see(String pos){
    if(buttonsProp[pos]!.isFlagged) return;

    buttonsProp[pos]!.see();
  }
  @override
  String toString(){
    String s = "";
    for (var element in buttonsProp.entries) {
      s+=element.key + ": "+element.value.isBomb.toString()+" - ";
    }
    return s;
  }
  
}
