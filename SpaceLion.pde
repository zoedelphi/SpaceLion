// Game programmed by Zoe Picone
// Background art drawn by Chris Cacho
// Student ID: 300576572

Player p1;
boolean leftPressed = false;
boolean rightPressed = false;
boolean upPressed = false;
boolean downPressed = false;
boolean zPressed = false;
boolean xPressed = false;
PFont gameFont;

ArrayList<Level> levels = new ArrayList<Level>();
AllProjectiles projectiles = new AllProjectiles();
ArrayList<Enemy> allEnemies = new ArrayList<Enemy>();
ArrayList<Powerup> allPowerups = new ArrayList<Powerup>();
int currentLevel;
int points;

Menu m1;

boolean running;
boolean inMenu;
boolean gameOver;
boolean triggeredGameOver;
int gameOverTimer;
int selectedLevel = 1;

// Initialisation of variables and building the levels.
void setup() {
  size(400,600);
  frameRate(60);
  gameFont = createFont("data/5x5.ttf", 20);
  textFont(gameFont);
  currentLevel = 0;
  running = false;
  inMenu = true;
  gameOver = false;
  triggeredGameOver = false;
  gameOverTimer = 0;
  
  p1 = new Player(200,500);
  m1 = new Menu();
  m1.buildMenu();
  buildLevel1();
  buildLevel2();
}

// Main game loop.
// Far too long than it has any right to be.
void draw() {
  
  if (running) {
    Level cl = levels.get(currentLevel);
    
    background(255);
  
    if (leftPressed && rightPressed) { 
      // do nothing
    } else {
      if (leftPressed) { p1.moveLeft(); }
      if (rightPressed) { p1.moveRight(); }
    }
  
    if (upPressed && downPressed) {
      // do nothing 
    } else {
      if (upPressed) { p1.moveUp(); }
      if (downPressed) { p1.moveDown(); }
    }
  
    if (zPressed) {
      p1.fireMain();
    }
  
    if (xPressed) {
      p1.fireMissile(); 
    }
  
    cl.scrollLayer(0);
  
    cl.scrollLayer(1);
    drawEnemyLayer(1);
  
    projectiles.drawAllProjectiles();
    projectiles.clearNotRendered();
    
    drawEnemyLayer(2);
    drawPowerups();
    p1.update();  
  
    cl.pageEvents();
  
    cl.scrollLayer(3);
    
    if (cl.checkLevelFinished()) {
      if (levels.size() > currentLevel+1) {
        levels.get(currentLevel).reset();
        projectiles.clearAll();
        allEnemies = new ArrayList<Enemy>();
        allPowerups = new ArrayList<Powerup>();
        currentLevel++;
      } else {
        if (!triggeredGameOver) {
          triggeredGameOver = true;
          gameOver = true;
          gameOverTimer = 450;
          projectiles.clearAll();
          allEnemies = new ArrayList<Enemy>();
          allPowerups = new ArrayList<Powerup>();
        }
      }
    }
    
    if (!gameOver) {
      textAlign(CENTER);
      text(points,width/2,15);
    }
  
    PImage livesImage = loadImage("data/ship_lives.png");
    for (int i = 1; i <= p1.getLives(); i++) {
      image(livesImage,width-5-(livesImage.width*i),height-37);
    }
    
  }
  
  if (gameOver) {
    if (gameOverTimer > 0) {
      gameOverTimer--;
      textAlign(CENTER);
      text("GAME OVER", width/2, 275);
      text("FINAL SCORE", width/2, 325);
      text(points,width/2,350);
    } else {
      running = false;
      inMenu = true;
      gameOver = false;
      triggeredGameOver = false;
      levels.get(currentLevel).reset();
      currentLevel = 0;
      projectiles.clearAll();
      allEnemies = new ArrayList<Enemy>();
      allPowerups = new ArrayList<Powerup>();
      buildLevel1();
      buildLevel2();
      p1 = new Player(200,500);
      points = 0;
    }
  }
  
  if (inMenu) {
    m1.renderMenu();
  }
}

// Checks for keypresses
void keyPressed() {
  if (keyCode == LEFT && leftPressed == false) { leftPressed = true; }
  if (keyCode == RIGHT && rightPressed == false) { rightPressed = true; }
  if (keyCode == UP && upPressed == false) { upPressed = true; }
  if (keyCode == DOWN && downPressed == false) { downPressed = true; }
  if (key == 'z' && zPressed == false) { zPressed = true; }
  if (key == 'x' && xPressed == false) { xPressed = true; }
  if (key == 'p') { 
    textAlign(CENTER);
    text("PAUSED",200,300);
    text("PRESS M TO GO TO MENU",200,575);
    running = !running; 
  }
  if (key == 'm') {
    running = false;
    inMenu = true;
    gameOver = false;
    currentLevel = 0;
    levels.get(currentLevel).reset();
    projectiles.clearAll();
    allEnemies = new ArrayList<Enemy>();
    allPowerups = new ArrayList<Powerup>();
    buildLevel1();
    p1 = new Player(200,500);
    points = 0;
  }
  
  // debug
  //if (key == 'l') {
  //  p1.addLives();
  //}
}

