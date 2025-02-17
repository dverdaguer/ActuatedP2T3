//execute code on key pressed
void generateCircle(int id) {
  int moveId = Math.abs(id - 1);
  int originalX = cubes[moveId].x;
  int originalAngle = cubes[id].theta;
  for (int i = 0; i < 10; i++) {
    // Calculate the angle for each point (spread over the semicircle)
    float angle = map(i, 0, 9, 0, PI);
    float rotAngle = map(i, 0, 9, originalAngle, originalAngle + 180);
    
    if (originalX < cubes[id].x) {
      angle = PI - angle;
    } else {
      rotAngle = originalAngle + 180 - rotAngle;
    }
    

    // Calculate x, y coordinates
    float x = cubes[id].x + 75 * cos(angle);
    float y = cubes[id].y - 75 * sin(angle);
    
    cubes[id].target(cubes[id].x, cubes[id].y, (int) rotAngle);
    cubes[moveId].target((int) x, (int) y, (int) rotAngle + 180);
    delay(100);
    
    //print((int) rotAngle + "\n");
    //ellipse(x, y, 5, 5);
    //print((int) x + "    " + (int) y + "  \n");
  }
}

//execute code when mouse is pressed
void mousePressed() {
  if (mouseX > 45 && mouseX < matDimension[2] - xOffset && mouseY > 45 && mouseY < matDimension[2] - yOffset) {
    cubes[0].target(mouseX, mouseY, 0);
  }
  
  //insert code here;
}

//execute code when mouse is released
void mouseReleased() {
  //insert code here;
}

//execute code when button on toio is pressed
void buttonDown(int id) {
    println("Button Pressed!");
}

//execute code when button on toio is released
void buttonUp(int id) {
    println("Button Released!");
    
    delay(100);
    cubes[id].motor(115, 115, 100);
    
}

//execute code when toio detects collision
void collision(int id) {
    println("Collision Detected!");
    
    //cubes[id].sound(2, 255);
    //cubes[id].motor(-115, -115, 10);
    //delay(120);
    //cubes[id].motor(115, -115, 20);
    //delay(100);
    //cubes[id].motor(115, 115, 100);
    
}

//execute code when toio detects double tap
void doubleTap(int id) {
    println("Double Tap Detected!" + id);
    
    //insert code here
    int oppId = Math.abs(id - 1);
    if (cubes[oppId].x > cubes[id].x) {
      int[][] targets = {{cubes[id].x + 30, cubes[id].y, cubes[oppId].theta}, 
                          {cubes[id].x + 75, cubes[id].y, cubes[oppId].theta}};
      cubes[oppId].multiTarget(0, targets);
    } else {
      int[][] targets = {{cubes[id].x - 30, cubes[id].y, cubes[oppId].theta}, 
                          {cubes[id].x - 75, cubes[id].y, cubes[oppId].theta}};
      cubes[oppId].multiTarget(0, targets);
    }
}
