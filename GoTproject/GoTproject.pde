int nodeCount;
Node[] nodes = new Node[100];
HashMap nodeTable = new HashMap();

int edgeCount;
Edge[] edges = new Edge[500];

String fromTitle, toTitle;

PImage photo;

static final color nodeColor = #F0C070;
static final color selectColor = #FF3030;
static final color fixedColor = #FF8080;
static final color edgeColor = #000000;

PFont font;

void setup(){
  size(600, 600);
  //loadData();
  photo = loadImage("GoT.jpg");
  font = createFont("SansSerif", 10);
  textFont(font);
  smooth();
  readData();
}

/*
void loadData(){
  addEdge("Arryn", "Baratheon");
  addEdge("Baratheon", "Bolton");
  addEdge("Bolton", "Braavos");
  addEdge("Dothraki", "Frey");
  addEdge("Frey", "Greyjoy");
  addEdge("Greyjoy", "Lannister");
  addEdge("Arryn", "Dothraki");
  addEdge("Baratheon", "Frey");
  addEdge("Bolton", "Greyjoy");
  addEdge("Braavos", "Lannister");
  addEdge("Martell", "Nights_Watch");
  addEdge("Nights_Watch", "Stark");
  addEdge("Stark", "Targaryen");
  addEdge("Dothraki", "Martell");
  addEdge("Frey", "Nights_Watch");
  addEdge("Greyjoy", "Stark");
  addEdge("Lannister", "Targaryen");
  addEdge("The_Thirteen", "Tully");
  addEdge("Tully", "Unknown");
  addEdge("Unknown", "Whent");
  addEdge("Martell", "The_Thirteen");
  addEdge("Nights_Watch", "Tully");
  addEdge("Stark", "Unknown");
  addEdge("Targaryen", "Whent");
  addEdge("White_Walker", "Wildling");
  addEdge("The_Thirteen", "White_Walker");
  addEdge("Tully", "Wildling");
}*/

void readData(){
  String[] lines = loadStrings("GoT.txt");
  for(int i=0; i<lines.length; i++){
    String [] line = split(lines[i], TAB);
    fromTitle = line[0];
    toTitle = line[1];
    addEdge(fromTitle, toTitle);
  }
}

void addEdge(String fromTitle, String toTitle){
 Node from = findNode(fromTitle);
 Node to = findNode(toTitle);
 Edge e = new Edge(from, to);
 if(edgeCount == edges.length){
   edges = (Edge[]) expand(edges);
 }
 edges[edgeCount++] = e;
}

Node findNode(String label){
  label = label.toLowerCase();
  Node n = (Node) nodeTable.get(label);
  if(n == null){
    return addNode(label);
  }
  return n;
}

Node addNode(String label){
  Node n = new Node(label);
  if(nodeCount == nodes.length){
    nodes = (Node[]) expand(nodes);
  }
  nodeTable.put(label, n);
  nodes[nodeCount++] = n;
  return n;
}

void draw(){
  background(255);
  image(photo, 0, 0);
  
  for(int i=0; i<edgeCount; i++){
    edges[i].relax();
  }
  for(int i=0; i<nodeCount; i++){
    nodes[i].relax();
  }
  for(int i=0; i<nodeCount; i++){
    nodes[i].update();
  }
  for(int i=0; i<edgeCount; i++){
    edges[i].draw();
  }
  for(int i=0; i<nodeCount; i++){
    nodes[i].draw();
  }
}

Node selection;

void mousePressed(){
  //Ignore anything grater than this distance. 
  float closest = 20;
  for(int i=0; i<nodeCount; i++){
    Node n = nodes[i];
    float d = dist(mouseX, mouseY, n.x, n.y);
    if(d < closest){
      selection = n;
      closest = d;
    }
  }
  if(selection != null){
    if(mouseButton == LEFT){
      selection.fixed = true;
    } else if(mouseButton == RIGHT){
      selection.fixed = false;
    }
  }
}

void mouseDragged(){
  if(selection != null){
    selection.x = mouseX;
    selection.y = mouseY;
  }
}

void mouseReleased(){
  selection = null;
}
