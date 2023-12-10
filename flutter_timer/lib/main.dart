import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  runApp(const MyApp());
}
class Cronometro{
  static int millisInterval = 100;
  static Stream cron = Stream.periodic(Duration(milliseconds: millisInterval));
  void restart(){
    cron = Stream.periodic(Duration(milliseconds: millisInterval));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paper_man',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Chrono'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static bool going = false;
  static String exTime = "0:0:0.0";
  static int hours = 0;
  static int minuts = 0;
  static double seconds = 0;
  static bool reverse = false;
  static double endP = 0;
  late StreamSubscription sub;
  Color mainC = const Color.fromARGB(255, 0, 0, 0);
  Color secondC = const Color.fromARGB(255, 179, 179, 179) ;

  void startCron() {
    if(going) return;
    Cronometro().restart();
    going = true;
    sub = Cronometro.cron.listen((event) { setState(() {
      seconds+=Cronometro.millisInterval/1000;
      if(seconds>60){
        minuts++;
        seconds = seconds-60;
      }
      if(minuts>60){
        hours++;
        minuts = 0;
      }
      double p = seconds-seconds.floor();
      reverse = seconds.floor()%2 == 0;
      if(reverse){
        endP =  p;
      }else{
        endP = 1-p;
      }
    });});
  }
  void stopCron() {
    sub.cancel();
    exTime = "$hours:$minuts:${seconds.toStringAsFixed(1)}";
    seconds = 0;
    minuts = 0;
    hours = 0;
    going = false;
    setState(() {
    });
  }
  void pauseCron(){
    sub.cancel();
    going = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: 

        Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(exTime),
            CircularPercentIndicator(
              reverse: reverse,
              radius: 100,
              center: Text("$hours:$minuts:${seconds.toStringAsFixed(1)}",style: Theme.of(context).textTheme.headlineMedium,),
              percent: endP,
              progressColor: mainC,
              backgroundColor: secondC,
              restartAnimation: true,
              animateFromLastPercent: true,
              animation: true,
              animationDuration: 90,

            ),

          ],
        ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(onPressed: pauseCron, icon: const Icon(Icons.pause_circle_outline_sharp),iconSize: 50,),
                  IconButton(onPressed: startCron, icon: const Icon(Icons.play_circle_outline_sharp),iconSize: 80,),
                  IconButton(onPressed: stopCron, icon: const Icon(Icons.stop_circle_outlined),iconSize: 50,),
                ],
              ),
  
    );
  }
  MaterialStateProperty<Color> getMainC(String pos){
    // ignore: prefer_function_declarations_over_variables
    final col = (Set<MaterialState> st){
      if(seconds.floor()%2 == 0){
        return Colors.black;
      }
      return Colors.black12;
    };
    return MaterialStateProperty.resolveWith(col);
  }
  MaterialStateProperty<Color> getSecondC(String pos){
    // ignore: prefer_function_declarations_over_variables
    final col = (Set<MaterialState> st){
      if(seconds.floor()%2 == 0){
        return Colors.black12;
      }
      return Colors.black;
    };
    return MaterialStateProperty.resolveWith(col);
  }
}
