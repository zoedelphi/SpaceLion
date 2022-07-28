// Scrolling plane that comprises a level
class Layer {
  private float scrollSpeed;
  PImage bgimage;
  ArrayList<PImage> bgList = new ArrayList<PImage>();
  boolean loop;
  int imageIndex;
  
  float position;
  
  // Blank constructor (layers are automatically created
  // alongside a new level)
  Layer(){
    
  }
  
  // Initialises variables and adds image if provided
  public void setup(float s, PImage i, boolean lp) {
    scrollSpeed = s;
    bgimage = i;
    loop = lp;
    
    if (bgimage != null) {
      position = bgimage.height;
    }
  }
  
  // Returns scroll speed
  public float getScrollSpeed() {
    return scrollSpeed;
  }
  
  // Scrolls the level, paging through any images.
  public void update() {
    if ((bgimage == null && bgList.size() == 0) || scrollSpeed < 0) { return; }
    
    // for multi-image layers
    if (bgList.size() > 0) {
      PImage image = bgList.get(imageIndex);
      PImage image2;
      if (imageIndex > 0) { image2 = bgList.get(imageIndex-1); }
      else { image2 = null; }
      
      if (imageIndex > 0) {
        image(image,0,height-position);
        // It's highlighted yellow but image2 will never be accessed if null
        image(image2,0,height-position-image2.height);
        position -= scrollSpeed;
        if (position < 0) { 
          imageIndex--; 
          position = image2.height;
        }
      } else {
        image(image,0,height-position);
      }
      return;
    }
    
    // for single-image layers
    if (position >= height) {
      position -= scrollSpeed;
      image(bgimage,0,height-position);
    } else if (loop) {
      if (position >= 0) {
        position -= scrollSpeed;
        image(bgimage,0,height-position);
        image(bgimage,0,height-position-bgimage.height);
      } else {
        position = bgimage.height;
      }
    }
  }
  
  // Returns the total height of all images
  public int getLength() {
    if (bgimage != null) { return bgimage.height; }
    else if (bgList.size() > 0) {
      int sz = 0;
      for (int i = 0; i < bgList.size(); i++) {
        sz += bgList.get(i).height;
      }
      return sz;
    }
    else { return 0; }
  }
  
  // Adds image to the list of images comprising the background
  public void addImage(PImage img) {
    bgList.add(img);
    imageIndex = bgList.size()-1;
    position = img.height;
  }
  
  // Resets scrolling and image.
  public void reset() {
    if (bgList.size() > 0) {
      imageIndex = bgList.size()-1;
      position = bgList.get(bgList.size()-1).height;
    } else {
      if (bgimage != null) { position = bgimage.height; }
    }
    
  }
}
