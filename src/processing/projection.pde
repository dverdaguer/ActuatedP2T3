/**
 * This is a simple example of how to use the Keystone library.
 *
 * To use this example in the real world, you need a projector
 * and a surface you want to project your Processing sketch onto.
 *
 * Simply drag the corners of the CornerPinSurface so that they
 * match the physical surface's corners. The result will be an
 * undistorted projection, regardless of projector position or 
 * orientation.
 *
 * You can also create more than one Surface object, and project
 * onto multiple flat surfaces using a single projector.
 *
 * This extra flexbility can comes at the sacrifice of more or 
 * less pixel resolution, depending on your projector and how
 * many surfaces you want to map. 
 */

import deadpixel.keystone.*;

Keystone ks;
CornerPinSurface surface;

PGraphics offscreen;

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      transY = transY - 5;
      anchorY = anchorY - 5;
    }
    if (keyCode == DOWN) {
      transY = transY + 5;
      anchorY = anchorY + 5;
    }
    if (keyCode == LEFT) {
      transX = transX + 5;
      anchorX = anchorX + 5;
    }
    if (keyCode == RIGHT) {
      transX = transX - 5;
      anchorX = anchorX - 5;
    }
  }
  
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;
    
  case 't':
    mode = "trains";
    moveToios();
    break;
    
  case 'u':
    mode = "buses";
    selectedToio = -1;
    moveToios();
    break;
    
  case 'b':
    mode = "bikes";
    moveToios();
    break;
    
  case 'z':
    zoom = zoom + 6;
    anchorX = anchorX - 3;
    anchorY = anchorY - 3;
    break;
    
  case 'y':
    zoom = zoom - 6;
    anchorX = anchorX + 3;
    anchorY = anchorY + 3;
    break;
  
  case '1':
      cubes[0].target(100, 400, 90);
      break;
      
    case '2':
      cubes[0].target(200, 200, 270);
      cubes[0].target(200, 400, 270);
      //cubes[0].target(0, 200, 200, 0);
      //cubes[1].target(0, 200, 200, 0);
      //cubes[2].target(0, 200, 200, 0);
      break;
    
    case '3':
      int[][] targets = {{200, 200}, {200, 300, 90}, {300, 300}, {300, 200, 270}, {200, 200, 180}};
      cubes[0].multiTarget(0, targets);
      break;
    
    case '6':
      cubes[0].sound(2, 255);
      break;
    
    case '7':
      cubes[0].midi(10, 69, 255);
      break;
    
    case '8':
      int[][] notes = {{30, 64, 20}, {30, 63, 20}, {30, 64, 20}, {30, 63, 20}, {30, 64, 20}, {30, 63, 20}, {30, 59, 20}, {30, 62, 20}, {30, 60, 20}, {30, 57, 20}};
      cubes[0].midi(1, notes);
      break;
  }
}
