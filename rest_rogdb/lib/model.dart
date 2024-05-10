import 'package:floor/floor.dart';

@entity
class Developer {
  Developer({required this.e_mail, required this.nome, required this.sede, this.password});
  @primaryKey
  final String e_mail;
  final String nome;
  final String sede;
  final String? password;
}
@entity
class Server {
  Server({required this.ipaddress});
  @primaryKey
  final String ipaddress;
}

@Entity(tableName: "Comment", foreignKeys: [
  ForeignKey(childColumns: ["mail_editore"], parentColumns: ["e_mail"], entity: Developer, onDelete: ForeignKeyAction.noAction),
])
class Game {
  Game({required this.id, required this.nome, required this.descrizione, required this.prezzo, required this.sconto, required this.mail_editore, required this.main_img, required this.valutazione, required this.data_pubblicazione});
  @primaryKey
  final int id;

  final String nome;
  final String descrizione;
  final double prezzo;
  final int sconto;

  @ColumnInfo(name: "mail_editore")
  final int mail_editore;

  final String main_img;
  final double valutazione;
  final String data_pubblicazione;

}
