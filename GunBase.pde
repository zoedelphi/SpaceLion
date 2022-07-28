// Ground anti-aircraft enemy
class GunBase extends Enemy {
  // layer 1 baby!
  private int direction;
  
  private int fireDelay;
  
  // Initialises variables
  GunBase(float xpos, float ypos) {
    x = xpos;
    y = ypos;
    
    layer = 1;
    xv = 0;
    yv = -1;
    
    fireDelay = 0;
    ePoints = 500;
    
    collidable = true;
    direction = 0;
    health = 40;
    isAlive = true;
    exploding = false;
    pointsGranted = false;
    
    if (direction == 0) { spriteIndex = 0; }
    
    for (int i = 1; i <= 8; i++) {
      enemySprites.add(loadImage("data/enemyGB"+i+".png"));
    }
    for (int i = 1; i <= 5; i++) {
      deathSprites.add(loadImage("data/enemyExplosion"+i+".png"));
    }
    projectileSprite = loadImage("data/enemy2Bullet.png");
  }
  
  // Draws and moves object
  public void update() {
    spriteIndex = direction;
    
    if (health <= 0) {
      isAlive = false;
      exploding = true;
      if (pointsGranted == false) {
        points += ePoints;
        pointsGranted = true;
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
      if (int(random(10)) == 1) { move(); }
      if (int(random(10)) == 1) { fire(); }
      y -= yv;
    }
    
    if (exploding) {
      explode();
    }
  }
  
  // Changes direction object is facing based on player direction
  public void move() {
    if ((x - playerx) > -40 && (x - playerx) < 40 && y < playery) {
      direction = 0;
    } else if ((x-playerx) >= 40 && y < playery) {
      direction = 7;
    } else if ((y-playery) > -40 && (y-playery) < 40 && x > playerx) {
      direction = 6;
    } else if ((x-playerx) >= 40 && y > playery) {
      direction = 5;
    } else if ((x-playerx) > -40 && (x - playerx) < 40 && y < playery) {
      direction = 4;
    } else if ((x-playerx) <= -40 && y > playery) {
      direction = 3;
    } else if ((y-playery) > -40 && (y-playery) < 40 && x < playerx) {
      direction = 2;
    } else if ((y-playerx) <= -40 && y < playery) {
      direction = 1;
    }
  }
  
  // Fires projectiles in the current direction
  public void fire() {
    if (fireDelay == 0) {
      if (direction == 0) {
        projectiles.addBlaster(new Blaster(x, y+8, 3, 0, 10, false, projectileSprite));
      } else if (direction == 1) {
        projectiles.addBlaster(new Blaster(x+6, y+6, 2.1, 2.1, 10, false, projectileSprite));
      } else if (direction == 2) {
        projectiles.addBlaster(new Blaster(x+8, y, 0, 3, 10, false, projectileSprite));
      } else if (direction == 3) {
        projectiles.addBlaster(new Blaster(x+6, y-6, -2.1, 2.1, 10, false, projectileSprite));
      } else if (direction == 4) {
        projectiles.addBlaster(new Blaster(x, y-8, -3, 0, 10, false, projectileSprite));  
      } else if (direction == 5) {
        projectiles.addBlaster(new Blaster(x-6, y-6, -2.1, -2.1, 10, false, projectileSprite));
      } else if (direction == 6) {
        projectiles.addBlaster(new Blaster(x-8, y, 0, -3, 10, false, projectileSprite));
      } else if (direction == 7) {
        projectiles.addBlaster(new Blaster(x-6, y+6, 2.1, -2.1, 10, false, projectileSprite));
      }
      fireDelay = 12;
    } else {
      fireDelay--; 
    }
  }
}
