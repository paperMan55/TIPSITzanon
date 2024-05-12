// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';


class Connection{
  static String ipaddress = "";
  

  Connection();
  
  Future<Map<String,dynamic>> readGamesOf(String e_mail, String searched) async {
    Map<String,dynamic> jsonResponse = {};
    try{
      final response = await http.get(Uri.parse('http://$ipaddress/ServerRest/readGamesOf.php?mail=$e_mail&&cercato=$searched'));
      
      if (response.statusCode == 200) {
        final editori = giochiFromJson(response.body);

        jsonResponse["records"] = editori.records;
      } else {
        throw Exception('Failed to load data');

      }
      jsonResponse["response"] = response.statusCode;
    }catch(e){
      print(e);
    }
    return jsonResponse;
  }
  
  Future<Map<String,dynamic>> readKeysOf(String game_id) async {
    Map<String,dynamic> jsonResponse = {};
    try{
      final response = await http.get(Uri.parse('http://$ipaddress/ServerRest/readKeyOf.php?game_id=$game_id'));
      if (response.statusCode == 200) {
        final keys = keysListFromJson(response.body);
        jsonResponse["records"] = keys.records;
      } else {
        throw Exception('Failed to load data');

      }
      jsonResponse["response"] = response.statusCode;
    }catch(e){
      print(e);
    }
    return jsonResponse;
  }


