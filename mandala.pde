int nPoints = 60;  // Number of points
int nLayers = 9;   // Number of layers
float radius = 400;  // Initial radius
color[] cStart, cEnd; // Color arrays
float[] lerpAmts; // Color interpolation


void setup() {
  size(800, 800);
  background(0);
  strokeWeight(2);
  noFill();
  
  // Each layer gets it's own color.
  cStart = new color[nLayers];
  cEnd = new color[nLayers];
  lerpAmts = new float[nLayers];
  for (int i = 0; i < nLayers; i++) {
    cStart[i] = color(random(255), random(255), random(255));
    cEnd[i] = color(random(255), random(255), random(255));
    lerpAmts[i] = 0;
  }
}

void draw() {
  background(0);
  translate(width / 2, height / 2);
  
  // Precompute trigonometric values
  float[] cosValues = new float[nPoints];
  float[] sinValues = new float[nPoints];
  for (int i = 0; i < nPoints; i++) {
    float angle = TWO_PI / nPoints * i;
    cosValues[i] = cos(angle);
    sinValues[i] = sin(angle);
  }
  
  //Inputs
  float distToCenter = dist(mouseX, mouseY, width / 2, height / 2);
  int step = (int) map(distToCenter, 0, width / sqrt(2), 2, nPoints); // Calculate step once
  
  //Layers
  for(int layer = 0; layer < nLayers; layer++) {
    float thisRadius = map(layer, 0, nLayers, radius, 0);
    if (lerpAmts[layer] >= 1) {
      lerpAmts[layer] = 0;
      cStart[layer] = cEnd[layer];
      cEnd[layer] = color(random(255), random(255), random(255));
    }
    //Colors
    color lerpedColor = lerpColor(cStart[layer], cEnd[layer], lerpAmts[layer]);
    stroke(lerpedColor);
    lerpAmts[layer] += 0.05;
    
    //Points
    for (int i = 0; i < nPoints; i++) {
      float x = cosValues[i] * thisRadius;
      float y = sinValues[i] * thisRadius;
      
      point(x, y);
      
      // Connect to a point `step` positions ahead, wrapping around at nPoints
      int next_i = (i + step) % nPoints;
      float next_x = cosValues[next_i] * thisRadius;
      float next_y = sinValues[next_i] * thisRadius;
      
      line(x, y, next_x, next_y);
    }
  }
  fill(255);
  text("FPS: " + int(frameRate), 20 - width / 2, 20 - height / 2);
}
