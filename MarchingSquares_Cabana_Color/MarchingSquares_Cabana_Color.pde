float[][] field;
int rez = 25;
int cols, rows;
float increment = 0.2;
float zoff = 0;
OpenSimplexNoise noise;

void setup() {
  size(1280, 720);
  noise = new OpenSimplexNoise();
  cols = 1 + width / rez;
  rows = 1 + height / rez;
  field = new float[cols][rows];
}

void line(PVector v1, PVector v2) {
  line(v1.x, v1.y, v2.x, v2.y);
}

void draw() {
  background(0); 
  float xoff = 0;
  for (int i = 0; i < cols; i++) {
    xoff += increment;
    float yoff = 0;
    for (int j = 0; j < rows; j++) {
      field[i][j] = (float)(noise.eval(xoff, yoff, zoff));
      yoff += increment;
    }
  }
  zoff += 0.02;




  //for (int i = 0; i < cols; i++) {
  //  for (int j = 0; j < rows; j++) {
  //    fill(field[i][j]*255);
  //    noStroke();
  //    rect(i*rez, j*rez, rez, rez);
  //  }
  //}

  for (int i = 0; i < cols-1; i++) {
    for (int j = 0; j < rows-1; j++) {
      float x = i * rez;
      float y = j * rez;
      PVector a = new PVector(x + rez * 0.5, y            );
      PVector b = new PVector(x + rez, y + rez * 0.5);
      PVector c = new PVector(x + rez * 0.5, y + rez      );
      PVector d = new PVector(x, y + rez * 0.5);
      int state = getState(ceil(field[i][j]), ceil(field[i+1][j]), 
        ceil(field[i+1][j+1]), ceil(field[i][j+1]));
      stroke(255);
      colorMode(HSB, 255, 255, 255);
      //if (state > 0 && state < 15)
      stroke(255, 50);
      strokeWeight(2);
      noFill();
      square(x, y, rez);
      strokeWeight(4);
      stroke(map(state, 0, 15, 0, 360), 200, 255, 255);
      switch (state) {
      case 1:  
        line(c, d);
        break;
      case 2:  
        line(b, c);
        break;
      case 3:  
        line(b, d);
        break;
      case 4:  
        line(a, b);
        break;
      case 5:  
        line(a, d);
        line(b, c);
        break;
      case 6:  
        line(a, c);
        break;
      case 7:  
        line(a, d);
        break;
      case 8:  
        line(a, d);
        break;
      case 9:  
        line(a, c);
        break;
      case 10: 
        line(a, b);
        line(c, d);
        break;
      case 11: 
        line(a, b);
        break;
      case 12: 
        line(b, d);
        break;
      case 13: 
        line(b, c);
        break;
      case 14: 
        line(c, d);
        break;
      }
    }
  }

  // saveFrame("colorful/color####.png");
}

int getState(int a, int b, int c, int d) {
  return a * 8 + b * 4  + c * 2 + d * 1;
}
