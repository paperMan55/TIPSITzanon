import 'package:http/http.dart' as http;
import 'dart:convert';

class Connection{
  final String ipaddress;

  Connection(this.ipaddress);

  Future<Map<String,dynamic>> read() async {
    Map<String,dynamic> jsonResponse = {};
    try{
      final response = await http.get(Uri.parse('http://$ipaddress/ServerRest/read.php'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        final utenti = utentiFromJson(response.body);
        jsonResponse["records"] = utenti.records;
      } else {
        throw Exception('Failed to load data');
      }
      jsonResponse["response"] = response.statusCode;
    }catch(e){
      print(e);
    }
    return jsonResponse;
  }
}

Utenti utentiFromJson(String str) => Utenti.fromJson(json.decode(str));

String utentiToJson(Utenti data) => json.encode(data.toJson());

class Utenti {
    List<Record> records;

    Utenti({
        required this.records,
    });

    factory Utenti.fromJson(Map<String, dynamic> json) => Utenti(
        records: List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
    };
}

class Record {
    String mail;
    String name;
    String surname;
    DateTime birth;
    DateTime accDate;
    String password;

    Record({
        required this.mail,
        required this.name,
        required this.surname,
        required this.birth,
        required this.accDate,
        required this.password,
    });

    factory Record.fromJson(Map<String, dynamic> json) => Record(
        mail: json["mail"],
        name: json["name"],
        surname: json["surname"],
        birth: DateTime.parse(json["birth"]),
        accDate: DateTime.parse(json["acc_date"]),
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "mail": mail,
        "name": name,
        "surname": surname,
        "birth": "${birth.year.toString().padLeft(4, '0')}-${birth.month.toString().padLeft(2, '0')}-${birth.day.toString().padLeft(2, '0')}",
        "acc_date": "${accDate.year.toString().padLeft(4, '0')}-${accDate.month.toString().padLeft(2, '0')}-${accDate.day.toString().padLeft(2, '0')}",
        "password": password,
    };
}