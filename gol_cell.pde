class Cell{

    int state;
    float size;
    PVector location = new PVector(0,0,0);
    float[] space = new float[3];
    color c = color(155,0,79);
    
    public Cell(PVector loc, int state, float size){
      this.state = state;
      location = loc;
      this.size = size;      
    }
    
    public void draw(){
      //noStroke();
      if(state == 1){
        fill(c);
        //piirtää soluboxin paikkaansa. push ja pop ettei vaikuta minkään muun
        //piirtämiseen.
        pushMatrix();
        translate(location.x +space[0], location.y + space[1], location.z + space[2]);
        box(size);
        popMatrix();
      }      
    }
    
    public void Kill(){     
      this.state = 0;
    }
    
    public void Spawn(){
      this.state = 1;
    }
    
   public void SetSize(float value){
     size = value;
   }
   
   public void SetColor(int neigh){
     
     switch(neigh){
       case 2:
         c = color(73, 180, 209);
         break;
       case 3:
         c = color(183, 44, 133);//red
         break;
       case 4:
         c = color(255, 255, 59);//bright yellow
         break;
       case 5:
         c = color(255,255, 240);//bone white
         break;
       case 6:
         c = color(85, 153, 59);//poison green
         break;
       case 7:
         c = color(157, 89, 214);//lilac
         break;
       case 8:
         c = color(173, 34, 123);
         break;
       case 9:
         c = color(150, 14, 165);
         break;
       case 10:
         c = color(173, 3, 99);
         break;
       case 11:
         c = color(214, 36, 57);
         break;
       case 12:
         c = color(153, 12, 28);
         break;
       case 13:
         c = color(153, 12, 28);
         break;
     }
     
   }
   
   public color GetColor(){
     return this.c;
   }
   
   public void SetSpace(float x, float y, float z){
     space[0] = x;
     space[1] = y;
     space[2] = z;
   }
    
    public int GetState() {
      return this.state;
    }
}
