/**
 * Author: qp91mn64
 * License: MIT License
 * Created: 2026-02-25
 * 
 * bitwise XOR
 * 
 * a ^ b
 * For each bit of the result, it is:
 *   1 if two bits are different
 *   0 if two bits are the same
 * Click the cells above the horizontal line
 * To change the corresponding bits
 * And see how the result changes
 */
int number1 = 856621311;
int number2 = -1429409552;
int result;
int x0 = 130;
int y0 = 100;
int rowSpace = 50;
int cellWidth = 25;
int cellHeight = 64;
int colorZero = 0;
int colorOne = 255;
int textsize = 32;
int[] numbers;
void setup() {
  size(1000, 500);
  noStroke();
  numbers = new int[3];
  numbers[0] = number1;
  numbers[1] = number2;
  result = number1 ^ number2;
  numbers[2] = result;
  drawBinaryForm(numbers);
  draw1();
}
void draw() {
  background(204);
  result = numbers[0] ^ numbers[1];
  numbers[2] = result;
  drawBinaryForm(numbers);
  draw1();
}
void mousePressed() {
  if (mouseX < x0 || mouseX >= x0 + cellWidth*32 || mouseY < y0 || mouseY >= y0 + (cellHeight + rowSpace) * (numbers.length - 1)) {
    return;
  }
  if ((mouseY - y0) % (cellHeight + rowSpace) >= cellHeight) {
    return;
  }
  int whichNumber = (mouseY - y0) / (cellHeight + rowSpace);
  int whichBit = 31 - (mouseX - x0) / cellWidth;
  int bit = numbers[whichNumber] & (1 << whichBit);
  if (mouseButton == LEFT){
  if (bit == 0) {
    numbers[whichNumber] |= (1 << whichBit);  // Set the bit to 1
  } else {
    numbers[whichNumber] &= ~(1 << whichBit);  // Clear the bit
  }}
}
void drawBit(String bit, int x, int y) {
  if (bit.equals("1")) {
    fill(colorOne);
    rect(x, y, cellWidth, cellHeight);
    fill(63);
    text(bit, x, y, cellWidth, cellHeight);
  } else if (bit.equals("0")) {
    fill(colorZero);
    rect(x, y, cellWidth, cellHeight);
    fill(191);
    text(bit, x, y, cellWidth, cellHeight);
  }
}
void drawBinaryForm(int[] numbers) {
  textSize(textsize);
  textAlign(CENTER, CENTER);
  for (int i = 0; i < numbers.length; i++) {
    int number = numbers[i];
    String binaryForm = binary(number);
    for (int j = 0; j < 32; j++) {
      String bit = binaryForm.substring(j, j + 1);
      drawBit(bit, x0 + cellWidth * j, y0 + (cellHeight + rowSpace) * i);
    }
  }
}
void draw1() {
  int lineY = y0 + 2 * cellHeight + rowSpace + rowSpace / 2;
  stroke(75);
  strokeWeight(5);
  line(x0 - 100, lineY, x0 + cellWidth * 32 + 37, lineY);
  noStroke();
  fill(50);
  textSize(54);
  text("^", x0 - 73, y0 + cellHeight + rowSpace, 55, 55);
}
