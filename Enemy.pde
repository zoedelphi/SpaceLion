// Base class for any enemies
class Enemy {
  protected float x;
  protected float y;
  protected float xv;
  protected float yv;
  
  protected float playerx;
  protected float playery;
  
  protected boolean collidable;
  protected float health;
  protected boolean isAlive;
  protected boolean exploding;
  protected int explFrame = 0;
  protected int explTick = 8;
  
  protected int ePoints;
  protected boolean pointsGranted;
  
  protected int flashFrames;
  
  protected ArrayList<PImage> enemySprites = new ArrayList<PImage>();
  protected ArrayList<PImage> deathSprites = new ArrayList<PImage>();
  protected PImage projectileSprite;
  protected int spriteIndex;
  
  protected int layer;
  
  // Returns the layer of the enemy
  public int getLayer() {
    return layer; 
  }
  
  // Blank function so Mr. Compiler doesn't get mad
  public void update() {
    
  }
  
  // Sets variables for the player coordinates 
  public void setplayercoords(float px, float py) {
    playerx = px;
    playery = py;
  }
  
  // Checks if the enemy is colliding with a projectile.
  public void checkCollision() {
    PImage sprite = enemySprites.get(spriteIndex);
    Projectile proj = projectiles.checkCollision(x-(sprite.width/2),y-(sprite.height/2),x+(sprite.width/2),y+(sprite.height/2),layer);
    if (proj != null && proj.checkIfFriendly()) {
      health -= proj.getStrength();
      flashFrames = 2;
      if (!proj.checkIfExploding()) {
        proj.setNotAlive();
      }
    }
  }
  
  // Returns top left and bottom right x values.
  public float[] getPoints() {
    float[] points = new float[4];
    if (enemySprites.size() > 2 && enemySprites.get(2) != null) {
      PImage sprite = enemySprites.get(2);
      points[0] = x - (sprite.width/2);
      points[1] = y - (sprite.height/2);
      points[2] = x + (sprite.width/2);
      points[3] = y + (sprite.height/2);
      return points;
    }
    else if (enemySprites.get(0) != null) {
      PImage sprite = enemySprites.get(0);
      points[0] = x - (sprite.width/2);
      points[1] = y - (sprite.height/2);
      points[2] = x + (sprite.width/2);
      points[3] = y + (sprite.height/2);
      return points;
    }
    return null;
  }
  
  // When this command is called, runs/continues the explosion animation.
  public void explode() {
    PImage sprite = deathSprites.get(explFrame);
    y += levels.get(currentLevel).getSpeedOfLayer(layer);
    image(sprite,x-(sprite.width/2),y-(sprite.height/2));
    explTick--;
    if (explTick == 0 && explFrame+1 < deathSprites.size()-1) {
      explFrame++;
      explTick = 8;
    }
    if (y-(sprite.height/2) >= height) {
      exploding = false;
      isAlive = false;
    }
  }
  
  // If exploding, returns true.
  public boolean checkIfExploding() {
    return exploding;
  }
  
  // If alive, returns true.
  public boolean checkIfAlive() {
    return isAlive;
  }
  
  // If collidable, returns true.
  public boolean checkIfCollidable() {
    return collidable;
  }
}
