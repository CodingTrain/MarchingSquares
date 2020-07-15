import processing.video.*;

float[][] field;
int rez = 10;
int cols, rows;

Movie mov;
//int newFrame = 0;

void movieEvent(Movie mov) {
  mov.read();
}


void setup() {
  size(640, 480);
  mov = new Movie(this, "fingers.mov");  
  mov.loop();
  //mov.jump(0);
  //mov.pause();
  cols = width / rez;
  rows = height / rez;
  field = new float[cols][rows];
}

void line(PVector v1, PVector v2) {
  line(v1.x, v1.y, v2.x, v2.y);
}

void draw() {
  image(mov, 0, 0, width, height);
  loadPixels();
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int x = i * rez;
      int y = j * rez;
      color c = pixels[x+y*width];
      float b = brightness(c);
      field[i][j] = b;
      fill(b);
      noStroke();
      rect(x, y, rez, rez);
    }
  }
  // background(255);
  for (int i = 0; i < cols-1; i++) {
    for (int j = 0; j < rows-1; j++) {
      float x = i * rez;
      float y = j * rez;
      PVector a = new PVector(x + rez * 0.5, y            );
      PVector b = new PVector(x + rez, y + rez * 0.5);
      PVector c = new PVector(x + rez * 0.5, y + rez      );
      PVector d = new PVector(x, y + rez * 0.5);

      float threshold = 0.65*255;//map(mouseX, 0, width, 0, 255);
      int c1 = field[i][j] < threshold ? 0 : 1;
      int c2 = field[i+1][j] < threshold ? 0 : 1;
      int c3 = field[i+1][j+1]  < threshold ? 0 : 1;
      int c4 = field[i][j+1] < threshold ? 0 : 1;


      int state = getState(c1, c2, c3, c4);
      stroke(0);
      //noStroke();
      //stroke(255, 100, 127);
        strokeWeight(4);
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

  //if (newFrame < getLength() - 1) newFrame++;
  //setFrame(newFrame);  
  //saveFrame("video4/video####.png");
  //if (newFrame == getLength() - 1) exit();
}

int getState(int a, int b, int c, int d) {
  return a * 8 + b * 4  + c * 2 + d * 1;
}

int getFrame() {    
  return ceil(mov.time() * 30) - 1;
}

void setFrame(int n) {
  mov.play();

  // The duration of a single frame:
  float frameDuration = 1.0 / mov.frameRate;

  // We move to the middle of the frame by adding 0.5:
  float where = (n + 0.5) * frameDuration; 

  // Taking into account border effects:
  float diff = mov.duration() - where;
  if (diff < 0) {
    where += diff - 0.25 * frameDuration;
  }

  mov.jump(where);
  mov.pause();
}  

int getLength() {
  return int(mov.duration() * mov.frameRate);
}
