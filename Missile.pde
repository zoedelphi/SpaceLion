// Ground missiles, used by the player only
class Missile {
  private float x;
  private float y;
  private float vel;
  private float timeTraveled;
  private float lifetime;
  
  private float strength;
  
  private boolean isAlive;
  private boolean isFriendly;
  private boolean exploding;
  private int explosionState;
  private int explosionTick;
  private int layer = 1;
  
  private ArrayList<PImage> missileSprites = new ArrayList<PImage>();
  private ArrayList<PImage> explosionSprites = new ArrayList<PImage>();
  private int spriteState;
  
  // Initialises variables and sprites
  Missile(float cx, float cy, float v, boolean f, float s, float l) {
    x = cx;
    y = cy;
    vel = v;
    timeTraveled = 0;
    lifetime = l;
    strength = s;
    
    missileSprites.add(loadImage("data/missile1.png"));
    missileSprites.add(loadImage("data/missile2.png"));
    missileSprites.add(loadImage("data/missile3.png"));
    
    for (int i = 1; i <= 11; i++) {
      explosionSprites.add(loadImage("data/mExplosion"+i+"_2x.png"));
    }
    
    spriteState = 0;
    isAlive = true;
    isFriendly = f;
    exploding = false;
    explosionState = 0;
    explosionTick = 2;
  }
  
  // Draws and moves the projectile per frame.
  public void update() {
    if (timeTraveled < lifetime/2) { spriteState = 0; }
    else if (timeTraveled < (lifetime/4)*3) { 
      spriteState = 1;
      vel *= 0.9;
    }
    else { 
      spriteState = 2;
      vel *= 0.85;
      if (vel > -1) { vel += -0.1; }
    }
    
    PImage sprite = missileSprites.get(spriteState);
    
    if (!exploding) {
      y += vel;
      timeTraveled -= vel;
      image(sprite,x-(sprite.width/2),y-(sprite.width)/2);
    } else {
      explode();
    }
    
    if (checkCollision()) {
      exploding = true;
    }
  }
  
  // Checks if missile is off the screen or if it has travelled the max distance, and if so returns true.
  public boolean checkCollision() {
    PImage sprite = missileSprites.get(spriteState);
    
    if (x + sprite.width < 0 || x > width) {
      return true;
    } else if (y + sprite.height < 0 || y > height) {
      return true;  
    }
    
    if (timeTraveled >= lifetime+2) { 
      return true; 
    }
    
    return false;
  }
  
  // Plays the explosion animation when called
  public void explode() {
    vel = 0;
    exploding = true;
    if (explosionTick == 0) {
      explosionState++;
      explosionTick = 2;
    } else {
      explosionTick--;
    }
    if (explosionState <= 10) {
      PImage sprite = explosionSprites.get(explosionState);
      image(sprite,x-(sprite.width/2),y-(sprite.width)/2);
    } else {
      isAlive = false;
    }
  }
  
  // Returns true if alive
  public boolean checkIfAlive() {
    return isAlive; 
  }
  
  // Returns true if friendly
  public boolean checkIfFriendly() {
    return isFriendly; 
  }
  
  // Returns true if exploding
  public boolean checkIfExploding() {
    return exploding;
  }
}
