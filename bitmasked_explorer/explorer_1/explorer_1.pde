/**
 * Author: qp91mn64
 * License: the MIT License
 * Created: 2026-03-05
 * 
 * Modefied from bitmasked_pattern_1
 * Containing code from my sketch BitwiseColorExplorer:
 * https://github.com/qp91mn64/bitwise-color-explorer/tree/main/BitwiseColorExplorer
 * 
 * Result is one of the followings:
 *   (x & y) & bitmask
 *   (x | y) & bitmask
 *   (x ^ y) & bitmask
 * Grayscale or opaque color
 * 
 * Drag the mouse or use arrow keys: explore different parts
 * Note: don't use WASD for moving
 * 
 * 's' or 'S': save an image
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
int bitmask = 1;  // A bitmask, also an index of patterns
int xMax;
int yMax;
int xOffset = 0;
int yOffset = 0;
int whichBitwiseOperator = 3;  // 1:& 2:| 3:^
int x1 = 0;
int y1 = 0;
int x2 = 0;
int y2 = 0;
int drawAreaX0 = 100;
int drawAreaY0 = 100;
int drawAreaWidth = 512;
int drawAreaHeight = 512;
int bitCellWidth = 32;
int bitCellHeight = 32;
int rowSpace = 32;
int textsize = 32;
int bitCellWidth1 = 16;
int bitCellHeight1 = 16;
int x_x0 = drawAreaX0 - 25;
int x_y0 = drawAreaY0 - 51;
int y_x0 = drawAreaX0 - (51 - bitCellHeight1);
int y_y0 = drawAreaY0 - 25;
color colorOne = 255;
color colorZero = 0;
boolean isRunning = true;  // run/pause
boolean isInDrawArea = false;
String bitwiseString;
PImage image1;
void setup() {
  size(1000, 750);
  background(0);
  xMax = (drawAreaWidth - 1) / cellWidth + 1;  // Avoid grey egdes when `width` cannot be divided by `cellWidth`
  yMax = (drawAreaHeight - 1) / cellHeight + 1;  // Avoid grey egdes when `height` cannot be divided by `cellHeight`
  if (whichBitwiseOperator == 1) {
    bitwiseString = "AND";
  } else if (whichBitwiseOperator == 2) {
    bitwiseString = "OR";
  } else if (whichBitwiseOperator == 3) {
    bitwiseString = "XOR";
  }
  image1 = createImage(drawAreaWidth, drawAreaHeight, ARGB);
  println(image1.width*image1.height,xMax,yMax);
  println(bitwiseString, "bitmask", bitmask, binary(bitmask));
  frameRate(64);
  drawBitCells();
  drawBitwisePattern();
}
void draw() {
  if (isRunning) {
    bitmask--;  // As the change of `bitmask` a bit doesn't change the screen too much, you may use something like `bitmask-=2;` to make it change faster
  }
  stroke(191);
  line(drawAreaX0, drawAreaY0 - 2, drawAreaX0, x_y0 + bitCellHeight1 + 4);
  line(x_y0 + bitCellHeight1 + 4, drawAreaY0, drawAreaX0 - 2, drawAreaY0);
  noStroke();
  drawBitCells();
  drawBitwisePattern();
}
void mousePressed() {
  if (mouseX >= drawAreaX0 && mouseX < drawAreaX0 + drawAreaWidth && mouseY >= drawAreaY0 && mouseY < drawAreaY0 + drawAreaHeight) {
    isInDrawArea = true;
    if (x1 == 0) {
      x1 = mouseX;
      x2 = xOffset;
    }
    if (y1 == 0) {
      y1 = mouseY;
      y2 = yOffset;
    }
  } else {
    int whichBit;
    int clickX1 = mouseX - (drawAreaX0 + drawAreaWidth + 100);
    int clickY1 = mouseY - (drawAreaY0 + rowSpace / 2);
    int r1 = clickY1 / (bitCellHeight + rowSpace);
    int c1 = clickX1 / bitCellWidth;
    if (clickX1 >= 0 && clickY1 >= 0 && c1 >= 0 && c1 < 8 && clickY1 % (bitCellHeight + rowSpace) < bitCellHeight && r1 >= 0 && r1 < 4) {
      whichBit = (3 - r1) * 8 + (7 - c1);
      bitmask = bitmask ^ (1 << whichBit);
    }
    int clickX2 = mouseX - x_x0;
    int clickY2 = mouseY - x_y0;
    whichBit = 31 -  clickX2 / bitCellWidth1;
    if (clickX2 >= 0 && clickY2 >= 0 && clickY2 < bitCellHeight1 && whichBit >= 0 && whichBit < 32) {
      xOffset = xOffset ^ (1 << whichBit); 
    }
    int clickX3 = mouseX - (y_x0 - bitCellHeight1);
    int clickY3 = mouseY - y_y0;println(clickX3,clickY3);
    whichBit = 31 - clickY3 / bitCellWidth1;
    if (clickX3 >= 0 && clickX3 < bitCellHeight1 && clickY3 >= 0 && whichBit >= 0 && whichBit < 32) {
      yOffset = yOffset ^ (1 << whichBit);
    }
  }
}
void mouseDragged() {
  if (!isInDrawArea) {
    return;
  }
  if (mouseX >= drawAreaX0 && mouseX < drawAreaX0 + drawAreaWidth && mouseY >= drawAreaY0 && mouseY < drawAreaY0 + drawAreaHeight) {
    xOffset = x2 - (mouseX - x1);
    yOffset = y2 - (mouseY - y1);
  }
}
void mouseReleased() {
  isInDrawArea = false;
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
        println(bitwiseString, "bitmask", bitmask, binary(bitmask));
      }
    } else if (key == '2') {
      if (whichBitwiseOperator != 2) {
        background(0);
        whichBitwiseOperator = 2;
        bitwiseString = "OR";
        println(bitwiseString, "bitmask", bitmask, binary(bitmask));
      }
    } else if (key == '3') {
      if (whichBitwiseOperator != 3) {
        background(0);
        whichBitwiseOperator = 3;
        bitwiseString = "XOR";
        println(bitwiseString, "bitmask", bitmask, binary(bitmask));
      }
    } else if (key == 's' || key == 'S') {  // Now the uppercase `S` can be used for saving images
      PImage image2 = createImage(drawAreaWidth, drawAreaHeight, RGB);
      image2.loadPixels();
      loadPixels();
      for (int i = 0; i < drawAreaWidth * drawAreaHeight; i++) {
        int x = i % drawAreaWidth;
        int y = i / drawAreaWidth;
        image2.pixels[i] = pixels[(drawAreaY0 + y) * width + drawAreaX0 + x];
      }
      String s = String.format("your_output/explorer_1_%s_bitmask_%d_xOffset_%d_yOffset_%d_s%s.png", bitwiseString, bitmask, xOffset, yOffset, stamp());  // For distinction a stamp is used
      image2.save(s);  // Save what on the canvas directly. 
      println(String.format("Saved: %s", s));
    } else if (key == ' ') {
      if (isRunning) {
        println("bitmask", bitmask, binary(bitmask));
      }
      isRunning = !isRunning;
    }
  }
}
void drawBitwisePattern() {
  int b = 0;
  int result = 0;
  int x1;
  int y1;
  image1.loadPixels();
  for (int x = 0; x < xMax; x++) {
    for (int y = 0; y < yMax; y++) {
      x1 = x + xOffset;
      y1 = y + yOffset;
      if (whichBitwiseOperator == 1) {
        b = x1 & y1;
      } else if (whichBitwiseOperator == 2) {
        b = x1 | y1;
      } else if (whichBitwiseOperator == 3) {
        b = x1 ^ y1;
      }
      result = bitmask & b;  // Bitmask, and use the result as the color of pixels
      if (result >> 8 != 0) {  // Grayscale or opaque
        result |= -16777216;
      }
      // Use pixels[] instead of rect() for speed
      for (int dx = 0; dx < cellWidth; dx++) {
        for (int dy = 0; dy < cellHeight; dy++) {
          image1.pixels[min(y * cellHeight + dy, image1.height - 1) * image1.width + min(x * cellWidth + dx, image1.width - 1)] = color(result);
        }
      }
    }
  }
  image1.updatePixels();
  image(image1, drawAreaX0, drawAreaY0);
}
String stamp() {
  String stamp1 = year() + nf(month(), 2) + nf(day(), 2) + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);  // Timestamp to the second
  stamp1 += String.format("_%d_%d", millis(), frameCount);  // Better distinction
  return stamp1;
}
void drawBitCells() {
  pushMatrix();
  translate(drawAreaX0 + drawAreaWidth + 100, drawAreaY0);
  for (int i = 0; i < 32; i++) {
    int x = 7 - i % 8;
    int y = 3 - i / 8;
    int fillColor = (1 << i);
    int c = (bitmask & (1 << i)) >>> i;
    if (fillColor >> 24 == 0) {
      fillColor |= 0xff000000;
    }
    fill(fillColor);
    rect(x * bitCellWidth, y * (bitCellHeight + rowSpace) + rowSpace / 2, bitCellWidth, bitCellHeight);
    textSize(textsize);
    textAlign(CENTER, CENTER);
    fill(255);
    String c1 = "0";
    if (c == 1) {c1 = "1";}
    text(c1, x * bitCellWidth, y * (bitCellHeight + rowSpace) + rowSpace / 2, bitCellWidth, bitCellHeight);
  }
  popMatrix();
  textSize(16);
  textAlign(CENTER, CENTER);
  String s1 = binary(xOffset);
  for (int i = 0; i < 32; i++) {
    int bit = xOffset & (1 << (31 - i));
    if (bit == 0) {
      fill(colorZero);
      rect(x_x0 + i * bitCellWidth1, x_y0, bitCellWidth1, bitCellHeight1);
      fill(255);
      text(s1.substring(i, i+1), x_x0 + i * bitCellWidth1, x_y0, bitCellWidth1, bitCellHeight1);
    } else {
      fill(colorOne);
      rect(x_x0 + i * bitCellWidth1, x_y0, bitCellWidth1, bitCellHeight1);
      fill(0);
      text(s1.substring(i, i+1), x_x0 + i * bitCellWidth1, x_y0, bitCellWidth1, bitCellHeight1);
    }
  }
  s1 = binary(yOffset);
  pushMatrix();
  translate(y_x0, y_y0);
  rotate(PI/2);
  for (int i = 0; i < 32; i++) {
    int bit = yOffset & (1 << (31 - i));
    if (bit == 0) {
      fill(colorZero);
      rect(i * bitCellWidth1, 0, bitCellWidth1, bitCellHeight1);
      fill(255);
      text(s1.substring(i, i+1), i * bitCellWidth1, 0, bitCellWidth1, bitCellHeight1);
    } else {
      fill(colorOne);
      rect(i * bitCellWidth1, 0, bitCellWidth1, bitCellHeight1);
      fill(0);
      text(s1.substring(i, i+1), i * bitCellWidth1, 0, bitCellWidth1, bitCellHeight1);
    }
  }
  popMatrix();
}
