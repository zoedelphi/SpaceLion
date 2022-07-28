// Handles all menus in the game
class Menu { 
  int menuCursorPos = 0;
  int currentMenu = 0;
  int nextMenu = 0;
  Player pm;
  
  // Initialises the cursor
  Menu() {
    pm = new Player(0,400);
  }

  // Draws the background, then shows a menu based on the currentMenu
  // or goes to a level.
  public void renderMenu() {
    currentLevel = 0;
    Level cl = levels.get(currentLevel);
    cl.scrollLayer(0);
    
    if (currentMenu == 0) { displayMainMenu(); }
    if (currentMenu == 1) { displayLevelSelect(); }
    if (currentMenu == 2) { displayControls(); }
    if (currentMenu == 3) { 
      pm.setY(pm.getYPos()-8);
      pm.update();
      if (pm.getYPos() < -30) { 
        currentMenu = nextMenu;
        pm.setY(400);
      }
    }
    if (currentMenu == 4) {
      inMenu = false;
      running = true;
      currentLevel = selectedLevel;
      currentMenu = 0;
    }
  }
  
  // Shows menu with choice between level select and controls
  void displayMainMenu() {
    imageMode(CENTER);
    image(loadImage("data/spacelion_logo.png"),200,200);
    imageMode(CORNER);
    
    textAlign(CENTER);
    text("2021 Zoe Picone",200,560);
    text("BG Art by Chris Cacho",200,580);
    
    text("Play",100,350);
    text("Controls",300,350);
    
    if (rightPressed) { 
      menuCursorPos = 1;
    }
    else if (leftPressed) { menuCursorPos = 0; }
    if (upPressed) {
      currentMenu = 3;
    }
    
    if (menuCursorPos == 0) {
      pm.setX(100);
    } else if (menuCursorPos == 1) {
      pm.setX(300);
    }
  
    nextMenu = menuCursorPos+1;
  
    pm.update();
    
    imageMode(CORNER);
    textAlign(CORNER);
  }

  // Displays level select
  void displayLevelSelect() {
    textAlign(CENTER);
    text("BACK",200,500);
    text("SELECT LEVEL",200,200);
    text(selectedLevel,200,300);
  
    imageMode(CENTER);
    if (selectedLevel > 1) { image(loadImage("data/leftArrow.png"),168,295); }
    if (selectedLevel < levels.size()-1) { image(loadImage("data/rightArrow.png"),230,295); }
    imageMode(CORNER);
  
    if (leftPressed) {
      if (selectedLevel > 1) { selectedLevel--; }
    } else if (rightPressed) {
      if (selectedLevel < levels.size()-1) { selectedLevel++; }
    }
    if (downPressed) { currentMenu = 0; }
    else if (upPressed) {
      currentMenu = 3;
      nextMenu = 4;
    }
  
    pm.setX(200);
    pm.update();
  
    textAlign(CORNER);
  }
  
  // Shows a quick controls tutorial
  public void displayControls() {
    textAlign(LEFT,CENTER);
    imageMode(CENTER);
    PImage border = loadImage("data/keyBorder.png");
    
    text("Z",50,100);
    image(border,55,105);
    text("Fire main blasters",80,100);
    
    text("X",50,150);
    image(border,55,155);
    text("Fire missiles",80,150);
    
    text("C",50,200);
    image(border,55,205);
    text("Deploy smart bomb",80,200);
    text("Currently not implemented!",43,225);
    
    text("Your blasters will only be able",33,275);
    text("to hit enemies on the same plane",33,300);
    text("as you, while missiles can only",33,325);
    text("hit enemies below you.",33,350);
    
    textAlign(CENTER);
    
    text("BACK",200,550);
    if (downPressed) { currentMenu = 0; }
    
    imageMode(CORNER);
    textAlign(CORNER);
    
    pm.setX(200);
    pm.setY(450);
    pm.update();
    
  }
  
  // Initialises the menu 'level'.
  void buildMenu() {
    Level m = new Level("M");
    levels.add(m);
    currentLevel = levels.indexOf(m);
    m.setupLayer(0,loadImage("data/level1_background.png"),0.5,true);
    pm.toggleCrosshair();
  }
}
