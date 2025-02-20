//execute code on key pressed


//execute code when mouse is pressed
void mousePressed() {
  //if (mouseX > 45 && mouseX < matDimension[2] - xOffset && mouseY > 45 && mouseY < matDimension[2] - yOffset) {
  //  cubes[0].target(mouseX, mouseY, 0);
  //}
  
  //insert code here;
}

//execute code when mouse is released
void mouseReleased() {
  //insert code here;
}

void moveToios() {
  for (int i = 1; i < 7; i++) {
    cubes[i].target(420, i * 50 + 60, 180);
  }
  delay(5000);
  newPos = true;
}

//execute code when button on toio is pressed
void buttonDown(int id) {
    println("Button Pressed!");
    
    if (id == 0) {
      if (mode == "bikes") {
      mode = "buses";
      selectedToio = -1;
      newSelection = true;
      moveToios();
    } else if (mode == "buses") {
      mode = "bikes";
      selectedToio = -1;
      newSelection = true;
      moveToios();
    }
    } else {
      selectedToio = id;
    }

}

//execute code when button on toio is released
void buttonUp(int id) {
    println("Button Released!");
    

    
}

//execute code when toio detects collision
void collision(int id) {
    println("Collision Detected!");
    
    //cubes[id].sound(2, 255);
    //cubes[id].motor(-115, -115, 5);
    //delay(120);
    //cubes[id].motor(115, -115, 5);
    //delay(100);
    //cubes[id].motor(115, 115, 5);
    
    delay(120);
    
}

//execute code when toio detects double tap
void doubleTap(int id) {
    println("Double Tap Detected!" + id);
    
    //insert code here

}