// Checks for released keys
void keyReleased() {
  if (keyCode == LEFT) { leftPressed = false; }
  if (keyCode == RIGHT) { rightPressed = false; }
  if (keyCode == UP) { upPressed = false; }
  if (keyCode == DOWN) { downPressed = false; }
  if (key == 'z') { zPressed = false; }
  if (key == 'x') { xPressed = false; }
}

// Draw each layer of enemies
void drawEnemyLayer(int i) {
  ArrayList<Enemy> toRemove = new ArrayList<Enemy>();
  for (Enemy e : allEnemies) {
    if (e.getLayer() == i) {
      if (e.checkIfAlive() || e.checkIfExploding()) {
        e.setplayercoords(p1.getXPos(), p1.getYPos());
        e.update();
      } else {
        toRemove.add(e);
      }
      // if not alive and death animation finished remove
    }
  }
  allEnemies.removeAll(toRemove);
}

// Draw all powerups (all on layer 2 so no need to specify)
void drawPowerups() {
  ArrayList<Powerup> toRemove = new ArrayList<Powerup>();
  for (Powerup p : allPowerups) {
    if (p.checkIfAlive()) {
      p.update();
    } else {
      toRemove.add(p);
    }
    // if not alive remove
  }
  allPowerups.removeAll(toRemove);
}

