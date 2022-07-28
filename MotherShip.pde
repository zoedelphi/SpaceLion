// Big lumbering very annoying enemy type.
class MotherShip extends Enemy {
  private int direction;
  
  private int fireDelay;
  
  // Initialises variables and sprites
  MotherShip(float xpos, float ypos, int dir) {
    x = xpos;
    y = ypos;
    direction = dir;
    xv = 3;
    yv = 0.5;
    
    fireDelay = 0;
    ePoints = 2000;
    
    collidable = true;
    layer = 2;
    health = 600;
    isAlive = true;
    exploding = false;
    pointsGranted = false;
    
    enemySprites.add(loadImage("data/enemyMS1.png"));
    for (int i = 1; i <= 5; i++) {
      deathSprites.add(loadImage("data/enemyExplosion"+i+".png"));
    }
    projectileSprite = loadImage("data/enemy2Bullet.png");
  }
  
  // Draws and moves enemy per frame
  public void update() {
    if (health <= 0) {
      isAlive = false;
      exploding = true;
      if (pointsGranted == false) {
        points += ePoints;
        pointsGranted = true;
      }
    }
    
    if (isAlive) {
      PImage sprite = enemySprites.get(0);
      if (flashFrames > 0) {
        tint(200,0,0);
        flashFrames--;
      }
      image(sprite,x-(sprite.width/2),y-(sprite.width)/2);
      tint(255,255);
      checkCollision();
      move();
      if ((x - playerx) > -100 && (x - playerx) < 100) {
        if (int(random(5)) == 1) { fire(); }
      }
      x += xv;
      y += yv;
    }
    
    if (exploding) {
      explode();
    }
  }
  
  // Changes direction at certain points
  public void move() {
    if (x < 50) {
      direction = 0;
    } else if (x > 350) {
      direction = 1;
    }
    if (direction == 0) { xv = 3; }
    else if (direction == 1) { xv = -3; }
  }
  
  // Fires projectiles
  public void fire() {
    if (fireDelay == 0) {
      projectiles.addBlaster(new Blaster(x, y+24, 6, 0, 10, false, projectileSprite));
      projectiles.addBlaster(new Blaster(x-8, y+20, 4.2, -4.2, 10, false, projectileSprite));
      projectiles.addBlaster(new Blaster(x+8, y+20, 4.2, 4.2, 10, false, projectileSprite));
      fireDelay = 4;
    } else {
      fireDelay--;
    }
  }
}
