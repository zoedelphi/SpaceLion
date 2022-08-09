// Class that deals with handling all projectiles on screen
class AllProjectiles {
  private ArrayList<Projectile> projectiles;
  
  // Initialise the array list
  AllProjectiles() {
    projectiles = new ArrayList<Projectile>();
  }
  
  // Draws all projectiles using respective code in class
  public void drawAllProjectiles() {
    for (Projectile shot : projectiles) {
      if (shot.isBlaster()) { shot.blaster.update(); }
      else if (shot.isMissile()) { shot.missile.update(); }
    }
  }
  
  // Draws all projectiles on a specific layer
  public void drawProjectilesOnLayer(int layer) {
    for (Projectile shot : projectiles) {
      if (shot.getLayer() == layer) {
        if (shot.isBlaster()) { shot.blaster.update(); }
        else if (shot.isMissile()) { shot.missile.update(); }
      }
    }
  }
  
  // Adds a projectile of the Blaster type
  public void addBlaster(Blaster blaster) {
    projectiles.add(new Projectile(blaster));
  }
  
  // Adds a projectile of the Missile type
  public void addMissile(Missile missile) {
    projectiles.add(new Projectile(missile));
  }
  
  // Checks collision
  public Projectile checkCollision(float x1, float y1, float x2, float y2, int layer) {
    for (Projectile shot : projectiles) {
      if ((shot.getLayer() == layer) && shot.checkIfCollidable()) {
        if ((shot.getX()>=x1) && (shot.getX()<=x2) &&
            (shot.getY()>=y1) && (shot.getY()<=y2)) {
              return shot;
          }
      }
    }
    return null;
  }
  
  // Returns amount of projectiles on screen
  public int getProjectileCount() {
    return projectiles.size();
  }
  
  // Deletes any projectiles that have reported themselves as not alive.
  public void clearNotRendered() {
    ArrayList<Projectile> toRemove = new ArrayList<Projectile>();
    for (Projectile shot : projectiles) {
      if (shot.isBlaster()) {
        if (!shot.blaster.checkIfAlive()) {
          toRemove.add(shot);
        }
      } else if (shot.isMissile()) {
        if (!shot.missile.checkIfAlive()) {
          toRemove.add(shot);
        }
      }
    }
    projectiles.removeAll(toRemove);
  }
  
  // Clears all projectiles.
  public void clearAll() {
    projectiles = new ArrayList<Projectile>();
  }
}
