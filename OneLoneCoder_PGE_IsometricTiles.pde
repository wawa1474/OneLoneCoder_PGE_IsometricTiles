color RED = color(255, 0, 0);
color BLUE = color(0, 0, 255);
color GREEN = color(0, 255, 0);
color YELLOW = color(255, 255, 0);
color WHITE = color(255);
color BLACK = color(0);


PVectorI vWorldSize = new PVectorI(14, 10);
PVectorI vTileSize = new PVectorI(40, 20);
PVectorI vOrigin = new PVectorI(5, 1);
PVectorI vSelected;
PImage tmp;
int[] pWorld = new int[vWorldSize.x * vWorldSize.y];
PImage sprIsom;

void setup(){
  //size(512, 480);
  size(1024, 960);
  sprIsom = loadImage("isometric_demo.png");
}

void draw(){
  pushMatrix();
  scale(2);
  
  //image(sprIsom, 0,0);
  
  background(WHITE);

  // Get Mouse in world
  PVectorI vMouse = new PVectorI(mouseX/2, mouseY/2);
  
  // Work out active cell
  PVectorI vCell = new PVectorI(vMouse.x / vTileSize.x, vMouse.y / vTileSize.y);

  // Work out mouse offset into cell
  PVectorI vOffset = new PVectorI(vMouse.x % vTileSize.x, vMouse.y % vTileSize.y);

  // Sample into cell offset colour
  color col = sprIsom.get(3 * vTileSize.x + vOffset.x, vOffset.y);

  // Work out selected cell by transforming screen cell
  vSelected = new PVectorI
  (
    (vCell.y - vOrigin.y) + (vCell.x - vOrigin.x),
    (vCell.y - vOrigin.y) - (vCell.x - vOrigin.x) 
  );

  // "Bodge" selected cell by sampling corners
  if (col == RED) vSelected.add(new PVectorI(-1, +0));
  if (col == BLUE) vSelected.add(new PVectorI(+0, -1));
  if (col == GREEN) vSelected.add(new PVectorI(+0, +1));
  if (col == YELLOW) vSelected.add(new PVectorI(+1, +0));
  
  // Draw World - has binary transparancy so enable masking
  //SetPixelMode(olc::Pixel::MASK);

  // (0,0) is at top, defined by vOrigin, so draw from top to bottom
  // to ensure tiles closest to camera are drawn last
  for (int y = 0; y < vWorldSize.y; y++)
  {
    for (int x = 0; x < vWorldSize.x; x++)
    {
      // Convert cell coordinate to world space
      PVectorI vWorld = ToScreen(x, y);
      tmp = createImage(vTileSize.x, vTileSize.y, ARGB);//create a temporary image
      int tmpY = vWorld.y;
      
      switch(pWorld[y*vWorldSize.x + x])
      {
      case 0:
        // Invisble Tile
        //image(vWorld.x, vWorld.y, sprIsom, 1 * vTileSize.x, 0, vTileSize.x, vTileSize.y);
        tmp.copy(sprIsom, 1 * vTileSize.x, 0, vTileSize.x, vTileSize.y, 0, 0, vTileSize.x, vTileSize.y);
        break;
      case 1:
        // Visible Tile
        //DrawPartialSprite(vWorld.x, vWorld.y, sprIsom, 2 * vTileSize.x, 0, vTileSize.x, vTileSize.y);
        tmp.copy(sprIsom, 2 * vTileSize.x, 0, vTileSize.x, vTileSize.y, 0, 0, vTileSize.x, vTileSize.y);
        break;
      case 2:
        // Tree
        //DrawPartialSprite(vWorld.x, vWorld.y - vTileSize.y, sprIsom, 0 * vTileSize.x, 1 * vTileSize.y, vTileSize.x, vTileSize.y * 2);
        tmp = createImage(vTileSize.x, vTileSize.y * 2, ARGB);
        tmp.copy(sprIsom, 0 * vTileSize.x, 1 * vTileSize.y, vTileSize.x, vTileSize.y * 2, 0, 0, vTileSize.x, vTileSize.y * 2);
        tmpY = vWorld.y - vTileSize.y;
        break;
      case 3:
        // Spooky Tree
        //DrawPartialSprite(vWorld.x, vWorld.y - vTileSize.y, sprIsom, 1 * vTileSize.x, 1 * vTileSize.y, vTileSize.x, vTileSize.y * 2);
        tmp = createImage(vTileSize.x, vTileSize.y * 2, ARGB);
        tmp.copy(sprIsom, 1 * vTileSize.x, 1 * vTileSize.y, vTileSize.x, vTileSize.y * 2, 0, 0, vTileSize.x, vTileSize.y * 2);
        tmpY = vWorld.y - vTileSize.y;
        break;
      case 4:
        // Beach
        //DrawPartialSprite(vWorld.x, vWorld.y - vTileSize.y, sprIsom, 2 * vTileSize.x, 1 * vTileSize.y, vTileSize.x, vTileSize.y * 2);
        tmp = createImage(vTileSize.x, vTileSize.y * 2, ARGB);
        tmp.copy(sprIsom, 2 * vTileSize.x, 1 * vTileSize.y, vTileSize.x, vTileSize.y * 2, 0, 0, vTileSize.x, vTileSize.y * 2);
        tmpY = vWorld.y - vTileSize.y;
        break;
      case 5:
        // Water
        //DrawPartialSprite(vWorld.x, vWorld.y - vTileSize.y, sprIsom, 3 * vTileSize.x, 1 * vTileSize.y, vTileSize.x, vTileSize.y * 2);
        tmp = createImage(vTileSize.x, vTileSize.y * 2, ARGB);
        tmp.copy(sprIsom, 3 * vTileSize.x, 1 * vTileSize.y, vTileSize.x, vTileSize.y * 2, 0, 0, vTileSize.x, vTileSize.y * 2);
        tmpY = vWorld.y - vTileSize.y;
        break;
      }
      image(tmp, vWorld.x, tmpY);
    }
  }

  // Draw Selected Cell - Has varying alpha components
  //SetPixelMode(olc::Pixel::ALPHA);

  // Convert selected cell coordinate to world space
  PVectorI vSelectedWorld = ToScreen(vSelected.x, vSelected.y);

  // Draw "highlight" tile
  //DrawPartialSprite(vSelectedWorld.x, vSelectedWorld.y, sprIsom, 0 * vTileSize.x, 0, vTileSize.x, vTileSize.y);
  tmp = createImage(vTileSize.x, vTileSize.y, ARGB);
  tmp.copy(sprIsom, 0, 0, vTileSize.x, vTileSize.y, 0, 0, vTileSize.x, vTileSize.y);
  image(tmp, vSelectedWorld.x, vSelectedWorld.y);

  // Go back to normal drawing with no expected transparency
  //SetPixelMode(olc::Pixel::NORMAL);

  // Draw Hovered Cell Boundary
  //DrawRect(vCell.x * vTileSize.x, vCell.y * vTileSize.y, vTileSize.x, vTileSize.y, olc::RED);
      
  // Draw Debug Info
  fill(BLACK);
  text("Mouse   : " + str(vMouse.x) + ", " + str(vMouse.y), 4, 10);
  text("Cell    : " + str(vCell.x) + ", " + str(vCell.y), 4, 20);
  text("Selected: " + str(vSelected.x) + ", " + str(vSelected.y), 4, 30);
  
  popMatrix();
}

