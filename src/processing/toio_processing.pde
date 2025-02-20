import oscP5.*;
import netP5.*;

//constants
//The soft limit on how many toios a laptop can handle is in the 10-12 range
//the more toios you connect to, the more difficult it becomes to sustain the connection
int nCubes = 8;
int cubesPerHost = 12;
int maxMotorSpeed = 115;
int xOffset;
int yOffset;

float minX = 41.80588;
float minY = -87.60640;
float range = 0.02537;
int anchorX, anchorY, transX, transY = 0;
int zoom = 800;

Boolean newPos = true;
Boolean movingView = false;
int selectedToio = -1;
Boolean newSelection = false;
int availability;

int[] matDimension = {45, 45, 455, 455};

PShape map;


//for OSC
OscP5 oscP5;
//where to send the commands to
NetAddress[] server;

//we'll keep the cubes here
Cube[] cubes;

JSONArray bikes, buses, trains;
String mode = "bikes";

class Coordinate {
  float x, y;
  
  // Constructor to create a coordinate
  Coordinate(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  // Method to display the coordinate
  void display() {
    ellipse(x, y, 10, 10);
  }
  
  int compareTo(Coordinate coord) {
      if (this.x < coord.x) {
        return -1; // a comes before b
      } else if (this.x > coord.x) {
        return 1; // b comes before a
      } else {
        return 0; // they are equal
      }
    }
 }

void setup() {
  size(1000, 1000, P3D);
  
  bikes = loadJSONArray("bikes.json");
  buses = loadJSONArray("buses.json");
  trains = loadJSONArray("trains.json");

  // keystone
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(800, 800, 20);
  offscreen = createGraphics(800, 800, P3D);
  
  //launch OSC sercer
  oscP5 = new OscP5(this, 3333);
  server = new NetAddress[1];
  server[0] = new NetAddress("127.0.0.1", 3334);
  
  map = loadShape("map.svg");

  //create cubes
  cubes = new Cube[nCubes];
  for (int i = 0; i< nCubes; ++i) {
    cubes[i] = new Cube(i);
  }

  xOffset = matDimension[0] - 45;
  yOffset = matDimension[1] - 45;

  //do not send TOO MANY PACKETS
  //we'll be updating the cubes every frame, so don't try to go too high
  frameRate(30);

  // starting pos
  cubes[0].target(100, 400, 90);
}

void draw() {

  // Convert the mouse coordinate into surface coordinates
  // this will allow you to use mouse events inside the 
  // surface from your screen. 
  PVector surfaceMouse = surface.getTransformedMouse();

  // Draw the scene, offscreen
  offscreen.beginDraw();
  offscreen.background(255);
  offscreen.fill(0, 255, 0);
  offscreen.ellipse(surfaceMouse.x, surfaceMouse.y, 75, 75);
  offscreen.shape(map, anchorX, anchorY, zoom, zoom);
  
  if (mode == "bikes") {
    String[] toioCoords;
    toioCoords = new String[6];
    int k = 0;
    
    for (int i = 0; i < bikes.size(); i++) {
      JSONObject bike = bikes.getJSONObject(i); 
  
      float lat = bike.getFloat("lat");
      float lng = bike.getFloat("lng");
  
      offscreen.fill(0, 0, 255);
      float coordX = (((lng - minY) / range * 800 - 135) - 400) * zoom / 800 + 400 + transX;
      float coordY = (((minX - lat) / range * 800 - 15) - 400) * zoom / 800 + 400 + transY;
      offscreen.ellipse(coordX, coordY, 25, 25);
   
      if (i < 6 && coordX > 0 && coordY > 0) {
        float toioX = coordX / 800 * 370 + 60;
        float toioY = coordY / 800 * 370 + 60;
        
        String prepend = "";
        if (toioX < 100) prepend = "0";
        
        toioCoords[k] = (prepend + (int) toioX + "/" + (int) toioY);
        k += 1;
      }
    }
    for (int z = k; z < 6; z++) {
      toioCoords[z] = "z";
    }
    toioCoords = sort(toioCoords);
    if (newPos) {
        int j = 1;
        for (String c : toioCoords) {
          if (c != "z") {
            println(c);
            String[] coords = split(c, '/');
            cubes[j].target(int(coords[0]), int(coords[1]), 180);
            
            delay(2000);
            j += 1;
          }
        }
    }
    if (newSelection) {
       availability = int(random(0, 13));
       newSelection = false;
    }
    
    if (selectedToio != -1) {
              int drawX = (cubes[selectedToio].x - 60) * 800 / 370;
              int drawY = (cubes[selectedToio].y - 60) * 800 / 370 - 75;
              println("------" + drawX + "   " + drawY);
            
              offscreen.fill(200, 200, 255);
              offscreen.rectMode(CENTER);
              offscreen.rect(drawX, drawY, 200, 50);
              
              offscreen.fill(0);  // Black text color
              offscreen.textSize(24);  // Set the text size
              offscreen.textAlign(CENTER, CENTER);  // Align the text
              offscreen.text("Bikes Available: " + availability, drawX, drawY);
            }
    
    newPos = false;
  } else if (mode == "trains") {
    String[] toioCoords;
    toioCoords = new String[6];
    int k = 0;
    
    for (int i = 0; i < trains.size(); i++) {
      JSONObject train = trains.getJSONObject(i); 
  
      float lat = train.getFloat("lat");
      float lng = train.getFloat("lng");
  
      offscreen.fill(0, 0, 255);
      float coordX = (((lng - minY) / range * 800 - 135) - 400) * zoom / 800 + 400 + transX;
      float coordY = (((minX - lat) / range * 800 - 15) - 400) * zoom / 800 + 400 + transY;
      offscreen.ellipse(coordX, coordY, 25, 25);
   
      if (i < 6 && coordX > 0 && coordY > 0) {
        float toioX = coordX / 800 * 370 + 60;
        float toioY = coordY / 800 * 370 + 60;
        
        String prepend = "";
        if (toioX < 100) prepend = "0";
        
        toioCoords[k] = (prepend + (int) toioX + "/" + (int) toioY);
        k += 1;
      }
    }
    for (int z = k; z < 6; z++) {
      toioCoords[z] = "z";
    }
    toioCoords = sort(toioCoords);
    if (newPos) {
        int j = 1;
        for (String c : toioCoords) {
          if (c != "z") {
            String[] coords = split(c, '/');
            cubes[j].target(int(coords[0]), int(coords[1]), 180);
            delay(2000);
            j += 1;
          }
         }
    }
    
    newPos = false;
  } else if (mode == "buses") {
    String[] toioCoords;
    toioCoords = new String[6];
    int k = 0;
    
    for (int i = 0; i < buses.size(); i++) {
      JSONObject bus = buses.getJSONObject(i); 
  
      float lat = bus.getFloat("lat");
      float lng = bus.getFloat("lng");
  
      offscreen.fill(255, 0, 0);
      float coordX = (((lng - minY) / range * 800 - 135) - 400) * zoom / 800 + 400 + transX;
      float coordY = (((minX - lat) / range * 800 - 15) - 400) * zoom / 800 + 400 + transY;
      offscreen.ellipse(coordX, coordY, 25, 25);
   
      if (i < 6 && coordX > 0 && coordY > 0) {
        float toioX = coordX / 800 * 370 + 60;
        float toioY = coordY / 800 * 370 + 60;
        
        String prepend = "";
        if (toioX < 100) prepend = "0";
        
        toioCoords[k] = (prepend + (int) toioX + "/" + (int) toioY);
        k += 1;
      }
    }
    for (int z = k; z < 6; z++) {
      toioCoords[z] = "z";
    }
    toioCoords = sort(toioCoords);
    if (newPos) {
        int j = 1;
        for (int x = 0; x < 6; x++) {
          String c = toioCoords[x];
          if (c != "z") {
            println(c);
            String[] coords = split(c, '/');
            cubes[j].target(int(coords[0]), int(coords[1]), 0);
            
            delay(2000);
            j += 1;
          }
        }
    }
    if (newSelection) {
         availability = int(random(0, 16));
         newSelection = false;
     }
    
        if (selectedToio != -1) {
              int drawX = (cubes[selectedToio].x - 60) * 800 / 370;
              int drawY = (cubes[selectedToio].y - 60) * 800 / 370 - 75;
              println("------" + drawX + "   " + drawY);
            
              offscreen.fill(200, 200, 255);
              offscreen.rectMode(CENTER);
              offscreen.rect(drawX, drawY, 200, 50);
              
              offscreen.fill(0);  // Black text color
              offscreen.textSize(24);  // Set the text size
              offscreen.textAlign(CENTER, CENTER);  // Align the text
              offscreen.text("Next Arrival: " + availability + " min", drawX, drawY);
            }
    
    newPos = false;
  }
  
  offscreen.endDraw();

  // most likely, you'll want a black background to minimize
  // bleeding around your projection area
  background(0);
 
  // render the scene, transformed using the corner pin surface
  surface.render(offscreen);
  
  
  if (cubes[0].theta > 120) {
    zoom = zoom + 6;
    anchorX = anchorX - 3;
    anchorY = anchorY - 3;
    movingView = true;
  }
  else if (cubes[0].theta < 60) {
    zoom = zoom - 6;
    anchorX = anchorX + 3;
    anchorY = anchorY + 3;
    movingView = true;
  }
  else if (cubes[0].x > 120) {
      transX = transX - 5;
      anchorX = anchorX - 5;
      movingView = true;
  }
  else if (cubes[0].x < 80) {
      transX = transX + 5;
      anchorX = anchorX + 5;
      movingView = true;
  }
  else if (cubes[0].y < 380) {
      transY = transY + 5;
      anchorY = anchorY + 5;
      movingView = true;
  }
  else if (cubes[0].y > 420) {
      transY = transY - 5;
      anchorY = anchorY - 5;
      movingView = true;
  } else if (movingView) {
    newPos = true;
    movingView = false;
  }
}

//void draw() {
//  //START TEMPLATE/DEBUG VIEW
//  background(255);
//  stroke(0);
//  long now = System.currentTimeMillis();

//  //draw the "mat"
//  fill(255);
//  rect(matDimension[0] - xOffset, matDimension[1] - yOffset, matDimension[2] - matDimension[0], matDimension[3] - matDimension[1]);

//  //draw the cubes
//  pushMatrix();
//  translate(xOffset, yOffset);
  
//  for (int i = 0; i < nCubes; i++) {
//    cubes[i].checkActive(now);
    
//    if (cubes[i].isActive) {
//      pushMatrix();
//      translate(cubes[i].x, cubes[i].y);
//      fill(0);
//      textSize(15);
//      text(i, 0, -20);
//      noFill();
//      rotate(cubes[i].theta * PI/180);
//      rect(-10, -10, 20, 20);
//      line(0, 0, 20, 0);
//      popMatrix();
//    }
//  }
//  popMatrix();
//  //END TEMPLATE/DEBUG VIEW
  
//  //insert code here
//}
