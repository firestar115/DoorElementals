import java.awt.Color;

ArrayList<Elemental> elementals = new ArrayList<Elemental>();
Door[][] levelDoors = new Door[][] {
  {
    new Door(new Color(255, 0, 0), new Color(0, 255, 0), new Color(255, 0, 255)),
    new Door(new Color(255, 0, 0), new Color(0, 0, 255), new Color(255, 0, 255))
    }
  };
  int level = 1;
int squareSize = 50;

int selectedElemental = -1;
int perRow = 800 / squareSize;

int uniqueElementals = 0;

Elemental inUse = null;

void setup() {
  size(800, 600);
  elementals.add(new Elemental(255, 0, 0));
  elementals.add(new Elemental(255, 0, 0));
  elementals.add(new Elemental(0, 255, 0));
  elementals.add(new Elemental(0, 0, 255));
  elementals.add(new Elemental(255, 0, 255));
  elementals.add(new Elemental(255, 0, 255));
}

void draw() {
  background(0);
  drawElementals();
  drawDoors();
}

void mousePressed() {
  selectedElemental = mouseX / squareSize + (mouseY / squareSize) * perRow;
  if (selectedElemental > uniqueElementals - 1) {
    selectedElemental = -1;
  }
  if (level == 1 && mouseX > 100 && mouseX < 100 + squareSize && mouseY > 100 && mouseY < 100 + squareSize * 2) {
    levelDoors[0][0].activate(inUse);
  }
  if (level == 1 && mouseX > 300 && mouseX < 300 + squareSize && mouseY > 100 && mouseY < 100 + squareSize * 2) {
    levelDoors[0][1].activate(inUse);
  }
}

void drawDoors() {
  Door[] doors = levelDoors[level-1];
  for (int i = 0; i < doors.length; i++) {
    Door door = doors[i];
    fill(door.getCombinedColor().getRed(), door.getCombinedColor().getGreen(), door.getCombinedColor().getBlue());
    rect(i * 200 + 100, 100, squareSize, squareSize * 2);
  }
}

void drawElementals() {
  HashMap<Elemental, Integer> numElementals = new HashMap<Elemental, Integer>();
  for (Elemental e : elementals) {
    if (numElementals.containsKey(e)) {
      int num = numElementals.get(e) + 1;
      numElementals.remove(e);
      numElementals.put(e, num);
    } else {
      numElementals.put(e, 1);
    }
  }
  try {
    inUse = (Elemental) numElementals.keySet().toArray()[selectedElemental];
  } 
  catch(Exception e) {
  }
  uniqueElementals = numElementals.keySet().size();
  int x = 0;
  int y = 0;
  for (Elemental e : numElementals.keySet ()) {
    int num = numElementals.get(e);
    fill(255, 255, 255);
    rect(x, y, squareSize, squareSize);
    fill(e.getColor().getRed(), e.getColor().getGreen(), e.getColor().getBlue());
    ellipse(x + squareSize / 2, y + squareSize / 2, 25, 25);
    fill(0, 0, 0);
    text("x"+num, x + 3, y + 12);
    x += squareSize;
    if (x >= 800) {
      x = 0;
      y += squareSize;
    }
  }
  if (selectedElemental >= 0) {
    int x1 = (selectedElemental * squareSize) % 800;
    int x2 = x1 + squareSize;
    int y1 = (selectedElemental / perRow) * squareSize;
    int y2 = y1 + squareSize;
    stroke(255, 0, 0);
    strokeWeight(3);
    line(x1, y1, x2, y1);
    line(x2, y1, x2, y2);
    line(x2, y2, x1, y2);
    line(x1, y2, x1, y1);
  }
  stroke(0, 0, 0);
  strokeWeight(1);
}

class Elemental {
  Color c;
  public Elemental(Color c) {
    this.c = c;
  }
  public Elemental(int r, int g, int b) {
    this(new Color(r, g, b));
  }
  public Color getColor() {
    return c;
  }
  public boolean equals(Object o) {
    if (o instanceof Elemental) {
      if (((Elemental) o).getColor().equals(this.getColor())) {
        return true;
      }
    }
    return false;
  }
  public int hashCode() {
    return getColor().hashCode();
  }
}

class Door {
  ArrayList<Color> colors = new ArrayList<Color>();
  public Door(Color... colors) {
    for (Color c : colors) {
      this.colors.add(c);
    }
  }
  public ArrayList<Color> getColors() {
    return this.colors;
  }
  public Color getCombinedColor() {
    if (!colors.isEmpty()) {
      int r = colors.get(0).getRed();
      int g = colors.get(0).getGreen();
      int b = colors.get(0).getBlue();
      for (Color c : colors) {
        r = (r + c.getRed()) / 2;
        g = (g + c.getGreen()) / 2;
        b = (b + c.getBlue()) / 2;
      }
      return new Color(r, g, b);
    }
    return Color.BLACK;
  }
  public void activate(Elemental e) {
    if (colors.contains(e.getColor())) {
      colors.remove(e.getColor());
      elementals.remove(e);
    }
  }
}

