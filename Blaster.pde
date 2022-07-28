// Standard bullet type, used for both player and enemies
class Blaster {
  private float x;
  private float y;
  private float vel;
  private float xvel;
  
  private float strength;
  
  private boolean isAlive;
  private boolean isFriendly;
  private int layer = 2;
  
  private PImage sprite;
  
  // Initialise variables, with an x value.
  Blaster(float cx, float cy, float v, float vx, float s, boolean f, PImage spr) {
    x = cx;
    y = cy;
    vel = v;
    xvel = vx;
    strength = s;
    sprite = spr;
    
    isAlive = true;
    isFriendly = f;
    
  }
  
  // Initialise variables, without an x value.
  Blaster(float cx, float cy, float v, float s, boolean f, PImage spr) {
    x = cx;
    y = cy;
    vel = v;
    xvel = 0;
    strength = s;
    sprite = spr;
    
    isAlive = true;
    isFriendly = f;
    
  }
  
  // Draws and moves the projectile
  public void update() {
    if (isAlive) {
      y += vel;
      x += xvel;
      image(sprite,x-(sprite.width/2),y-(sprite.width)/2);
    }
    
    
    if (checkCollision()) {
      isAlive = false;
    }
  }
  
  // Checks if colliding with an edge of the screen
  public boolean checkCollision() {
    if (x + sprite.width < 0 || x > width) {
      return true;
    } else if (y + sprite.height < 0 || y > height) {
      return true;  
    }
    return false;
  }
  
  // Returns true if projectile is alive
  public boolean checkIfAlive() {
    return isAlive; 
  }
  
  // Returns true if projectile is friendly
  public boolean checkIfFriendly() {
    return isFriendly; 
  }
}
