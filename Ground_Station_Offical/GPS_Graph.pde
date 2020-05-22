class GPSgraph{
 
  //The length of the displayed gps tail
  private float tailLength; 
  
  //The x and y coordinates of the tail
  private float[] tailX;
  private float[] tailY;
  
  //The offset for updating data
  private int offset = 0;
  
  //The data the stores where the graph is positioned
  private float longStart; 
  private float longEnd; 
  private float latStart; 
  private float latEnd; 
  
  //Default Constructor
  GPSgraph(float longStart, float longEnd, float latStart, float latEnd, float tailLength){
    this.tailLength = tailLength; 
    tailX = new float[(int)tailLength]; 
    tailY = new float[(int)tailLength]; 
    this.longStart = longStart; 
    this.longEnd = longEnd; 
    this.latStart = latStart; 
    this.latEnd = latEnd; 
  }
  
  
  //Update the gps data with the lat and long data
  void updatePosition(float longData, float latData){
    tailX[offset] = longData;  
    tailY[offset] = latData;
    offset = offset == tailLength - 1 ? 0 : offset + 1; 
  }
  
  //This displays the graph of the GPS coordinates
 void displayLatLongGraph(float xPos, float yPos, float xSize, float ySize){
   strokeWeight(2);
   stroke(0);
   fill(#9B9B9B);
   rect(xPos, yPos, xSize, ySize);
   
   int iter = offset-1;
   strokeWeight(1);
   stroke(0,0,255);
   
   //This displays the tail in the graph
   for(int i = 1; i < tailLength; i++){
     float mappedLong1 = map(tailX[(int)getCircularIndex(iter)], longStart, longEnd, xPos, xPos + xSize);
     float mappedLat1 = map(tailY[(int)getCircularIndex(iter)], latStart, latEnd, yPos, yPos + ySize);
     float mappedLong2 = map(tailX[(int)getCircularIndex(iter - 1)], longStart, longEnd, xPos, xPos + xSize);
     float mappedLat2 = map(tailY[(int)getCircularIndex(iter - 1)], latStart, latEnd, yPos, yPos + ySize);
     iter--;
     line(mappedLong1, mappedLat1, mappedLong2, mappedLat2);
   }
   
   float mappedLong = map(tailX[(int)getCircularIndex(offset-1)], longStart, longEnd, xPos, xPos + xSize);
   float mappedLat = map(tailY[(int)getCircularIndex(offset-1)], latStart, latEnd, yPos, yPos + ySize);
   float minDim = xSize < ySize ? xSize : ySize;
   stroke(0);
   strokeWeight(1);
   fill(#C88ED8);
   ellipse(mappedLong, mappedLat, minDim / 25, minDim/25);
   
 }
  
  
  private float getCircularIndex(int index){
    if(index >= tailLength){
      return index % tailLength;
    }
    else if(index < 0){
     while(index < 0){
       index += tailLength;
     }
    } 
    return index; 
  }
  
  
};
