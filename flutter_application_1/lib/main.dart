import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  print("ooooahahah");
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: TextFieldExampleApp(),
  ));
}
late CalcolatoreIPAddress calculator;
class TextFieldExampleApp extends StatelessWidget {//prima pagina dell'app
  
  const TextFieldExampleApp({super.key});
  @override
  Widget build(BuildContext context) {
    
      return Scaffold(
        appBar: AppBar(title: const Text('Calcolatore di IP')),
        body: Column(children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
            child: TextFieldSampleIDIP(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
            child: TextFieldSampleNetMask(),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
              child: ElevatedButton(
                style: const ButtonStyle(),
                onPressed: (){
                  print("ooooahahah");
                  calculator.calculate();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TextFieldExampleApp2())
                  );
                },
                child: const Text('Roberto'),
              ))
        ]),
      
    );
  }
}
class TextFieldExampleApp2 extends StatelessWidget{//seconda pagina dell'app
    const TextFieldExampleApp2({super.key});
  @override
  Widget build(BuildContext context){
    
      return Scaffold(
        appBar: AppBar(title: const Text('ciao')),
        body: const Column(children: <Widget>[
          
        ]
          
        
      )
    );
    
  }

}

class TextFieldSampleIDIP extends StatefulWidget {
  const TextFieldSampleIDIP({super.key});
  @override
  Widget build(BuildContext context) {
    return throw Exception;
  }

  @override
  State<TextFieldSampleIDIP> createState() => _TextFieldExampleStateIDIP();
}

class _TextFieldExampleStateIDIP extends State<TextFieldSampleIDIP> {//stato per la prima barra per gli input
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    calculator = CalcolatoreIPAddress();
  }
  

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: TextField(
        obscureText: false,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Inserire ip address',
        ),
        controller: _controller,
        onChanged: (String value) async {
					calculator.setIpaddress(value);
        /*
        onSubmitted: (String value) async {
          calculator.setIpaddress(value);
          await showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Thanks!'),
                content: Text(
                    'You typed "$value", which has length ${value.characters.length}.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      //calculator.calculate(value);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        },*/
        }
      ),
    );
  }
}

class TextFieldSampleNetMask extends StatefulWidget {
  const TextFieldSampleNetMask({super.key});
  @override
  Widget build(BuildContext context) {
    return throw Exception;
  }

  @override
  State<TextFieldSampleNetMask> createState() =>
      _TextFieldExampleStateNetMask();
}

class _TextFieldExampleStateNetMask extends State<TextFieldSampleNetMask> {//stato della seconda barra per gli input
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    calculator = CalcolatoreIPAddress();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 120,
      child: TextField(
        obscureText: false,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Inserire netMask',
        ),
        controller: _controller,
        

        onChanged: (String value) async {
					calculator.setNetMask(value);
/*			onSubmitted:(String value)async{
          await showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Thanks!'),
                content: Text(
                    'You typed "$value", which has length ${value.characters.length}.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      //calculator.calculate(value);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        },*/
        }),
    );
  }
}

class CalcolatoreIPAddress {
    String ip = "";
    String originalNetMask = "";
    String netMask = "";

    void setIpaddress(String ip_){
      ip =ip_;
    }
    String getFirsInd(){
        String netId = getNetIp();
        return getIpSector(netId,0).toString()+"."+getIpSector(netId,1).toString()+"."+getIpSector(netId,2).toString()+"."+ (getIpSector(netId,3)+1).toString();
    }
    String getLastInd(){
        String netId = getBroadCast();
        return getIpSector(netId,0).toString()+"."+getIpSector(netId,1).toString()+"."+getIpSector(netId,2).toString()+"."+ (getIpSector(netId,3)-1).toString();
    }
    void setIP(String ip){
        this.ip = ip;
    }
    void setoriginaNetMask(String originalNetMask){
        this.originalNetMask = originalNetMask;
    }
    void setNetMask(String netMask){
        this.netMask = netMask;
    }
    String getBroadCast(){
        List<bool> netId = toBit(getNetIp());
        List<bool> mask = toBit(netMask);
        for (int i = 0; i < netId.length; i++) {
            if(!mask[i]) {
                netId[i] = !netId[i];
            }
        }

        return toIp(netId);
    }
    int getNBitMask(){
        int i = 0;
        for (bool b in toBit(netMask)) {
            if(b){
                i++;
            }
        }
        return i;
    }

    int getNBitHost(){
        int i = 0;
        for (bool b in toBit(netMask)) {
            if(!b){
                i++;
            }
        }
        return i;
    }
    int getNumHost(){
        return (pow(2,getNBitHost())-2).round();
    }
    int getNumSubNet(){
        int n = 0;
        List<bool> orMask = toBit(originalNetMask);
        List<bool> mask = toBit(netMask);

        for (int i = 0; i < orMask.length; i++) {
            if(orMask[i]!=mask[i]){
                n++;
            }
        }
        return pow(2,n).round();
    }
    String getNetIp(){
        List<bool> ip = toBit(this.ip);
        List<bool> mask = toBit(this.netMask);
        for (int i = 0; i < ip.length; i++) {
            ip[i] = ip[i] && mask[i];
        }
        return toIp(ip);

    }
    List<bool> toBit(String ip){
        List<bool> b = [];
        int num = getIpSector(ip,0);
        for (int i = 7; i >= 0; i--) {
            if(num>=pow(2,i)){
                b[7-i] = true;
                num-=pow(2,i).round();
            }else {
                b[7-i] = false;
            }
        }
        num = getIpSector(ip,1);
        for (int i = 7; i >= 0; i--) {
            if(num>=pow(2,i)){
                b[15-i] = true;
                num-=pow(2,i).round();
            }else {
                b[15-i] = false;
            }
        }
        num = getIpSector(ip,2);
        for (int i = 7; i >= 0; i--) {
            if(num>=pow(2,i)){
                b[23-i] = true;
                num-=pow(2,i).round();
            }else {
                b[23-i] = false;
            }
        }
        num = getIpSector(ip,3);
        for (int i = 7; i >= 0; i--) {
            if(num>=pow(2,i)){
                b[31-i] = true;
                num-=pow(2,i).round();
            }else {
                b[31-i] = false;
            }
        }
        return b;
    }
    String toIp(List<bool> bit){
        int ind = 0;
        String ip = "";
        for (int i = 0; i < 4; i++) {
            int seg = 0;
            for (int j = 7; j >= 0; j--) {
                seg += (bit[ind]? pow(2,j):0).round();
                ind++;
            }
            ip+=seg.toString()+".";
        }
        return ip.substring(0,ip.length-1);
    }
    void calculate(){
      print("aa");
    }

    int getIpSector(String ip, int indexNum){
        String sec = "";
        int pNum = 0;
        for (int i = 0; i < ip.length; i++) {


            if(ip[i] == '.'){
                pNum++;
            } else if (pNum==indexNum) {
                sec+=ip[i];
            }
            if (pNum>indexNum){
                break;
            }

        }
        return int.parse(sec);
    }
}