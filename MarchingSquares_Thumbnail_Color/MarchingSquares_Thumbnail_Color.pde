float[][] field;
int rez = 20;
int cols, rows;
float increment = 0.2;
float zoff = 0;
OpenSimplexNoise noise;

void setup() {
  size(1920, 1080);
  pixelDensity(2);
  noise = new OpenSimplexNoise();
  cols = 1+width / rez;
  rows = 1+height / rez;
  field = new float[cols][rows];
  randomSeed(4);
}

void line(PVector v1, PVector v2) {
  line(v1.x, v1.y, v2.x, v2.y);
}

void draw() {
  background(112, 50, 126); 
  float xoff = 0;
  for (int i = 0; i < cols; i++) {
    xoff += increment;
    float yoff = 0;
    for (int j = 0; j < rows; j++) {
      field[i][j] = (float)(noise.eval(xoff, yoff, zoff));
      yoff += increment;
    }
  }

  zoff += 0.025;


  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float amt = map(field[i][j], -1, 1, 0, 1);
      color c = lerpColor(color(112, 50, 126), color(240, 99, 164), amt);
      noStroke();
      fill(c);
      rectMode(CENTER);
      rect(i*rez, j*rez, rez, rez);
    }
  }

  for (int i = 0; i < cols-1; i++) {
    for (int j = 0; j < rows-1; j++) {
      float x = i * rez;
      float y = j * rez;
      int state = getState(ceil(field[i][j]), ceil(field[i+1][j]), 
        ceil(field[i+1][j+1]), ceil(field[i][j+1]));

      // Blocky
      //PVector a = new PVector(x + rez * 0.5, y            );
      //PVector b = new PVector(x + rez, y + rez * 0.5);
      //PVector c = new PVector(x + rez * 0.5, y + rez      );
      //PVector d = new PVector(x, y + rez * 0.5);

      // Interpolate
      float a_val = field[i][j] + 1;
      float b_val = field[i+1][j] + 1;
      float c_val = field[i+1][j+1] + 1;
      float d_val = field[i][j+1] + 1;      

      PVector a = new PVector();
      float amt = (1 - a_val) / (b_val - a_val);
      a.x = lerp(x, x + rez, amt);
      a.y = y;

      PVector b = new PVector();
      amt = (1 - b_val) / (c_val - b_val);
      b.x = x + rez;
      b.y = lerp(y, y + rez, amt);

      PVector c = new PVector();
      amt = (1 - d_val) / (c_val - d_val);
      c.x = lerp(x, x + rez, amt);
      c.y = y + rez;


      PVector d = new PVector();
      amt = (1 - a_val) / (d_val - a_val);
      d.x = x;
      d.y = lerp(y, y + rez, amt);   


      stroke(252, 238, 33);
      strokeWeight(8);
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

  //save("thumbnail.png");
}

int getState(int a, int b, int c, int d) {
  return a * 8 + b * 4  + c * 2 + d * 1;
}
