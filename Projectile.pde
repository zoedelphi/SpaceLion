// Wrapper class for missiles and blasters so I don't have to think about it.
class Projectile {
  
  public Missile missile;
  public Blaster blaster;
  
  // Creates a blaster
  Projectile(Blaster b) {
    blaster = b;
    missile = null;
  }
  
  // Creates a missile
  Projectile(Missile m) {
    missile = m;
    blaster = null;
  }
  
  // Returns true if blaster
  public boolean isBlaster() {
    if (blaster != null) { return true; }
    return false;
  }
  
  // Returns true if missile
  public boolean isMissile() {
    if (missile != null) { return true; }
    return false;
  }
  
  // Returns layer of projectile
  public int getLayer() {
    if (missile != null) { return missile.layer; }
    else if (blaster != null) { return blaster.layer; }
    return -1;
  }
  
  // Returns x coordinate of projectile
  public float getX() {
    if (missile != null) { return missile.x; }
    else if (blaster != null) { return blaster.x; }
    else return -1;
  }
  
  // Returns y coordinate of projectile
  public float getY() {
    if (missile != null) { return missile.y; }
    else if (blaster != null) { return blaster.y; }
    else return -1;
  }
  
  // Returns width of sprite
  public float getSpriteWidth() {
    if (missile != null) {
      return missile.missileSprites.get(missile.spriteState).width;
    } else if (blaster != null) {
      return blaster.sprite.width; 
    } else return -1;
  }
  
  // Returns height of sprite
  public float getSpriteHeight() {
    if (missile != null) {
      return missile.missileSprites.get(missile.spriteState).height;
    } else if (blaster != null) {
      return blaster.sprite.height; 
    } else return -1;
  }
  
  // Returns strength (damage value) of sprite
  public float getStrength() {
    if (missile != null) { return missile.strength; } 
    else if (blaster != null) { return blaster.strength; }
    else return 0;
  }
  
  // If friendly, returns true
  public boolean checkIfFriendly() {
    if (missile != null) { return true; }
    else if (blaster != null) { return blaster.checkIfFriendly(); }
    else return false;
  }
  
  // If collidable, returns true
  public boolean checkIfCollidable() {
    if (blaster != null) { return true; }
    else if (missile != null) { return missile.checkIfExploding(); }
    else return false;
  }
  
  // If exploding, returns true
  public boolean checkIfExploding() {
    if (blaster != null) { return false; }
    else if (missile !=null) { return missile.checkIfExploding(); }
    else return false;
  }
  
  // Kills projectile
  public void setNotAlive() {
    if (missile != null) { missile.isAlive = false; }
    else if (blaster != null) { blaster.isAlive = false; }
  }
}
