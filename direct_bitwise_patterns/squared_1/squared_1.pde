/**
 * Author: qp91mn64
 * License: the MIT License
 * Created: 2026-02-26
 * 
 * Modefied from c_bitwise_9 for its structure
 * 
 * Result is one of the followings:
 *   (x & y) * (x & y)
 *   (x | y) * (x | y)
 *   (x ^ y) * (x ^ y)
 * Grayscale or opaque color
 *
 * Drag the mouse or use arrow keys: explore different parts
 * Note: don't use WASD for moving
 * 
 * Bitwise operation, square, & a to extract bits, result used as color
 * Pretty complex patterns
 * 
 * 's' or 'S': to save an image
 * space key ' ': pause/run
 * Note: clicking doesn't change `a`
 * 
 * See different bitwise patterns:
 * Press '1': bitwise AND &
 * Press '2': bitwise OR |
 * Press '3': bitwise XOR ^ (default)
 */
int cellWidth = 1;
int cellHeight = 1;
int xMax;
int yMax;
int xOffset = 0;
int yOffset = 0;
int whichBitwiseOperator = 3;  // 1:& 2:| 3:^
int x1 = 0;
int y1 = 0;
int x2 = 0;
int y2 = 0;
boolean isRunning = true;  // run/pause
String bitwiseString;
PImage image1;
void setup() {
  size(512, 512);
  noStroke();
  xMax = (width - 1) / cellWidth + 1;  // Avoid grey egdes when `width` cannot be divided by `cellWidth`
  yMax = (height - 1) / cellHeight + 1;  // Avoid grey egdes when `height` cannot be divided by `cellHeight`
  if (whichBitwiseOperator == 1) {
    bitwiseString = "AND";
  } else if (whichBitwiseOperator == 2) {
    bitwiseString = "OR";
  } else if (whichBitwiseOperator == 3) {
    bitwiseString = "XOR";
  }
  image1 = createImage(width, height, ARGB);
  println(bitwiseString);
  frameRate(64);
}
void draw() {
  int b = 0;
  int result = 0;
  int x1;
  int y1;
  background(0);  // Clear the display window
  image1.loadPixels();
  for (int x = 0; x < xMax; x++) {
    for (int y = 0; y < yMax; y++) {
      // Calculate values near 4096
      x1 = x + xOffset - x2;
      y1 = y + yOffset - y2;
      if (whichBitwiseOperator == 1) {
        b = x1 & y1;
      } else if (whichBitwiseOperator == 2) {
        b = x1 | y1;
      } else if (whichBitwiseOperator == 3) {
        b = x1 ^ y1;
      }
      result = b * b;  // Bitmask, and use the result as the color of pixels
      if (result >> 8 != 0) {  // Grayscale or opaque
        result |= -16777216;
      }
      // Use pixels[] instead of rect() for speed
      for (int dx = 0; dx < cellWidth; dx++) {
        for (int dy = 0; dy < cellHeight; dy++) {
          image1.pixels[min(y * cellHeight + dy, height - 1) * width + min(x * cellWidth + dx, width - 1)] = color(result);
        }
      }
    }
  }
  image1.updatePixels();
  image(image1, 0, 0);
}
void mousePressed() {
  if (x1 == 0) {x1 = mouseX;}
  if (y1 == 0) {y1 = mouseY;}
}
void mouseDragged() {
  x2 = mouseX - x1;
  y2 = mouseY - y1;
}
void mouseReleased() {
  xOffset -= x2;
  yOffset -= y2;
  x2 = 0;
  y2 = 0;
  x1 = 0;
  y1 = 0;
  // Sometimes the binary form (2's complement) is useful to display specific patterns
  println("xOffset:", xOffset, binary(xOffset));
  println("yOffset:", yOffset, binary(yOffset));
}
void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      xOffset++;
      println("xOffset:", xOffset, binary(xOffset));
    } else if (keyCode == LEFT) {
      xOffset--;
      println("xOffset:", xOffset, binary(xOffset));
    } else if (keyCode == UP) {
      yOffset--;
      println("yOffset:", yOffset, binary(yOffset));
    } else if (keyCode == DOWN) {
      yOffset++;
      println("yOffset:", yOffset, binary(yOffset));
    }
  }
  else {
    if (key == '1') {
      if (whichBitwiseOperator != 1) {
        background(0);
        whichBitwiseOperator = 1;
        bitwiseString = "AND";
        println(bitwiseString);
      }
    } else if (key == '2') {
      if (whichBitwiseOperator != 2) {
        background(0);
        whichBitwiseOperator = 2;
        bitwiseString = "OR";
        println(bitwiseString);
      }
    } else if (key == '3') {
      if (whichBitwiseOperator != 3) {
        background(0);
        whichBitwiseOperator = 3;
        bitwiseString = "XOR";
        println(bitwiseString);
      }
    } else if (key == 's' || key == 'S') {  // Now the uppercase `S` can be used for saving images
      String s = String.format("your_output/squared_1_%s_xOffset_%d_yOffset_%d_s%s.png", bitwiseString, xOffset, yOffset, stamp());  // For distinction a stamp is used
      save(s);  // Save what on the canvas directly. 
      println(String.format("Saved: %s", s));
    } else if (key == ' ') {
      isRunning = !isRunning;
    }
  }
}
String stamp() {
  String stamp1 = year() + nf(month(), 2) + nf(day(), 2) + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);  // Timestamp to the second
  stamp1 += String.format("_%d_%d", millis(), frameCount);  // Better distinction
  return stamp1;
}
