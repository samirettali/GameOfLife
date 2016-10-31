 int rows,cols,squareSize, gen;
 boolean[][] cells;
 boolean execute;
 int FPS;
 int oldX, oldY;
 
 void setup(){
   
    size(800, 500);
    FPS = 30;
    
    squareSize = 10;
    gen = 0;
    rows = height/squareSize;// + additionalSize;
    cols = width/squareSize;// + additionalSize;
    oldX = -1;
    oldY = -1;
    cells = new boolean[rows][cols];
    execute = true;
    
    init(false);
    
    boolean[][] glider = new boolean[][]{{true, true, true},{true, false, false},{false, true, false}};
    boolean[][] blinker = new boolean[][]{{true, true, true}};
    boolean[][] frog = new boolean[][]{{false, true, true, true},{true, true, true, false}};
    boolean[][] spaceShip = new boolean[][]{{false, true, false, false, true},{true, false, false, false, false},{true, false, false ,false, true},{true, true, true, true, false}};
    //putStructure(spaceShip, 15, 10);
    
  }
  
  void init(boolean random){
    //init cells
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        if(random)
          cells[y][x] = random(1) > .5;
        else
          cells[y][x] = false;
        
      }
    }
  }
  

  boolean isValidCell(int row, int col) {
    if (row >= 0 && col >= 0 && row < rows  && col < cols)
      return true;
    return false;
  }

  int neighboursNumber(int row, int col) {
    int count = 0;
    for (int y = -1; y <= 1; y++) {
      for (int x = -1; x <= 1; x++) {
        int r = (row + y + rows) % rows;
        int c = (col + x + cols) % cols;
        if ((y != 0 || x != 0 ) && cells[r][c]) {
          count++;
        }
      }
    }

    return count;
  }

  void cycle() {
    gen++;
    boolean[][] next = new boolean[rows][cols];
    int neighbours;

    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        neighbours = neighboursNumber(y,x);
        if (cells[y][x] && (neighbours < 2 || neighbours > 3))
          next[y][x] = false;
        else if (cells[y][x] && (neighbours == 2 || neighbours == 3))
          next[y][x] = true;
        else if (cells[y][x] == false && neighbours == 3)
          next[y][x] = true;
      }
    }
    cells = next;
  }

  void putStructure(boolean[][] structure, int row, int col) {
    for (int y = 0; y < structure.length; y++) {
      for (int x = 0; x < structure[0].length; x++) {
        cells[row + y][col + x] = structure[y][x];
      }
    }
  }
  
  void keyPressed(){
    if(keyCode == ENTER)
      execute = !execute;
    else if(keyCode == UP && FPS < 60)
      FPS+=5;
    else if(keyCode == DOWN && FPS > 5)
      FPS-=5;
    else if(keyCode == DELETE){
      execute = false;
      init(false);
    }
    else if(keyCode == BACKSPACE){
      execute = true;
      init(true);
    }
      
      
  }
  
  void mouseReleased(){
    if(!execute){
      stroke(0, 50);
      int x = mouseX/squareSize;
      int y = mouseY/squareSize;
      if(x < cols && x >= 0 && y >= 0 && y < rows){
        cells[y][x] = !cells[y][x];
      }
    }
  }
 
  void draw(){
    frameRate(FPS);
    stroke(0, 50);
    surface.setTitle("Game Of Life, generation: " + str(gen) + ", cycle limit: " + FPS + ", state: " + (execute ? "running" : "paused"));
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        if (cells[y][x]) 
          fill(0);
        else
          fill(255);
        rect(x*squareSize+1, y*squareSize+1, squareSize-1, squareSize-1);
      }
     }
     if(execute)
       cycle();
  }
  
  