  Future<Map<String,dynamic>> readGame(String id) async{
    Map<String,dynamic> jsonResponse = {};
    try{
      final response = await http.get(Uri.parse('http://$ipaddress/ServerRest/readGamesOf.php'));
      if (response.statusCode == 200) {
        final editori = giochiFromJson(response.body);
        jsonResponse["records"] = editori.records;
      } else {
        throw Exception('Failed to load data');
      }
      jsonResponse["response"] = response.statusCode;
    }catch(e){
      print(e);
    }
    return jsonResponse;
  }
  Future<bool> uploadKey(String game_id, String key)async{
    
    try{
      Map<String,String> data = {"game_id":game_id,
        "key":key};
      final response = await http.post(Uri.parse('http://$ipaddress/ServerRest/createKey.php'),body: jsonEncode(data));
      if (response.statusCode == 200) {
        return true;
      } else if(response.statusCode == 400){
        return false;
      }else{
        return false;
      }
    }catch(e){
      print(e);
      return false;
    }
  }
  Future<bool> deleteKey(String key)async{
    try{
      Map<String,String> data = {
        "key":key};
      final response = await http.post(Uri.parse('http://$ipaddress/ServerRest/deleteKey.php'),body: jsonEncode(data));
      printYellow(response.body);
      if (response.statusCode == 200) {
        return true;
      } else if(response.statusCode == 503){
        return false;
      }else{
        return false;
      }
    }catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> uploadGame(String nome, String descrizione, String prezzo, String sconto, String mail_editore, String main_img, String data_pubblicazione)async{
    
    try{
      Map<String,String> data = {"nome":nome,
        "descrizione":descrizione,
        "prezzo":prezzo,
        "sconto":sconto,
        "mail_editore":mail_editore,
        "main_img":main_img,
        "data_pubblicazione":data_pubblicazione};
      final response = await http.post(Uri.parse('http://$ipaddress/ServerRest/createGame.php'),body: jsonEncode(data));
      if (response.statusCode == 200) {
        return true;
      } else if(response.statusCode == 400){
        return false;
      }else{
        return false;
      }
    }catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> updateGame(String id, String nome, String descrizione, String prezzo, String sconto, String mail_editore, String main_img, String data_pubblicazione)async{
    
    try{
      Map<String,String> data = {
        "id":id,
        "nome":nome,
        "descrizione":descrizione,
        "prezzo":prezzo,
        "sconto":sconto,
        "mail_editore":mail_editore,
        "main_img":main_img,
        "data_pubblicazione":data_pubblicazione};
      final response = await http.post(Uri.parse('http://$ipaddress/ServerRest/updateGame.php'),body: jsonEncode(data));
      if (response.statusCode == 200) {
        return true;
      } else if(response.statusCode == 400){
        return false;
      }else{
        return false;
      }
    }catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> deleteGame(int id)async{
    try{
      Map<String,String> data = {
        "id":"$id"};
      final response = await http.post(Uri.parse('http://$ipaddress/ServerRest/deleteGame.php'),body: jsonEncode(data));
      if (response.statusCode == 200) {
        return true;
      } else if(response.statusCode == 503){
        return false;
      }else{
        return false;
      }
    }catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> register(String email, String nome, String sede, String password) async {
    
    try{
      Map<String,String> data = {"mail":email,"name":nome,"password":password,"sede":sede};
      final response = await http.post(Uri.parse('http://$ipaddress/ServerRest/createUtente.php'),body: jsonEncode(data));
      printYellow(response.body);
      if (response.statusCode == 200) {
        return true;
      } else if(response.statusCode == 400){
        return false;
      }else{
        return false;
      }
    }catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> uploadImg(File img) async {
    try{
      /*
      Map<String,File> data = {"inpFile":img};
      print("passaggio 3");
      final response = await http.post(Uri.parse('http://$ipaddress/www.R0G.com/phps/upload_img.php'),body: data);
      print("passaggio 4");
      printYellow(response.body);
      */
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "inpFile": await MultipartFile.fromFile(img.path),
      });
      final response = await dio.post('http://$ipaddress/www.R0G.com/phps/upload_img.php', data: formData);
      return true;
    }catch(e){
      printYellow(e.toString());
      return false;
    }
  }

  Future<Map<String,dynamic>> login(String mail, String password) async {
    
    Map<String,dynamic> jsonResponse = {};
    try{
      Map<String,String> data = {"e_mail":mail,"password":password};
      final response = await http.post(Uri.parse('http://$ipaddress/ServerRest/login.php'),body: jsonEncode(data));
      if (response.statusCode == 200) {
        final editori = editoriListFromJson(response.body);
        jsonResponse["records"] = editori.records;
      } else if(response.statusCode == 400){
        //sbagliata password
      }else{
        //utente non trovato
      }
      jsonResponse["response"] = response.statusCode;
    }catch(e){
      print(e);
    }
    return jsonResponse;
  }
  
}

EditoriList editoriListFromJson(String str) => EditoriList.fromJson(json.decode(str));

String editoriListToJson(EditoriList data) => json.encode(data.toJson());

class EditoriList {
    List<Record>? records;
    String? message;

    EditoriList({
        this.records,
        this.message,
    });

    factory EditoriList.fromJson(Map<String, dynamic> json) => EditoriList(
        records: List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "records": List<dynamic>.from(records!.map((x) => x.toJson())),
        "message": message,
    };
}

class Record {
    String? mail;
    String? name;
    String? password;
    String? sede;

    Record({
        this.mail,
        this.name,
        this.password,
        this.sede,
    });

    factory Record.fromJson(Map<String, dynamic> json) => Record(
        mail: json["mail"],
        name: json["name"],
        password: json["password"],
        sede: json["sede"],
    );

    Map<String, dynamic> toJson() => {
        "mail": mail,
        "name": name,
        "password": password,
        "sede": sede,
    };
}

Giochi giochiFromJson(String str) => Giochi.fromJson(json.decode(str));

String giochiToJson(Giochi data) => json.encode(data.toJson());

class Giochi {
    List<Gioco>? records;
    String? message;

    Giochi({
        this.records,
        this.message,
    });

    factory Giochi.fromJson(Map<String, dynamic> json) => Giochi(
        records: List<Gioco>.from(json["records"].map((x) => Gioco.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "records": List<dynamic>.from(records!.map((x) => x.toJson())),
        "message": message,
    };
}

class Gioco {
    int? id;
    String? nome;
    String? descrizione;
    double? prezzo;
    int? sconto;
    String? mailEditore;
    String? mainImg;
    int? valutazione;
    String? dataPubblicazione;

    Gioco({
        this.id,
        this.nome,
        this.descrizione,
        this.prezzo,
        this.sconto,
        this.mailEditore,
        this.mainImg,
        this.valutazione,
        this.dataPubblicazione,
    });

    factory Gioco.fromJson(Map<String, dynamic> json) => Gioco(
        id: json["id"],
        nome: json["nome"],
        descrizione: json["descrizione"],
        prezzo: json["prezzo"]?.toDouble(),
        sconto: json["sconto"],
        mailEditore: json["mail_editore"],
        mainImg: json["main_img"],
        valutazione: json["valutazione"],
        dataPubblicazione: json["data_pubblicazione"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nome": nome,
        "descrizione": descrizione,
        "prezzo": prezzo,
        "sconto": sconto,
        "mail_editore": mailEditore,
        "main_img": mainImg,
        "valutazione": valutazione,
        "data_pubblicazione": dataPubblicazione,
    };
}
void printYellow(String msg) 
  {String a = "";
    for (var line in msg.split("\n")) {
      a+="\x1B[33m$line\x1B[0m\n";
    }
    print(a);
  }

KeysList keysListFromJson(String str) => KeysList.fromJson(json.decode(str));

String keysListToJson(KeysList data) => json.encode(data.toJson());

class KeysList {
    List<GameKey>? records;

    KeysList({
        this.records,
    });

    factory KeysList.fromJson(Map<String, dynamic> json) => KeysList(
        records: List<GameKey>.from(json["records"].map((x) => GameKey.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "records": List<dynamic>.from(records!.map((x) => x.toJson())),
    };
}

class GameKey {
    int? gameId;
    String? key;

    GameKey({
        this.gameId,
        this.key,
    });

    factory GameKey.fromJson(Map<String, dynamic> json) => GameKey(
        gameId: json["game_id"],
        key: json["key"],
    );

    Map<String, dynamic> toJson() => {
        "game_id": gameId,
        "key": key,
    };
}
