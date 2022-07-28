// Level class, containing all events and scrolling layers.

/*
 *  If the foreground is scrolling at 2 speed, player plane will scroll at 1.5,
 *  below player plane will scroll at 1, and background will scroll at 0.5.
 *  This means that for a level consisting of 10 screens, the player plane will
 *  be (not drawn), background will be 400x4200, below player plane will be 400x6000,
 *  and foreground will be 400x8000.
 */

class Level {
  Layer[] layers = new Layer[4];
  Event[] eventLog;
  int eventIterator;
  int eventIteratorMax;
  String UID;
  
  // Creates level with unique ID
  Level(String id) {
    layers[0] = new Layer(); // background
    layers[1] = new Layer(); // below player plane
    layers[2] = new Layer(); // player plane
    layers[3] = new Layer(); // foreground
    
    UID = id;
  }
  
  // Sets up an individual layer
  public void setupLayer(int i, PImage img, float spd, boolean lp) {
    layers[i].setup(spd, img, lp);
    
    eventIterator = 0; // replaces layer 2
    eventLog = new Event[5200];
    eventIteratorMax = 5199;
    // This is how long levels should be.... 
    // but I'm rushing this on the last day so the levels are halved.
    // At least I can reuse background art for the second stage
    //eventLog = new Event[11200];
    //eventIteratorMax = 11199;
  }
  
  // Scrolls every layer in the game, and processes events.
  public void scrollAllLayers() {
    for (int i = 0; i < layers.length; i++) {
      layers[i].update();
    }
    
    checkForEvent(eventIterator);
    if (eventIterator < eventIteratorMax) {
      eventIterator++;
    } else {
      //eventIterator = 0;
    }
  }
  
  // Scrolls an individual layer
  public void scrollLayer(int i) {
    layers[i].update();
  }
  
  // Processes events (and gives one point per tick)
  public void pageEvents() {
    checkForEvent(eventIterator);
    if (eventIterator < eventIteratorMax) {
      eventIterator++;
    } else {
      
    }
    if (gameOver != true) {
      points++;
    }
  }
  
  // If there is an event on i tick, add it to the game loop
  public void checkForEvent(int i) {
    if (eventLog[i] != null) {
      if (eventLog[i].isEnemy()) {
        allEnemies.add(eventLog[i].getEnemy());
      } else {
        allPowerups.add(eventLog[i].getPowerup());
      }
    }
  }
  
  // Adds event to the array at pos
  public void addEvent(Event e, int pos) {
    if (e != null) {
      eventLog[pos] = e;
    }
  }
  
  // Returns speed of layer
  public float getSpeedOfLayer(int i) {
    if (i == 2) { return 1.5; }
    else return layers[i].getScrollSpeed();
  }
  
  // Adds an image to multi-image layers
  public void addImageToLayer(int i, PImage img) {
    layers[i].addImage(img);
  }
  
  // Returns the current event position
  public int returnEventPos() {
    return eventIterator;
  }
  
  // If level is complete, returns true.
  public boolean checkLevelFinished() {
    if (eventIterator == eventIteratorMax) {
      return true;
    }
    return false;
  }
  
  // Returns unique ID
  public String getUID() {
    return UID;
  }
  
  public void reset() {
    eventIterator = 0;
    for (int i = 0; i < layers.length; i++) {
      layers[i].reset();
    }
  }
}
