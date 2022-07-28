// Container class for enemies and powerups contained in levels.
class Event {
  Enemy enemy;
  Powerup powerup;
  
  // Constructor for enemies
  Event(Enemy e) {
    enemy = e;
  }
  
  // Constructor for powerups
  Event(Powerup p) {
    powerup = p;
  }
  
  // If an enemy exists, return it
  public Enemy getEnemy() {
    if (enemy != null) { return enemy; }
    else { return null; }
  }
  
  // If a powerup exists, return it
  public Powerup getPowerup() {
    if (powerup != null) { return powerup; }
    else { return null; }
  }
  
  // Returns true if contains enemy, else returns false
  public boolean isEnemy() {
    if (enemy != null) { return true; }
    else return false;
  }
}
