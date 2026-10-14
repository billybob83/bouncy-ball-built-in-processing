import processing.awt.PSurfaceAWT;
import java.awt.Window;

float ballX, ballY;
float ballSize = 20;
int ballColor = color(0);
int gameScreen = 0;
float gravity = 1;
float ballSpeedVert = 0;
float ballSpeedHoriz = 0;
int lastX, lastY;
boolean firstFrame = true;
float shakeX = 0, shakeY = 0;

void setup() {
  size(800, 600);
  background(255);
  ballX=width/4;
  ballY=height/5;
}

void draw() {
  if (gameScreen == 0) {
    initScreen();
  } else if (gameScreen == 1) {
    gameScreen();
}
}

void initScreen() {
  background(0);
  textAlign(CENTER);
  text("Click to start", height/3, width/2);
}

void gameScreen() {
  background(255);

  detectShake();

  ballSpeedHoriz += shakeX * 0.1;
  ballSpeedVert += shakeY * 0.1;

  ballX += ballSpeedHoriz;
  ballY += ballSpeedVert;

  ballSpeedHoriz *= 0.98;

  drawBall();
  applyGravity();
  keepInScreen();
}

public void mousePressed() {
  // if we are on the initial screen when clicked, start the game
  if (gameScreen==0) {
    startGame();
  }
}

void startGame() {
  gameScreen=1;
}

void drawBall() {
  fill(ballColor);
  ellipse(ballX, ballY, ballSize, ballSize);
}

void applyGravity() {
  ballSpeedVert += gravity;
  ballY += ballSpeedVert;
}

void makeBounceBottom(int surface) {
  ballY = surface-(ballSize/2);
  ballSpeedVert*=-0.6;
}

void makeBounceTop(int surface) {
  ballY = surface+(ballSize/2);
  ballSpeedVert*=-0.8;
}

void keepInScreen() {

  // Floor
  if (ballY + (ballSize/2) > height) {
    makeBounceBottom(height);
  }

  // Ceiling
  if (ballY - (ballSize/2) < 0) {
    makeBounceTop(0);
  }

  // Left wall
  if (ballX - (ballSize/2) < 0) {
    makeBounceLeft(0);
  }

  // Right wall
  if (ballX + (ballSize/2) > width) {
    makeBounceRight(width);
  }
}

void makeBounceLeft(int surface) {
  ballX = surface + (ballSize / 2);
  ballSpeedHoriz *= -0.8;
}

void makeBounceRight(int surface) {
  ballX = surface - (ballSize / 2);
  ballSpeedHoriz *= -0.8;
}

void detectShake() {
  PSurfaceAWT.SmoothCanvas canvas =
    (PSurfaceAWT.SmoothCanvas) surface.getNative();

  Window window = canvas.getFrame();

  java.awt.Point p = window.getLocationOnScreen();

  if (!firstFrame) {
    shakeX = p.x - lastX;
    shakeY = p.y - lastY;
  }

  lastX = p.x;
  lastY = p.y;
  firstFrame = false;
}
