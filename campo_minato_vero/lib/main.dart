import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'Dimensions.dart';
import 'CellProp.dart';
import 'ButtonList.dart';
void main() => runApp(const FirstRoute());



class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Basics',
      home: Maaa(),
    );
  }
} 

class Maaa extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MaaAA();
  }
}

class MaaAA extends State<Maaa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('impostazioni MISURE'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text("width"),
            Row(
              children: [
                const SizedBox(width: 105),
                IconButton(
                    onPressed: () => {
                          setState(() {
                            if (Dimensions.width > 1) Dimensions.width--;
                          })
                        },
                    icon: const Icon(Icons.remove)),
                const SizedBox(width: 20),
                Text(Dimensions.width.toString()),
                const SizedBox(width: 20),
                IconButton(
                    onPressed: () => {
                          setState(() {
                            Dimensions.width++;
                          })
                        },
                    icon: const Icon(Icons.add)),
              ],
            ),
            const Text("height"),
            Row(
              children: [
                const SizedBox(width: 105),
                IconButton(
                    onPressed: () => {
                          setState(() {
                            if (Dimensions.height > 1) Dimensions.height--;
                          })
                        },
                    icon: const Icon(Icons.remove)),
                const SizedBox(width: 20),
                Text(Dimensions.height.toString()),
                const SizedBox(width: 20),
                IconButton(
                    onPressed: () => {
                          setState(() {
                            Dimensions.height++;
                          })
                        },
                    icon: const Icon(Icons.add)),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              child: const Text('PLAY'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    Dimensions().setSize();
                    return Phoenix(child: MyApp());
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  late Campo campo;
  late List<List<CellProp>> cells;
  @override
  Widget build(BuildContext context) {
    campo = Campo(context);
    cells = List.generate(
        Dimensions.width,
        (index) => List.generate(
            Dimensions.height, (index) => new CellProp(false, 3, context)));
    initNum();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("CAMPO MINATO"),
          actions: [
            IconButton(
                onPressed: () {
                  if (!CellProp.isCanceling) {
                    Phoenix.rebirth(context);
                    CampoState.isDead = false;
                  }
                },
                icon: const Icon(Icons.replay_outlined)),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  CampoState.isDead = false;
                },
                icon: const Icon(Icons.arrow_back_ios_rounded))
          ],
        ),
        body: campo,
      ),
    );
  }

  void initNum() {
    CampoState.isDead = false;
    Buttons().clear();
    for (int i = 0; i < Dimensions.width; i++) {
      for (var j = 0; j < Dimensions.height; j++) {
        bool b = Random().nextInt(10) > 7;
        cells[i][j].setBomb(b);
      }
    }
    for (var i = 0; i < Dimensions.width; i++) {
      for (var j = 0; j < Dimensions.height; j++) {
        cells[i][j].setNum(setNearBOmbxCasella(i, j));
        Buttons().addButt(
            "$i.$j",
            cells[i][
                j]); // per creare le varie istanze in seguito perche in altri modi non
      }
    }
  }

  int setNearBOmbxCasella(int i, int j) {
    int tot = 0;
    CellProp? tmp = getUpLeft(i, j);
    if (tmp != null && tmp.IsBomb()) {
      tot++;
    }
    tmp = getUpRight(i, j);
    if (tmp != null && tmp.IsBomb()) {
      tot++;
    }
    tmp = getUp(i, j);
    if (tmp != null && tmp.IsBomb()) {
      tot++;
    }
    tmp = getLeft(i, j);
    if (tmp != null && tmp.IsBomb()) {
      tot++;
    }
    tmp = getRight(i, j);
    if (tmp != null && tmp.IsBomb()) {
      tot++;
    }
    tmp = getDown(i, j);
    if (tmp != null && tmp.IsBomb()) {
      tot++;
    }
    tmp = getDownLeft(i, j);
    if (tmp != null && tmp.IsBomb()) {
      tot++;
    }
    tmp = getDownRight(i, j);
    if (tmp != null && tmp.IsBomb()) {
      tot++;
    }
    return tot;
  }

  CellProp? getUpLeft(int i, int j) {
    if (i - 1 >= 0 &&
        j - 1 >= 0 &&
        i - 1 < Dimensions.width &&
        j - 1 < Dimensions.height) {
      return cells[i - 1][j - 1];
    }
    return null;
  }

  CellProp? getUpRight(int i, int j) {
    if (i + 1 >= 0 &&
        j - 1 >= 0 &&
        i + 1 < Dimensions.width &&
        j - 1 < Dimensions.height) {
      return cells[i + 1][j - 1];
    }
    return null;
  }

  CellProp? getRight(int i, int j) {
    if (i + 1 >= 0 &&
        j >= 0 &&
        i + 1 < Dimensions.width &&
        j < Dimensions.height) {
      return cells[i + 1][j];
    }
    return null;
  }

  CellProp? getLeft(int i, int j) {
    if (i - 1 >= 0 &&
        j >= 0 &&
        i - 1 < Dimensions.width &&
        j < Dimensions.height) {
      return cells[i - 1][j];
    }
    return null;
  }

  CellProp? getUp(int i, int j) {
    if (i >= 0 &&
        j - 1 >= 0 &&
        i < Dimensions.width &&
        j - 1 < Dimensions.height) {
      return cells[i][j - 1];
    }
    return null;
  }

  CellProp? getDown(int i, int j) {
    if (i >= 0 &&
        j + 1 >= 0 &&
        i < Dimensions.width &&
        j + 1 < Dimensions.height) {
      return cells[i][j + 1];
    }
    return null;
  }

  CellProp? getDownRight(int i, int j) {
    if (i + 1 >= 0 &&
        j + 1 >= 0 &&
        i + 1 < Dimensions.width &&
        j + 1 < Dimensions.height) {
      return cells[i + 1][j + 1];
    }
    return null;
  }

  CellProp? getDownLeft(int i, int j) {
    if (i - 1 >= 0 &&
        j + 1 >= 0 &&
        i - 1 < Dimensions.width &&
        j + 1 < Dimensions.height) {
      return cells[i - 1][j + 1];
    }
    return null;
  }
}

