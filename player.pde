// It's you!
// While this class can technically facilitate multiple
// players, too much is hard-coded so I don't dare.
class Player {
  private int lives;
  private float MAXHEALTH = 10;
  private float health = MAXHEALTH;
  private boolean isAlive;
  private boolean invulnerable;
  private int invulnLength;
  private boolean showCrosshair;
  private boolean triggeredGameOver;
  
  private boolean showDeathAnim;
  private int deathAnimTick;
  private int deathAnimIndex;
  
  private int powerLevel;
  
  private float x;
  private float y;
  private float MINVX = 2;
  private float MINVY = 2;
  private float vx = MINVX;
  private float vy = MINVX;
  private float ax = 0;
  private float ay = 0;
  private float INERTIAVAL = 0.8;
  private float XInertia = 0;
  private float YInertia = 0;
  
  private ArrayList<PImage> sprites = new ArrayList<PImage>();
  private ArrayList<PImage> crosshairSprites = new ArrayList<PImage>();
  private ArrayList<PImage> deathAnimSprites = new ArrayList<PImage>();
  private ArrayList<PImage> blasterSprites = new ArrayList<PImage>();
  private int crosshairRange = 100;
  private int currentSpriteIndex;
  private int tick;
  
  private int layer = 2;
  
  int SHOTDELAY = 5;
  int shotTime = SHOTDELAY;
  int MISSILEDELAY = 30;
  int missileTime = MISSILEDELAY;
  
  // Initialises variables and sprites
  public Player(float cx, float cy) {
    x = cx;
    y = cy;
    sprites.add(loadImage("data/ship.png"));
    sprites.add(loadImage("data/ship2.png"));
    sprites.add(loadImage("data/ship3.png"));
    crosshairSprites.add(loadImage("data/missileCrosshair1.png"));
    crosshairSprites.add(loadImage("data/missileCrosshair2.png"));
    blasterSprites.add(loadImage("data/bullet1.png"));
    blasterSprites.add(loadImage("data/bullet2.png"));
    blasterSprites.add(loadImage("data/bullet3.png"));
    for (int i = 1; i <= 8; i++) {
      deathAnimSprites.add(loadImage("data/shipExplosion"+i+".png"));
    }
    currentSpriteIndex = 0;
    tick = 0;
    lives = 4;
    isAlive = true;
    invulnerable = false;
    invulnLength = 0;
    showCrosshair = true;
    showDeathAnim = false;
    deathAnimTick = 6;
    deathAnimIndex = 0;
    triggeredGameOver = false;
    powerLevel = 0;
  }
  
  // Draws and moves player, animates, calculates inertia, and handles death
  public void update() {
    if (isAlive) {
      if (tick == 24) {
        currentSpriteIndex = 1;
      } else if (tick == 8) {
        currentSpriteIndex = 1;
      } else if (tick == 16) {
        currentSpriteIndex = 2;
      } else if (tick == 32) {
        currentSpriteIndex = 0;
        tick = 0;
      }
    
      PImage currentSprite = sprites.get(currentSpriteIndex);
      PImage currentCrosshair = crosshairSprites.get(0);
      
      if (invulnerable) {
        tint(255, 128);
        invulnLength--;
        if (invulnLength == 0) { invulnerable = false; }
      }
      image(currentSprite,x-(currentSprite.width/2),y-(currentSprite.width)/2);
      noTint();
    
      if (showCrosshair) {
        image(currentCrosshair,x-(currentCrosshair.width/2),y-(currentSprite.width)-crosshairRange);
      }
    
      tick++;
    
      calculateXInertia();
      calculateYInertia();
      
      checkCollision();
    
      if (vx > MINVX) { vx -= (vx-MINVX/2); }
      if (vy > MINVY) { vy -= (vy-MINVY/2); }
    
      if (vx < MINVX) { vx = MINVX; }
      if (vy < MINVY) { vy = MINVY; }
    
      if (shotTime > 0) { shotTime--; }
      if (missileTime > 0) { missileTime--; }
      
      if (health <= 0) {
        isAlive = false;
        deathAnimIndex = 0;
        showDeathAnim = true;
      }
    }
    
    if (showDeathAnim) {
      if (deathAnimIndex <= 7) {
        PImage sprite = deathAnimSprites.get(deathAnimIndex);
        image(sprite,x-(sprite.width/2),y-(sprite.width)/2);
        deathAnimTick--;
        if (deathAnimTick == 0) { 
          deathAnimIndex++;
          deathAnimTick = 6;
        }
      } else {
        if (lives > 0) {
          isAlive = true;
          showDeathAnim = false;
          lives--;
          invulnerable = true;
          powerLevel = 0;
          invulnLength = 120;
          health = MAXHEALTH;
          x = 200;
          y = 500;
        } else { 
          // game over state
          if (!triggeredGameOver) {
            triggeredGameOver = true;
            gameOver = true;
            gameOverTimer = 450;
          }
        }
      } 
    }
    
  }
  
