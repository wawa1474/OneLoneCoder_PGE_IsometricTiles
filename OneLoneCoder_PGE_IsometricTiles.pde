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

PImage[] tiles;
int tileWidth = 40;
int tileHeight = 40;

PImage sprIsom;
PImage cursor;
PImage cursorBruteForce;

int[] pWorld = new int[vWorldSize.x * vWorldSize.y];

boolean selectedBehind = false;//is the selection cursor shown behind other tiles

void setup(){
  //size(512, 480);
  size(1024, 960);
  sprIsom = loadImage("isometric_demo2.png");
  tiles = splitTiles2(sprIsom);
  sprIsom = null;
  
  cursor = loadImage("cursor.png");
  cursorBruteForce = loadImage("bruteForce.png");
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

  // Work out selected cell by transforming screen cell
  vSelected = new PVectorI(
    (vCell.y - vOrigin.y) + (vCell.x - vOrigin.x),
    (vCell.y - vOrigin.y) - (vCell.x - vOrigin.x) 
  );
  
  // Sample into cell offset colour
  color col = cursorBruteForce.get(vOffset.x, vOffset.y);

  // "Bodge" selected cell by sampling corners
  if(col == RED){ vSelected.add(-1, +0);}
  if(col == BLUE){ vSelected.add(+0, -1);}
  if(col == GREEN){ vSelected.add(+0, +1);}
  if(col == YELLOW){ vSelected.add(+1, +0);}

  // (0,0) is at top, defined by vOrigin, so draw from top to bottom
  // to ensure tiles closest to camera are drawn last
  for(int y = 0; y < vWorldSize.y; y++){
    for(int x = 0; x < vWorldSize.x; x++){
      // Convert cell coordinate to world space
      PVectorI vWorld = ToScreen(x, y);

      image(tiles[pWorld[y*vWorldSize.x + x] + 2], vWorld.x, vWorld.y - vTileSize.y);
      
      // Draw "highlight" tile
      if(selectedBehind == true && vSelected.x == x && vSelected.y == y){
        image(cursor, vWorld.x, vWorld.y);
      }
    }
  }

  // Convert selected cell coordinate to world space
  PVectorI vSelectedWorld = ToScreen(vSelected.x, vSelected.y);

  // Draw "highlight" tile
  if(selectedBehind == false){
    image(cursor, vSelectedWorld.x, vSelectedWorld.y);
  }

  // Draw Hovered Cell Boundary
  //stroke(RED);
  //strokeWeight(1);
  //noFill();
  //rect(vCell.x * vTileSize.x, vCell.y * vTileSize.y, vTileSize.x, vTileSize.y);
      
  // Draw Debug Info
  fill(BLACK);
  text("Mouse   : " + str(vMouse.x) + ", " + str(vMouse.y), 4, 10);
  text("Cell    : " + str(vCell.x) + ", " + str(vCell.y), 4, 20);
  text("Selected: " + str(vSelected.x) + ", " + str(vSelected.y), 4, 30);
  
  popMatrix();
  
  //for(int i = 0; i < tiles.length; i++){
    //image(tiles[i], tileWidth * i, 0);
  //}
}

// Labmda function to convert "world" coordinate into screen space
PVectorI ToScreen(int x, int y){      
  return new PVectorI(
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
  
  PVectorI add(PVectorI v){
    x += v.x;
    y += v.y;
    return this;
  }
  
  PVectorI add(int x_, int y_){
    x += x_;
    y += y_;
    return this;
  }
}

void mousePressed(){
  // Handle mouse click to toggle if a tile is visible or not
  
  // Guard array boundary
  if(vSelected.x >= 0 && vSelected.x < vWorldSize.x && vSelected.y >= 0 && vSelected.y < vWorldSize.y){
    int tmp = vSelected.y * vWorldSize.x + vSelected.x;
    
    if(mouseButton == LEFT){
      pWorld[tmp]++;
      pWorld[tmp] %= 6;
    }
    
    if(mouseButton == RIGHT){
      if(pWorld[tmp] == 0){
        pWorld[tmp] = 5;
      } else {
        pWorld[tmp]--;
      }
      pWorld[tmp] %= 6;
    }
  }
}

PImage[] splitTiles2(PImage tileMap_){
  int cols = tileMap_.width / tileWidth;
  int rows = tileMap_.height / tileHeight;
  PImage[] tmpTiles = new PImage[rows * cols];
  int total = 0;
  for(int y = 0; y < rows; y++){//go through all tile map rows
    for(int x = 0; x < cols; x++){//go through all tile map columns
      PImage tmp = createImage(tileWidth, tileHeight, ARGB);//create a temporary image
      tmp.copy(tileMap_, x * tileWidth, y * tileHeight, tileWidth, tileHeight, 0, 0, tileWidth, tileHeight);//copy the tile at this xy position
      tmpTiles[total] = tmp;//copy the tile to the temporary array of tiles
      total++;//next tile
    }
  }
  return tmpTiles;
}