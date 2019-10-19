//copied from my Drag 'N' Draw Java project
/*
TO DO:
  modify to allow tiles of different sizes (mainly height)
  have tile types and multiple images for each?
    grass, trees, water, etc.
*/

ArrayList<tileMap> tileMaps = new ArrayList<tileMap>(0);//arraylist of tile maps
PImage[] tileImages = new PImage[0];//Tile Images Array
int loadedTileMap = -1;//what tile map is loaded
int tileN = 0;
int tileMapShow = 0;
int totalImages;
int fullTotalImages;
int rowLength;
int tileX = 40;
int tileY = 20;

//void drawTileMapUI(){
//  fill(BLACK);//black box
//  noStroke();//dont draw box around our black box
//  rect(UIscl * 11.5, 0, UIscl * 5, UIscl);//text box background
  
//  fill(WHITE);//white text
//  if(tileMaps.size() != 0){//if there a tile map to show
//    text(tileMaps.get(tileMapShow).tileMapName, UIscl * 12, UIscl / 2);//display tile map name
//  }else{
//    text("No Tile Maps Exist!", UIscl * 12, UIscl / 2);//display an error message
//  }
//}

//---------------------------------------------------------------------------------------------------------------------------------------

void loadTileMap(){
  if(tileMaps.size() != 0){//if a tile map exists
    tileImages = tileMaps.get(tileMapShow).splitTileMap();//split the tile map into individual tiles
    tileN = 0;//make sure we're on the first tile
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

void loadTileMapInfo(){
  String path = sketchPath() + "/assets/";//base directory
  ArrayList<File> allFiles = listFilesRecursive(path);//get all the files
  String directory = "";//what is the tile maps directory

  for(File f : allFiles) {//go through all files
    if(f.isDirectory()){//if its a directory
      directory = f.getAbsolutePath();//remember it
    }
    
    if(f.getName().endsWith(".csv")){//if its a .csv file
      loadTileMapInfo(directory, f.getAbsolutePath());//load the tile maps
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

class tileMap{
  PImage tileMapImage;//tile map image
  String tileMapLocation;//location
  int tileMapCols;//tileMapWidth
  int tileMapRows;//tileMapHeight
  int tileWidth;//tileMapTileX
  int tileHeight;//tileMapTileY
  int numImages;//images
  int colorTile;//colortile
  String tileMapName;//name
  
  public tileMap(String tileMapLocation_, int tileMapCols_, int tileMapRows_, int tileWidth_, int tileHeight_, int numImages_, int colorTile_, String tileMapName_){
    this.tileMapLocation = tileMapLocation_;
    this.tileMapCols = tileMapCols_;
    this.tileMapRows = tileMapRows_;
    this.tileWidth = tileWidth_;
    this.tileHeight = tileHeight_;
    this.numImages = numImages_;
    this.colorTile = colorTile_;
    this.tileMapName = tileMapName_;
    
    this.tileMapImage = loadImage(tileMapLocation_);
  }
  
  //ArrayList<PImage> splitTiles(){
  PImage[] splitTileMap(){
    //ArrayList<PImage> tmpTiles = new ArrayList<PImage>();
    //PImage[] tmpTiles = new PImage[this.numImages];
    //int total = 0;
    //for(int y = 0; y < this.tileMapRows; y++){//go through all tile map rows
    //  for(int x = 0; x < this.tileMapCols; x++){//go through all tile map columns
    //    PImage tmp = createImage(this.tileWidth, this.tileHeight, ARGB);//create a temporary image
    //    tmp.copy(this.tileMapImage, x * scl, y * scl, this.tileWidth, this.tileHeight, 0, 0, this.tileWidth, this.tileHeight);//copy the tile at this xy position
    //    //tmpTiles.add(tmp);
    //    tmpTiles[total] = tmp;//copy the tile to the temporary array of tiles
    //    total++;//next tile
    //    if(total == this.numImages){//if we've gone through all the tiles
    //      //println(((x + 1) * (y + 1)) - 1);
    //      totalImages = this.numImages;
    //      fullTotalImages = (ceil((float)(this.numImages) / rowLength) * rowLength) - 1;//make sure all tile rows are full
    //      loadedTileMapName = this.tileMapName;//let's remember what tile map we loaded
    //      return tmpTiles;//return the temporary tiles array
    //    }
    //  }
    //}
    //return null;//gotta do this other wise processing isn't happy
    
    totalImages = this.numImages;
    fullTotalImages = (ceil((float)(this.numImages) / rowLength) * rowLength) - 1;//make sure all tile rows are full
    //loadedTileMapName = this.tileMapName;//let's remember what tile map we loaded
    return splitTiles(this.tileMapImage, this.tileMapRows, this.tileMapCols);//return the temporary tiles array
  }
}

PImage[] splitTiles(PImage tileMap_, int rows_, int cols_){
  int tileWidth = tileMap_.width / cols_;
  int tileHeight = tileMap_.height / rows_;
  PImage[] tmpTiles = new PImage[rows_ * cols_];
  int total = 0;
  for(int y = 0; y < rows_; y++){//go through all tile map rows
    for(int x = 0; x < cols_; x++){//go through all tile map columns
      PImage tmp = createImage(tileWidth, tileHeight, ARGB);//create a temporary image
      tmp.copy(tileMap_, x * tileX, y * tileY, tileWidth, tileHeight, 0, 0, tileWidth, tileHeight);//copy the tile at this xy position
      //tmpTiles.add(tmp);
      tmpTiles[total] = tmp;//copy the tile to the temporary array of tiles
      total++;//next tile
    }
  }
  return tmpTiles;//gotta do this other wise processing isn't happy
}

void loadTileMapInfo(String directory_, String fileLocation_){
  Table tileInfoTable = new Table();//tile map info table
  tileInfoTable = loadTable(fileLocation_, "header, csv");// + ".csv", "header");//Load the csv
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  int fileVersion = int(tileInfoTable.getInt(0,"location"));//File Version
  //int(mapTable.get(0,"tileMapColumns"));//blank
  //int(mapTable.get(0,"tileMapRows"));//blank
  //int(mapTable.get(0,"tileWidth"));//blank
  //int(mapTable.get(0,"tileHeight"));//blank
  //int(mapTable.get(0,"images"));//blank
  //int(mapTable.get(0,"colortile"));//blank
  //mapTable.get(0,"name");//should be "Info"
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////FILE METADATA
  
  if(fileVersion == 0){//whats the file version
    for(int i = 1; i < tileInfoTable.getRowCount(); i++){//Loop through all the tile maps
      //println(tileInfoTable.getString(i,"location") + ", " +//tile map image location
      //        tileInfoTable.getInt(i,"tileMapColumns") + ", " +//tile map columns
      //        tileInfoTable.getInt(i,"tileMapRows") + ", " +//tile map rows
      //        tileInfoTable.getInt(i,"tileWidth") + ", " +//tile width
      //        tileInfoTable.getInt(i,"tileHeight") + ", " +//tile height
      //        tileInfoTable.getInt(i,"images") + ", " +//number of images
      //        tileInfoTable.getInt(i,"colortile") + ", " +//clear color tile number
      //        tileInfoTable.getString(i,"name"));//tile map name

      //String loc, int rows, int cols, int tileWidth, int tileHeight, int num, int colorTile, String name
      tileMaps.add(new tileMap(directory_ + "\\" + tileInfoTable.getString(i,"location"),//what is the images name
                               tileInfoTable.getInt(i,"tileMapColumns"), tileInfoTable.getInt(i,"tileMapRows"),//how many columns and rows are in the tile map
                               tileInfoTable.getInt(i,"tileWidth"), tileInfoTable.getInt(i,"tileHeight"),//how many pixels wide and tall are the tiles
                               tileInfoTable.getInt(i,"images"), tileInfoTable.getInt(i,"colortile"),//how many images are there and what is the 'clear' tile
                               tileInfoTable.getString(i,"name")));//what is the tile maps name
    }
  }else{//we don't know that file version
    println("File Version Error (Loading).");//throw error
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------

//void fileHandlingTest(){
//  // Using just the path of this sketch to demonstrate,
//  // but you can list any directory you like.
//  String path = sketchPath() + "/assets/";
//  println(path);

//  println("Listing all filenames in a directory: ");
//  String[] filenames = listFileNames(path);
//  printArray(filenames);
//  println(filenames[0]);

//  println("\nListing info about all files in a directory: ");
//  File[] files = listFiles(path);
//  for (int i = 0; i < files.length; i++) {
//    File f = files[i];    
//    println("Name: " + f.getName());
//    println("Is directory: " + f.isDirectory());
//    println("Size: " + f.length());
//    String lastModified = new Date(f.lastModified()).toString();
//    println("Last Modified: " + lastModified);
//    println("-----------------------");
//  }

//  println("\nListing info about all files in a directory and all subdirectories: ");
//  ArrayList<File> allFiles = listFilesRecursive(path);

//  for (File f : allFiles) {
//    println("Name: " + f.getName());
//    println("Full path: " + f.getAbsolutePath());
//    println("Is directory: " + f.isDirectory());
//    println("Size: " + f.length());
//    String lastModified = new Date(f.lastModified()).toString();
//    println("Last Modified: " + lastModified);
//    println("-----------------------");
//  }
//}

//---------------------------------------------------------------------------------------------------------------------------------------

//// This function returns all the files in a directory as an array of Strings  
//String[] listFileNames(String dir) {
//  File file = new File(dir);
//  if (file.isDirectory()) {
//    String names[] = file.list();
//    return names;
//  } else {
//    // If it's not a directory
//    return null;
//  }
//}

//---------------------------------------------------------------------------------------------------------------------------------------

//// This function returns all the files in a directory as an array of File objects
//// This is useful if you want more info about the file
//File[] listFiles(String dir) {
//  File file = new File(dir);
//  if (file.isDirectory()) {
//    File[] files = file.listFiles();
//    return files;
//  } else {
//    // If it's not a directory
//    return null;
//  }
//}

//---------------------------------------------------------------------------------------------------------------------------------------

// Function to get a list of all files in a directory and all subdirectories
ArrayList<File> listFilesRecursive(String dir_) {
  ArrayList<File> fileList = new ArrayList<File>(); 
  recurseDir(fileList, dir_);
  return fileList;
}

//---------------------------------------------------------------------------------------------------------------------------------------

// Recursive function to traverse subdirectories
void recurseDir(ArrayList<File> a_, String dir_) {
  File file = new File(dir_);
  if (file.isDirectory()) {
    // If you want to include directories in the list
    a_.add(file);  
    File[] subfiles = file.listFiles();
    for (int i = 0; i < subfiles.length; i++) {
      // Call this function on all files in this directory
      recurseDir(a_, subfiles[i].getAbsolutePath());
    }
  } else {
    a_.add(file);
  }
}