class Campo extends StatefulWidget {
  late BuildContext context;
  Campo(BuildContext cont) {
    context = cont;
  }
  @override
  State<StatefulWidget> createState() {
// TODO: implement createState
    return CampoState(context);
  }
}

class CampoState extends State<Campo> {
  static bool isDead = false;
  late BuildContext contexto;
  CampoState(BuildContext cont) {
    contexto = cont;
  }
  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: _CascadeLayoutDelegate(
        colors: Buttons().getMap(),
      ),
      children: <Widget>[
// Create all of the colored boxes in the colors map.
        for (final MapEntry<String, CellProp> entry
            in Buttons().getMap().entries)
// The "id" can be any Object, not just a String.
          LayoutId(
            id: entry.key,
            child: SizedBox(
              height: Dimensions.cellSize - 1,
              width: Dimensions.cellSize - 1,
              child: TextButton(
                style: ButtonStyle(backgroundColor: getC(entry.key)),
                onPressed: () => pressed(entry.key),
                onLongPress: () => longPressed(entry.key),
                child: Text(
                  entry.value.t,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void pressed(String id) {
    if (isDead) {
      if (!CellProp.isCanceling) {
        Phoenix.rebirth(context);
        isDead = false;
      }
      return;
    }

    Buttons b = Buttons();
    if (b.getMap()[id]!.isFlagged) return;
    if (b.getMap()[id]!.IsBomb()) {
      isDead = true;
      if (CellProp.isCanceling) return;
      print("bombaaaa");
      setState(() {
        b.seeBombs();
      });
      CellProp.isCanceling = true;
      Future.delayed(const Duration(seconds: 2), () {
        CellProp.isCanceling = false;
        toLose();
      });
      return;
    }
    b.seeAj(getInd(id, 0), getInd(id, 1));
    if (b.getMap()[id]!.numBomb() == 0) {
      print("vodo");
    }
    setState(() {});
    if (b.allSeen()) {
      isDead = true;
      toWin();
    }
  }

  void longPressed(String id) {
    Buttons b = Buttons();
    b.flag(id);
    if (b.allSeen()) {
      toWin();
    }
  }

  void toLose() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        Dimensions().setSize();
        return const WinPage(msg: "YOU LOST!");
      }),
    );
  }

  void toWin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        Dimensions().setSize();
        return const WinPage(msg: "YOU WON!");
      }),
    );
  }

  int getInd(String ind, int i) {
    String cur = "";
    int a = 0;
    for (var c in ind.characters) {
      if (c == '.') {
        a++;
      } else {
        if (a == i) {
          cur += c;
        }
      }
    }
    return int.parse(cur);
  }

  MaterialStateProperty<Color> getC(String pos) {
// ignore: prefer_function_declarations_over_variables
    final col = (Set<MaterialState> st) {
      return Buttons().getColor(pos);
    };
    return MaterialStateProperty.resolveWith(col);
  }
}

class _CascadeLayoutDelegate extends MultiChildLayoutDelegate {
  _CascadeLayoutDelegate({
    required this.colors,
  });
  final Map<String, CellProp> colors;
// Perform layout will be called when re-layout is needed.
  @override
  void performLayout(Size size) {
// First get the FlutterView.
    double realSize = Dimensions.cellSize;
    double offH = (Dimensions.screenWidth +
            Dimensions.padding * 2 -
            realSize * Dimensions.width) /
        2;
    double offV = (Dimensions.screenHeight +
            Dimensions.padding * 2 -
            realSize * Dimensions.height) /
        2;
    for (var element in colors.keys) {
      layoutChild(
        element,
        BoxConstraints(maxHeight: realSize, maxWidth: realSize),
      );
      positionChild(
          element,
          Offset(offH + getInd(element, 0) * realSize,
              offV + getInd(element, 1) * realSize));
    }
  }

  int getInd(String ind, int i) {
    String cur = "";
    int a = 0;
    for (var c in ind.characters) {
      if (c == '.') {
        a++;
      } else {
        if (a == i) {
          cur += c;
        }
      }
    }
    return int.parse(cur);
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





class WinPage extends StatelessWidget {
  final String msg;
  const WinPage({super.key, required this.msg});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('END'),
      ),
      body: Center(
        child: Text(msg),
      ),
    );
  }
}
