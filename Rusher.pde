// Dashes at you really fast enemy.
// Originally was planning to have this dash in all
// cardinal directions but ran out of time.
class Rusher extends Enemy {
  private int frames;
  private int switchAnim = 120;
  
  // initialises variables and sprites
  Rusher(float xpos) {
    x = xpos;
    y = height-32;
    yv = -10;
    frames = 20;
    ePoints = 2000;
    
    collidable = false;
    layer = 2;
    health = 20;
    isAlive = true;
    exploding = false;
    pointsGranted = false;
    
    enemySprites.add(loadImage("data/warningSign1.png"));
    enemySprites.add(loadImage("data/warningSign2.png"));
    enemySprites.add(loadImage("data/enemyRR1.png"));
    for (int i = 1; i <= 5; i++) {
      deathSprites.add(loadImage("data/enemyExplosion"+i+".png"));
    }
  }
  
  // Draws and moves enemy per frame
  public void update() {
    if (health <= 0 || y < 0) {
      isAlive = false;
    }
    if (health <= 0) {
      exploding = true;
      if (pointsGranted == false) {
        points += ePoints;
        pointsGranted = true;
      }
    }
    
    if (frames == 0) {
      frames = 20;
      if (switchAnim == 0) {
        collidable = true;
        y = height+16;
        spriteIndex = 2;
      }
      else if (spriteIndex == 0) {
        spriteIndex = 1;
      } else if (spriteIndex == 1) {
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
      if (collidable) {
        tint(255,255);
        checkCollision();
        x += xv;
        y += yv;
      }
      
      frames--;
      switchAnim--;
    }
    
    if (exploding) {
      explode();
    }
  }
}
