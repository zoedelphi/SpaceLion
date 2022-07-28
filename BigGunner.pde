// Standard shooty pew pew enemy type.
class BigGunner extends Enemy {
  // Direction: 0 for left side, 1 for right side, 2 for straight down
  private int direction;
  private int frames;
  
  private int fireDelay;
  
  // Initialise variables
  BigGunner(float xpos, float ypos, int dir) {
    x = xpos;
    y = ypos;
    xv = -3;
    yv = 4;
    frames = 12;
    ePoints = 100;
    
    fireDelay = 0;
    
    collidable = true;
    direction = dir;
    layer = 2;
    health = 60;
    isAlive = true;
    exploding = false;
    pointsGranted = false;
    
    if (direction == 0) { spriteIndex = 3; }
    else if (direction == 1) { spriteIndex = 6; }
    else { spriteIndex = 0; }
    
    for (int i = 1; i <= 7; i++) {
      enemySprites.add(loadImage("data/enemyBG"+i+".png"));
    }
    for (int i = 1; i <= 5; i++) {
      deathSprites.add(loadImage("data/enemyExplosion"+i+".png"));
    }
    projectileSprite = loadImage("data/enemy1Bullet.png");
  }
  
  // Draws and moves the object
  public void update() {
    if (health <= 0) {
      isAlive = false;
      exploding = true;
      if (pointsGranted == false) {
        points += ePoints;
        pointsGranted = true;
      }
    }
    
    if (frames == 0) {
      frames = 12;
      if (spriteIndex != 0 && spriteIndex != 4) {
        spriteIndex--;
      } else if (spriteIndex == 4) {
        spriteIndex = 0;
      }
    }
    
    if (isAlive) {
      PImage sprite = enemySprites.get(spriteIndex);
      if (flashFrames > 0) {
        tint(200,0,0);
        flashFrames--;
      }
      image(sprite,x-(sprite.width/2),y-(sprite.width)/2);
      tint(255,255);
      checkCollision();
      move();
      if ((x - playerx) > -40 && (x - playerx) < 40) {
        if (int(random(25)) == 1) { fire(); }
      }
      x += xv;
      y += yv;
      frames--;
    }
    
    if (exploding) {
      explode();
    }
  }
  
  // Sets velocity and chosen sprite based on a subroutine
  public void move() {
    int mv = 0;
    if (direction == 0) { mv = spriteIndex; }
    else if (direction == 1) { mv = spriteIndex-3; }
    if (frames == 0 && mv != 0) { mv--; }
    
    if (mv == 3) {
      yv = 3;
      if (direction == 0) { xv = 3; }
      else if (direction == 1) { xv = -3; }
    } else if (mv == 2) {
      yv = 3;
      if (direction == 0) { xv = 2; }
      else if (direction == 1) { xv = -2; }
    } else if (mv == 1) {
      yv = 4;
      if (direction == 0) { xv = 1; }
      else if (direction == 1) { xv = -1; }
    } else {
      yv = 4;
      xv = 0;
      
      if (int(random(100)) == 99) {
        if (playerx > x) {
          spriteIndex = 3;
          direction = 0;
        } else if (playerx < x) {
          spriteIndex = 5;
          direction = 1;
        }
      }
      
    }
  }
  
  // Fires if there is no further delay.
  public void fire() {
    if (fireDelay == 0) {
      if (spriteIndex == 0) {
        projectiles.addBlaster(new Blaster(x, y+12, 6, 10, false, projectileSprite));
      } else if (direction == 0) {
        projectiles.addBlaster(new Blaster(x+5, y+12, 6, 10, false, projectileSprite));
      } else if (direction == 1) {
        projectiles.addBlaster(new Blaster(x-5, y+12, 6, 10, false, projectileSprite));
      }
      fireDelay = 60;
    } else {
      fireDelay--; 
    }
  }
}
