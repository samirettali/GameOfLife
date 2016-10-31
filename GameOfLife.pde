 int rows, cols, squareSize, gen, pop;
 boolean[][] cells;
 boolean execute;
 int FPS;
 int hudSize;
 int[] surviveRules, birthRules;
 
 void setup(){
   
    size(1300, 800);
    FPS = 30;
    
    hudSize = 100;
    squareSize = 10;
    rows = (height-hudSize)/squareSize;
    cols = width/squareSize;
    surface.setTitle("Game Of Life");
    cells = new boolean[rows][cols];
    execute = false;
    
    init(false);
    
    boolean[][] glider = new boolean[][]{{true, true, true},{true, false, false},{false, true, false}};
    boolean[][] blinker = new boolean[][]{{true, true, true}};
    boolean[][] frog = new boolean[][]{{false, true, true, true},{true, true, true, false}};
    boolean[][] spaceShip = new boolean[][]{{false, true, false, false, true},{true, false, false, false, false},{true, false, false ,false, true},{true, true, true, true, false}};
    
    birthRules = new int[]{3};
    surviveRules = new int[]{2,3};
    
  }
  
  void init(boolean random){
    gen = 0;
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
    if(pop>0)
      gen++;
      
    boolean[][] next = new boolean[rows][cols];
    int neighbours;

    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        neighbours = neighboursNumber(y, x);
        /*if (cells[y][x] && (neighbours < 2 || neighbours > 3))
          next[y][x] = false;
        else if (cells[y][x] && (neighbours == 2 || neighbours == 3))
          next[y][x] = true;
        else if (cells[y][x] == false && neighbours == 3)
          next[y][x] = true;*/
        //survive cycle  ,x);
        int i;
        boolean res = false;
        if(cells[y][x]){
          i = 0;
          while(i < surviveRules.length){
            if(neighbours == surviveRules[i])
              res = true;
            i++;
          }
        }
        else if(!cells[y][x]){
          i = 0;
          while(i < birthRules.length){
            if(neighbours == birthRules[i])
              res = true;
            i++;
          }
        }
        next[y][x] = res;
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
      stroke(0, 80);
      int x = mouseX/squareSize;
      int y = (mouseY-hudSize)/squareSize;
      if(x < cols && x >= 0 && y >= 0 && y < rows){
        cells[y][x] = !cells[y][x];
      }
    }
  }
  
  void hud(){
    PFont f = createFont("Consolas", 15, true);
    textFont(f,15);
    fill(0);
    
    //Create rules string
    String rules = "Rules: B";
    
    for(int i : birthRules)
      rules += str(i);
      
    rules += "/S";
    
    for(int i : surviveRules)
      rules += str(i);
      
    String info = rules + "\nGeneration: " + str(gen) + "\nPopulation: " + pop + "\nFPS: " + FPS + "\nState: " + (execute ? "running" : "paused");
    text(info, 5, 15);
    String commands = "Press Enter to pause the simulation and edit cells state\nPress UP and DOWN to modify the simulation speed\nPress DELETE to delete all the cells\nPress BACKSPACE to start a random simulation";
    text(commands, 200, 15);
  }
 
  void draw(){
    
    frameRate(FPS);
    background(255);
    stroke(0, 80);
    
    pop = 0;
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        
        if (cells[y][x]) {
          fill(0);
          pop++;
        }
        else
          fill(255);
         
        rect(x*squareSize+1, hudSize + y*squareSize+1, squareSize-2, squareSize-2);  
      }
     }
     hud();
     if(execute)
       cycle();
  }
  
  
