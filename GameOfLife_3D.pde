

int zvalue = -200;
boolean eka = true;
int cellSize = 25;  //solujen koko
int cellCount = 20;
int minN = 5; //pelin säännöt. elävien naapurisolujen
int maxN = 7; //minimi ja maksimimäärät
int spawnN = 5;
float timeInSecs;
int past;  //hetki jona viimeisin päivitys tehtiin
int updateInterval = 50;  //päivitysten välinen aika
int likelinessOfbirth = 60;  // todennäköisyydellä solu on elävä kun se alussa luodaan

//luodaan 3d matriisit soluille
Cell[][][] cellMatrix;
Cell[][][] tempMatrix;
Cell[][][] endMatrix;

void setup(){ 
  
  fullScreen(P3D);
  noCursor();
  
  //tehdään soluille säilytysmatriisit
  
  cellMatrix = new Cell[cellCount][cellCount][cellCount];
  tempMatrix = new Cell[cellCount][cellCount][cellCount];
  endMatrix = new Cell[cellCount][cellCount][cellCount];
  
  randomSeed(5);
  
  //alustetaan matriisit
  reset();
  
}

//int x = frameCount;//just to remember framecount by...

void draw(){
    
    colorMode(RGB,255,255,255);
    stroke(34);
    
    translate(width/2, height/2, (float)zvalue);
    rotateY(map(mouseX, 0, width, 0, 2*PI));
    rotateX(map(mouseY, 0, height, 0, 2*PI));
  
    background(0, 104, 155);
  
    //tutkitaan onko jo aika päivittää ruutu
    if(millis() - past > updateInterval){
      past = millis();    
    /*
      if(endfunk == 1 && eka){
        eka = false;
        KillFunction();
      }
    */
    
      //Päivitetään tempMatrix tutkimalla cellMatrixin soluja
      for(int i=0; i<cellCount; i++){
        for(int j=0; j<cellCount; j++){
          for(int k=0; k<cellCount; k++){
        
            //lasketaan käsiteltävänä olevan solun elävät naapurit
            int neighbours = countNeighbours(i, j, k, cellMatrix, cellCount);
          
            Cell theCell = tempMatrix[i][j][k];
            //solun väri määräytyy elävien naapurien määrän mukaan
            cellMatrix[i][j][k].SetColor(neighbours);     
          
          
            //jos solulla on <minN tai >maxN elävää naapuria, se tapetaan
            if((neighbours > maxN) || (neighbours < minN)){
              theCell.Kill();
            }
            //jos solu on kuollut ja sillä on spawnN elävää naapuria, se herää eloon
            if(cellMatrix[i][j][k].GetState()==0 && neighbours == spawnN){
              theCell.Spawn();
            }           
          }
        }
      }
    
    //päivitetään cellMatrixin solut tempMatrixin solujen arvoilla.
    //näin saadaan cellMatrix päivitettyä, mutta pidetään kuitenkin matriisit erillisinä
    //cellmatrix=tempmatrix johtaa siihen, että molemmat viittaa samaan matriisiin = fail
    for(int i=0; i<cellCount; i++){
      for(int j=0; j<cellCount; j++){
        for(int k=0; k<cellCount; k++){
        
          Cell current = cellMatrix[i][j][k];
          
          if(tempMatrix[i][j][k].GetState()==1){
            current.Spawn();
          }else{
            current.Kill();
          }
        }
      }
    }    
  }
  //piirretään päivitetty matrix
    for(int i=0; i<cellCount; i++){
      for(int j=0; j<cellCount; j++){
        for(int k=0; k<cellCount; k++){
      
          cellMatrix[i][j][k].draw();
        }
      }
    }
  }
  

//laskee annetun solun elävät naapurisolut annetussa solumatriisissa. size == solujen määrä rivissä
int countNeighbours(int xx, int yy, int zz, Cell[][][] matrix, int size){
  int count = 0;
  
  for(int i=-1; i<2; i++){
    for(int j=-1; j<2;j++){
      for(int k=-1; k<2; k++){
        if((i==0 && j==0 && k==0) || overEdge(xx+i, yy+j, zz+k, size)){
          continue;
        }else {
          count += matrix[xx+i][yy+j][zz+k].GetState();//lukee solun tilan
        } 
      }
    }
  }
  return count;
}

//tarkastaa onko annetut arvot vielä matriisin sisällä
boolean overEdge(int xx, int yy, int zz, int size){
  return (xx == size || xx==-1) || (yy==size || yy==-1) || (zz==size || zz==-1); 
}

void KillFunction(){
  
  minN = 6;
  maxN = 9;
  spawnN = 5; //The killingrules
  
  updateInterval = 200;
  
  cellMatrix = endMatrix;
}

//zoomaus hiiren rullalla
void mouseWheel(MouseEvent event) {
  zvalue += event.getCount()*100*-1;
}

void mouseClicked(){
  reset();
}

void reset(){
  for(int i=0; i<cellCount; i++){
    for(int j=0; j<cellCount; j++){
      for(int k=0; k<cellCount; k++){
        float chance = random(100); 
        int state = 0;
        if(chance > likelinessOfbirth){
          state = 1;
        }
        cellMatrix[i][j][k] = new Cell(new PVector(cellSize*i-(1.0*cellSize*cellCount/2), cellSize*j-(1.0*cellSize*cellCount/2),cellSize*k-(1.0*cellSize*cellCount/2)), state, cellSize);
        tempMatrix[i][j][k] = new Cell(new PVector(cellSize*i-(1.0*cellSize*cellCount/2), cellSize*j-(1.0*cellSize*cellCount/2),cellSize*k-(1.0*cellSize*cellCount/2)), state, cellSize);
        endMatrix[i][j][k] = new Cell(new PVector(cellSize*i-(1.0*cellSize*cellCount/2), cellSize*j-(1.0*cellSize*cellCount/2),cellSize*k-(1.0*cellSize*cellCount/2)), state, cellSize);
      }
    }
  }
}