// Builds the first level.
// As enemy coordinates are set by hand this is a very long method...
void buildLevel1() {
  Level lv = new Level("1");
  lv.setupLayer(3,loadImage("data/level1_foreground.png"),2.5,true);
  lv.setupLayer(1,null,1,true);
  lv.setupLayer(0,null,0.5,true);
  for (int i = 0; i < 2; i++) {
    for (int j = 1; j <= 10; j++) {
      lv.addImageToLayer(1,loadImage("data/level1_belowplayer/"+j+".png"));
    }
  }
  for (int i = 1; i <= 10; i++) {
    lv.addImageToLayer(0,loadImage("data/level1_background/"+i+".png"));
  }
  
  // Get ready for the spam
  
  lv.addEvent(new Event(new GunBase(75,160)), 3);
  lv.addEvent(new Event(new GunBase(325,185)), 4);
  lv.addEvent(new Event(new GunBase(75,0)),60);
  lv.addEvent(new Event(new BigGunner(20,-10,0)),300);
  lv.addEvent(new Event(new BigGunner(80,-8,0)),302);
  lv.addEvent(new Event(new BigGunner(380,-10,1)),500);
  lv.addEvent(new Event(new BigGunner(320,-8,1)),502);
  lv.addEvent(new Event(new GunBase(320,-10)),450);
  lv.addEvent(new Event(new BigGunner(150,-10,2)),700);
  lv.addEvent(new Event(new BigGunner(250,-8,2)),702);
  lv.addEvent(new Event(new Rusher(100)),703);
  lv.addEvent(new Event(new Rusher(300)),704);
  lv.addEvent(new Event(new MotherShip(50,50,1)),800);
  lv.addEvent(new Event(new GunBase(80,-10)),901);
  lv.addEvent(new Event(new GunBase(180,-10)),1100);
  lv.addEvent(new Event(new GunBase(80,-10)),1300);
  lv.addEvent(new Event(new BigGunner(30,-10,0)),1301);
  lv.addEvent(new Event(new BigGunner(370,-9,1)),1302);
  lv.addEvent(new Event(new BigGunner(75,-10,2)),1598);
  lv.addEvent(new Event(new BigGunner(325,-9,2)),1599);
  lv.addEvent(new Event(new GunBase(60,-10)),1600);
  lv.addEvent(new Event(new Rusher(200)),1699);
  lv.addEvent(new Event(new BigGunner(75,-10,2)),1749);
  lv.addEvent(new Event(new BigGunner(325,-9,2)),1750);
  lv.addEvent(new Event(new BigGunner(30,-10,2)),1800);
  lv.addEvent(new Event(new BigGunner(370,-9,2)),1801);
  lv.addEvent(new Event(new MotherShip(350,0,0)),2001);
  lv.addEvent(new Event(new GunBase(300,-10)),2135);
  lv.addEvent(new Event(new Rusher(120)),2200);
  lv.addEvent(new Event(new BigGunner(200,-10,2)),2250);
  lv.addEvent(new Event(new BigGunner(260,-9,2)),2251);
  lv.addEvent(new Event(new BigGunner(320,-8,2)),2252);
  lv.addEvent(new Event(new Rusher(280)),2350);
  lv.addEvent(new Event(new BigGunner(80,-10,0)),2400);
  lv.addEvent(new Event(new BigGunner(160,-9,2)),2401);
  lv.addEvent(new Event(new BigGunner(240,-8,2)),2402);
  lv.addEvent(new Event(new BigGunner(320,-7,1)),2403);
  lv.addEvent(new Event(new GunBase(200,-10)),2620);
  lv.addEvent(new Event(new GunBase(270,-10)),2690);
  lv.addEvent(new Event(new BigGunner(140,-10,2)),2700);
  lv.addEvent(new Event(new BigGunner(260,-9,2)),2701);
  lv.addEvent(new Event(new GunBase(295,-10)),2820);
  lv.addEvent(new Event(new Rusher(75)),2900);
  lv.addEvent(new Event(new Rusher(150)),2901);
  lv.addEvent(new Event(new BigGunner(350,-10,1)),2999);
  lv.addEvent(new Event(new BigGunner(275,-9,2)),3000);
  lv.addEvent(new Event(new MotherShip(50,0,1)),3200);
  lv.addEvent(new Event(new GunBase(315,-10)),3250);
  lv.addEvent(new Event(new BigGunner(350,-10,1)),3501);
  lv.addEvent(new Event(new GunBase(122,-10)),3635);
  lv.addEvent(new Event(new BigGunner(300,-10,2)),3750);
  lv.addEvent(new Event(new GunBase(232,-10)),3770); 
  lv.addEvent(new Event(new GunBase(160,-10)),3785);  
  lv.addEvent(new Event(new BigGunner(300,-10,2)),3825);
  lv.addEvent(new Event(new BigGunner(300,-10,2)),3900);
  lv.addEvent(new Event(new BigGunner(100,-10,2)),4100);  
  lv.addEvent(new Event(new GunBase(175,-10)),4162);
  lv.addEvent(new Event(new BigGunner(100,-10,2)),4175);
  lv.addEvent(new Event(new BigGunner(100,-10,2)),4250);
  lv.addEvent(new Event(new Rusher(200)),4399);
  lv.addEvent(new Event(new BigGunner(75,-10,0)),4400);
  lv.addEvent(new Event(new BigGunner(200,-9,2)),4401);
  lv.addEvent(new Event(new BigGunner(325,-8,1)),4402);
  lv.addEvent(new Event(new MotherShip(350,0,0)),4501);
  lv.addEvent(new Event(new Rusher(75)),4552);
  lv.addEvent(new Event(new Rusher(325)),4553);
  lv.addEvent(new Event(new GunBase(55,-10)),4700);
  lv.addEvent(new Event(new GunBase(105,-10)),4850);
  lv.addEvent(new Event(new GunBase(55,-10)),5000);

  lv.addEvent(new Event(new Powerup(200)),200);
  lv.addEvent(new Event(new Powerup(200)),900);
  lv.addEvent(new Event(new Powerup(100)),1400);
  lv.addEvent(new Event(new Powerup(300)),1700);
  lv.addEvent(new Event(new Powerup(135)),2000);
  lv.addEvent(new Event(new Powerup(325)),2600);
  lv.addEvent(new Event(new Powerup(150)),3100);
  lv.addEvent(new Event(new Powerup(160)),3500);
  lv.addEvent(new Event(new Powerup(200)),4000);
  lv.addEvent(new Event(new Powerup(200)),4500);
 
  for (Level level : levels) {
    if (level.getUID() == "1") {
      levels.set(levels.indexOf(level), lv);
      currentLevel = levels.indexOf(lv);
      return;
    }
  }
  levels.add(lv);
  currentLevel = levels.indexOf(lv);
}

// Builds the second level.
// Not much here.
void buildLevel2() {
  Level lv = new Level("2");
  lv.setupLayer(3,loadImage("data/level1_foreground.png"),2.5,true);
  lv.setupLayer(1,null,1,true);
  lv.setupLayer(0,null,0.5,true);
  for (int i = 1; i <= 10; i++) {
    lv.addImageToLayer(1,loadImage("data/level2_belowplayer/"+i+".png"));
  }
  for (int i = 1; i <= 5; i++) {
    lv.addImageToLayer(0,loadImage("data/level2_background/"+i+".png"));
  }
  
  for (Level level : levels) {
    if (level.getUID() == "2") {
      levels.set(levels.indexOf(level), lv);
      currentLevel = levels.indexOf(lv);
      return;
    }
  }
  levels.add(lv);
  currentLevel = levels.indexOf(lv);
}
