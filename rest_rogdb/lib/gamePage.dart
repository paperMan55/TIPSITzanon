import 'package:flutter/material.dart';
import 'connection.dart';


class GamePage extends StatefulWidget{
  final Gioco game;
  const GamePage(this.game, {super.key});
  @override
  State<StatefulWidget> createState() {
    return GamePageState(game);
  }

}

class GamePageState extends State<GamePage> with TickerProviderStateMixin {
  late Gioco game;
  TextEditingController scontoController = TextEditingController();
  TextEditingController keyController = TextEditingController();
  late PageController _pageViewController;
  late TabController _tabController;
  int currentPageIndex = 0;

  GamePageState(this.game);

  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 2, vsync: this);
  }

  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${game.nome}"), actions: [IconButton(onPressed: deleteGame, icon: const Icon(Icons.delete))],),
      body: Stack(children: [
        PageView(
          /// [PageView.scrollDirection] defaults to [Axis.horizontal].
          /// Use [Axis.vertical] to scroll vertically.
          controller: _pageViewController,
          onPageChanged: _handlePageViewChanged,
          children: <Widget>[
            SizedBox(
              height: 500,
              child: gameInfo(),
            ),
            gameTools()
          ],
        ),
        PageIndicator(tabController: _tabController, currentPageIndex: currentPageIndex, onUpdateCurrentPageIndex: _updateCurrentPageIndex),

      ],)
    );
  }
  void setSconto(){
    
  }
  void addKey() async{
    bool a = await Connection().uploadKey("${game.id}", keyController.text);
    if(a){

    }else{
      showError("something went wrong...");
    }
  }

  String getImg(String s){
    if(s=="" || s=="x"){
      return "image_not_available.jpg";
    }
    return s;
  }
  void deleteGame() async {
    bool resp = await Connection().deleteGame(game.id!);
    if(!resp){
      showError("something went wrong");
      return;
    }
    Navigator.pop(context);
  }

  void showError(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 200, 99, 92),
        content: Text(msg),
      )
    );
  }
  Widget gameTools(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: scontoController,
                    keyboardType: TextInputType.number,
                    onSubmitted: (value){},
                    decoration: const InputDecoration(
                      hintText: "sconto",
                      contentPadding: EdgeInsets.only(left: 25),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                    ),
                  ),
                ),
              IconButton(onPressed: setSconto, icon: const Icon(Icons.publish_sharp))
              ],),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: keyController,
                    keyboardType: TextInputType.number,
                    onSubmitted: (value){},
                    decoration: const InputDecoration(
                      hintText: "KEY",
                      contentPadding: EdgeInsets.only(left: 25),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100.0)),)
                    ),
                  ),
                ),
              IconButton(onPressed: addKey, icon: const Icon(Icons.publish_sharp))
              ],)
        ],
      );
  }

  Widget gameInfo(){
    return ListView(
        
        children: [
          Image.network('http://${Connection.ipaddress}/www.r0g.com/sources/${getImg(game.mainImg!)}',height: 400, width: 100,fit: BoxFit.fitHeight,),
          const SizedBox(height: 40,),
          const Text("DESCRIZIONE:", textAlign: TextAlign.center,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.amber,
                width: 300,
                padding: const EdgeInsets.all(10),
                child: Text(game.descrizione!),
              ),
              Text("${game.dataPubblicazione}"),
              Text("${game.prezzo}€"),
              
            ],
          ),
          

        ],
      );
  }
   void _handlePageViewChanged(int currentPageIndex) {
    
    _tabController.index = currentPageIndex;
    setState(() {
      currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}


class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;

  @override
  Widget build(BuildContext context) {
    //  return const SizedBox.shrink();
    
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TabPageSelector(
            controller: tabController,
            color: colorScheme.background,
            selectedColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}


