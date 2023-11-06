class Dimensions {
  static int screenWidth = 348;
  static int screenHeight = 705;
  static int padding = 6;
  static int width = 1;
  static int height = 1;
  static double cellSize = 0;
  void setW(int a) {
    width = a;
  }

  void setH(int a) {
    height = a;
  }

  void setSize() {
    print(" settate misure");
    double vsize = screenHeight / height;
    double hsize = screenWidth / width;
    if (vsize > hsize) {
      cellSize = hsize;
    } else {
      cellSize = vsize;
    }
  }
}