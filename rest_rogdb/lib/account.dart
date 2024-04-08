class Account{
  static String? e_mail;
  static String? name;
  static String? sede;

  String? getEmail(){
    return e_mail;
  }
  String? getName(){
    return name;
  }
  String? getSede(){
    return sede;
  }

  void setEmail(String mailIn){
    e_mail = mailIn;
  }
  void setName(String nameIn){
    name = nameIn;
  }
  void setSede(String sedeIn){
    sede = sedeIn;
  }
}