  // Checks if player is touching an enemy, powerup, or projectile.
  public void checkCollision() {
    float yoffset = sprites.get(currentSpriteIndex).height/2;
    float xoffset = sprites.get(currentSpriteIndex).width/2;
    for (Enemy e : allEnemies) {
      float[] pts = e.getPoints();
      if (((pts[0]>=x-xoffset) && (pts[1]>=y-yoffset) && (pts[0]<=x+xoffset) && (pts[1]<=y+yoffset)) ||
            ((pts[2]>=x-xoffset) && (pts[1]>=y-yoffset) && (pts[2]<=x+xoffset) && (pts[1]<=y+yoffset)) ||
            ((pts[0]>=x-xoffset) && (pts[3]>=y-yoffset) && (pts[0]<=x+xoffset) && (pts[3]<=y+yoffset)) ||
            ((pts[2]>=x-xoffset) && (pts[3]>=y-yoffset) && (pts[2]<=x+xoffset) && (pts[3]<=y+yoffset))) {
        if (!invulnerable && (e.checkIfExploding() == false) && (e.getLayer() == layer) && (e.checkIfCollidable() == true)) {
          health -= 10; 
        }
      }
    }
    for (Powerup p : allPowerups) {
      float[] pts = p.getPoints();
      if (((pts[0]>=x-xoffset) && (pts[1]>=y-yoffset) && (pts[0]<=x+xoffset) && (pts[1]<=y+yoffset)) ||
            ((pts[2]>=x-xoffset) && (pts[1]>=y-yoffset) && (pts[2]<=x+xoffset) && (pts[1]<=y+yoffset)) ||
            ((pts[0]>=x-xoffset) && (pts[3]>=y-yoffset) && (pts[0]<=x+xoffset) && (pts[3]<=y+yoffset)) ||
            ((pts[2]>=x-xoffset) && (pts[3]>=y-yoffset) && (pts[2]<=x+xoffset) && (pts[3]<=y+yoffset))) {
        if (p.getLayer() == layer) {
          if (powerLevel < 2) {
            powerLevel++; 
          }
          p.setNotAlive();
          points += 200;
        }
      }
    }
    Projectile proj = projectiles.checkCollision(x-xoffset,y-yoffset,x+xoffset,y+yoffset,layer);
    if (proj == null) { return; }
    if (!proj.checkIfFriendly()) { 
      if (!invulnerable) {
        health -= proj.getStrength(); 
        proj.setNotAlive();
      }
    }
    
  }
  
  // Moves the player left and applies inertia
  public void moveLeft() {
    if (x > 0 && isAlive) {
      vx += ax / 2;
      x -= vx;
      vx += ax / 2;
      XInertia--;
    }
  }
  
  // Moves the player right and applies inertia
  public void moveRight() {
    if (x < width && isAlive) {
      vx += ax / 2;
      x += vx;
      vx += ax / 2;
      XInertia++;
    }
  }
  
  // Moves the player forward and applies inertia
  public void moveUp() {
    if (y > height/10 && isAlive) {
      vy += ay / 2;
      y -= vy;
      vy += ay / 2;
      YInertia--;
    }
  }
  
  // Moves the player backwards and applies inertia
  public void moveDown() {
    if (y < height && isAlive) {
      vy += ay / 2;
      y += vy;
      vy += ay / 2;
      YInertia++;
    }
  }
  
  // Calculates X inertia per frame
  public void calculateXInertia() {
    if (x > 0 && x < width) {
      x += XInertia;
    }
    XInertia *= INERTIAVAL;
  }
  
  // Calculates Y inertia per frame
  public void calculateYInertia() {
    if (y > height/10 && y < height) {
      y += YInertia;
      
    }
    YInertia *= INERTIAVAL;
  }
  
  // Fires main blaster, with damage based on current powerup state
  public void fireMain() {
    PImage sprite = blasterSprites.get(powerLevel);
    if (shotTime == 0) {
      projectiles.addBlaster(new Blaster(p1.getXPos()-5, p1.getYPos()-14, -8, 20+(10*powerLevel), true, sprite));
      projectiles.addBlaster(new Blaster(p1.getXPos()+5, p1.getYPos()-14, -8, 20+(10*powerLevel), true, sprite));
      shotTime = SHOTDELAY;
    }
  }
  
  // Fires missiles
  public void fireMissile() {
    if (missileTime == 0) {
      projectiles.addMissile(new Missile(p1.getXPos(), p1.getYPos()-16, -6, true, 40, crosshairRange-20));
      missileTime = MISSILEDELAY;
    }
  }
  
  // Set X position directly
  public void setX(float newx) {
    x = newx;
  }
  
  // Set Y position directly
  public void setY(float newy) {
    y = newy; 
  }

  // Returns X position
  public float getXPos() {
    return x;
  }
  
  // Returns Y position
  public float getYPos() {
    return y;
  }
  
  // Returns number of lives
  public int getLives() {
    return lives;
  }
  
  // Adds lives (currently only used for debug)
  public void addLives() {
    lives++;
  }
  
  // Toggles missile crosshair on or off
  public void toggleCrosshair() {
    showCrosshair = !showCrosshair;
  }
}