// Labmda function to convert "world" coordinate into screen space
PVectorI ToScreen(int x, int y)
{      
  return new PVectorI
  (
    (vOrigin.x * vTileSize.x) + (x - y) * (vTileSize.x / 2),
    (vOrigin.y * vTileSize.y) + (x + y) * (vTileSize.y / 2)
  );
};

class PVectorI{
  int x, y;
  
  PVectorI(int x_, int y_){
    x = x_;
    y = y_;
  }
  
  PVectorI add(PVectorI v) {
    x += v.x;
    y += v.y;
    return this;
  }
}

void mousePressed(){
  // Handle mouse click to toggle if a tile is visible or not
  if (mouseButton == LEFT)
  {
    // Guard array boundary
    if (vSelected.x >= 0 && vSelected.x < vWorldSize.x && vSelected.y >= 0 && vSelected.y < vWorldSize.y){
      pWorld[vSelected.y * vWorldSize.x + vSelected.x]++;
      pWorld[vSelected.y * vWorldSize.x + vSelected.x] %= 6;
    }
  }
  
  if (mouseButton == RIGHT)
  {
    // Guard array boundary
    if (vSelected.x >= 0 && vSelected.x < vWorldSize.x && vSelected.y >= 0 && vSelected.y < vWorldSize.y){
      if(pWorld[vSelected.y * vWorldSize.x + vSelected.x] == 0){
        pWorld[vSelected.y * vWorldSize.x + vSelected.x] = 5;
      }else{
        pWorld[vSelected.y * vWorldSize.x + vSelected.x]--;
      }
      pWorld[vSelected.y * vWorldSize.x + vSelected.x] %= 6;
    }
  }
}