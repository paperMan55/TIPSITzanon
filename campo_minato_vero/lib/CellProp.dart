import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class CellProp {
  static bool isCanceling = false;
  final Color flaggedC = Colors.yellow;
  final Color bombedC = Colors.red;
  final Color normalC = Colors.blue;
  final Color seenC = const Color.fromARGB(255, 166, 213, 252);
  bool isFlagged = false;
  bool isSeen = false;
  bool isBomb = true;
  int numB = 0;
  late Color c;
  late TextButton button;
  String t = "";
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

  Color getColor() {
    return c;
  }

  void setFlagged(bool f) {
    if (isSeen) return;
    isFlagged = f;
    if (f) {
      c = flaggedC;
    } else {
      c = normalC;
    }
  }

  void cancel() {
    isCanceling = false;
    Phoenix.rebirth(context);
  }

  void see() {
    isSeen = true;
    if (IsBomb()) {
      print("bomb");
      c = bombedC;
    } else {
      if (numBomb() != 0) t = numBomb().toString();
      print(numBomb());
      c = seenC;
    }
  }
}