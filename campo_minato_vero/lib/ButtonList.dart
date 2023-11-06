import 'package:flutter/material.dart';
import 'Dimensions.dart';
import 'CellProp.dart';


class Buttons {
  static Map<String, CellProp> buttonsProp = {};
  Map<String, CellProp> getMap() {
    return buttonsProp;
  }

  Color getColor(String pos) {
    return buttonsProp[pos]!.getColor();
  }

  void clear() {
    buttonsProp.clear();
  }

  void addButt(String pos, CellProp p) {
    buttonsProp[pos] = p;
  }

  void flag(String pos) {
    buttonsProp[pos]!.setFlagged(!buttonsProp[pos]!.isFlagged);
  }

  void seeBombs() {
    for (var element in buttonsProp.values) {
      if (element.IsBomb()) {
        element.see();
      }
    }
  }

  void seeAj(int i, int j) {
    if (i >= 0 && j >= 0 && i < Dimensions.width && j < Dimensions.height) {
      if (buttonsProp["$i.$j"]!.isSeen) return;
      see("$i.$j");
      if (buttonsProp["$i.$j"]!.numBomb() != 0) return;
      i++;
      seeAj(i, j);
      j++;
      seeAj(i, j);
      i--;
      seeAj(i, j);
      i--;
      seeAj(i, j);
      j--;
      seeAj(i, j);
      j--;
      seeAj(i, j);
      i++;
      seeAj(i, j);
      i++;
      seeAj(i, j);
    }
  }

  void see(String pos) {
    if (buttonsProp[pos]!.isFlagged) return;
    buttonsProp[pos]!.see();
  }

  bool allSeen() {
    bool as = true;
    for (var element in buttonsProp.values) {
      if (!element.IsBomb() && !element.isSeen) {
        as = false;
      }
    }
    return as;
  }

  @override
  String toString() {
    String s = "";
    for (var element in buttonsProp.entries) {
      s += "${element.key}: ${element.value.isBomb} - ";
    }
    return s;
  }

  CellProp? getUpLeft(int i, int j) {
    i--;
    j--;
    if (i >= 0 && j >= 0 && i < Dimensions.height && j < Dimensions.height) {
      return buttonsProp["$i.$j"];
    }
    return null;
  }

  CellProp? getUpRight(int i, int j) {
    i++;
    j--;
    if (i >= 0 && j >= 0 && i < Dimensions.width && j < Dimensions.height) {
      return buttonsProp["$i.$j"];
    }
    return null;
  }

  CellProp? getRight(int i, int j) {
    i++;
    if (i >= 0 && j >= 0 && i < Dimensions.width && j < Dimensions.height) {
      return buttonsProp["$i.$j"];
    }
    return null;
  }

  CellProp? getLeft(int i, int j) {
    i--;
    if (i >= 0 && j >= 0 && i < Dimensions.width && j < Dimensions.height) {
      return buttonsProp["$i.$j"];
    }
    return null;
  }

  CellProp? getUp(int i, int j) {
    j--;
    if (i >= 0 && j >= 0 && i < Dimensions.width && j < Dimensions.height) {
      return buttonsProp["$i.$j"];
    }
    return null;
  }

  CellProp? getDown(int i, int j) {
    j++;
    if (i >= 0 && j >= 0 && i < Dimensions.width && j < Dimensions.height) {
      return buttonsProp["$i.$j"];
    }
    return null;
  }

  CellProp? getDownRight(int i, int j) {
    i++;
    j++;
    if (i >= 0 && j >= 0 && i < Dimensions.width && j < Dimensions.height) {
      return buttonsProp["$i.$j"];
    }
    return null;
  }

  CellProp? getDownLeft(int i, int j) {
    i--;
    j++;
    if (i >= 0 && j >= 0 && i < Dimensions.width && j < Dimensions.height) {
      return buttonsProp["$i.$j"];
    }
    return null;
  }
}