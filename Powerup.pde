// Powerups to augment your fighter's blasters.
// Originally were going to be missile powerups too, but ran out of time.
class Powerup {
  private float x;
  private float y;
  private float vel;
  private int layer;
  
  private ArrayList<PImage> sprites = new ArrayList<PImage>();
  private int frame;
  private int frameDelay;
  
  private boolean isAlive;
  
  // Initialises variables and sprites.
  Powerup(float xp) {
    x = xp;
    y = -10;
    vel = 4;
    layer = 2;
    frameDelay = 0;
    
    for (int i = 1; i <= 11; i++) {
      sprites.add(loadImage("data/powerup"+i+".png"));
    }
    frame = 0;
    
    isAlive = true;
  }
  
  // Moves and draws powerup
  public void update() {
    if (isAlive) {
      PImage sprite = sprites.get(frame);
      y += vel;
    
      image(sprite,x-(sprite.width/2),y-(sprite.height/2));
    
      if (frameDelay == 0) {
        if (frame < 10) { frame++; }
        else { frame = 0; }
        frameDelay = 3;
      }
      frameDelay--;
      
      if (y-(sprite.height/2) > height) { isAlive = false; }
    }
  }
  
  // Returns layer of powerup (will always be 2)
  public int getLayer() {
    return layer;
  }
  
  // Killes powerup
  public void setNotAlive() {
    isAlive = false;
  }
  
  // If alive, returns true.
  public boolean checkIfAlive() {
    return isAlive;
  }
  
  // Returns top left and bottom right x coordinates.
  public float[] getPoints() {
    float[] points = new float[4];
    PImage sprite = sprites.get(0);
    points[0] = x - (sprite.width/2);
    points[1] = y - (sprite.height/2);
    points[2] = x + (sprite.width/2);
    points[3] = y + (sprite.height/2);
    return points;
  }
}
