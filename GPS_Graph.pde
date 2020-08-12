import org.apache.commons.math3.analysis.function.*;

class GPSgraph{
   
  //The length of the displayed gps tail
  private float tailLength; 
  
  //The x and y coordinates of the tail
  private double[] tailX;
  private double[] tailY;
  
  //The offset for updating data
  private int offset = 0;
  
  //The data the stores where the graph is positioned
  private double longStart; 
  private double longEnd; 
  private double latStart; 
  private double latEnd; 
  
  
  //This information is stored for calculating things such as plane heading and speed
  private double longitude;
  private double latitude;
  private double platitude;
  private double plongitude;
  private double timeDifference;
  private double pMillis;
  private double currentMillis;
  
  private double earthRadius; 
  
  
  //Default Constructor
  GPSgraph(double longStart, double longEnd, double latStart, double latEnd, float tailLength){
    this.tailLength = tailLength; 
    tailX = new double[(int)tailLength]; 
    tailY = new double[(int)tailLength]; 
    this.longStart = longStart; 
    this.longEnd = longEnd; 
    this.latStart = latStart; 
    this.latEnd = latEnd; 
  }
  
  
  //Update the gps data with the lat and long data
  void updatePosition(double longData, double latData){
    pMillis = currentMillis;
    currentMillis = millis();
    
    plongitude = longitude; 
    platitude = latitude; 
    longitude = longData; 
    latitude = latData; 
    
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
     double mappedLong1 = Map(tailX[(int)getCircularIndex(iter)], longStart, longEnd, xPos, xPos + xSize);
     double mappedLat1 = Map(tailY[(int)getCircularIndex(iter)], latStart, latEnd, yPos, yPos + ySize);
     double mappedLong2 = Map(tailX[(int)getCircularIndex(iter - 1)], longStart, longEnd, xPos, xPos + xSize);
     double mappedLat2 = Map(tailY[(int)getCircularIndex(iter - 1)], latStart, latEnd, yPos, yPos + ySize);
     iter--;
     line((float)mappedLong1, (float)mappedLat1,(float) mappedLong2,(float) mappedLat2);
   }
   //println("tail x:" + tailX[(int)getCircularIndex(offset-1)]);
   double mappedLong = Map(tailX[(int)getCircularIndex(offset-1)], longStart, longEnd, xPos, xPos + xSize);
   double mappedLat = Map(tailY[(int)getCircularIndex(offset-1)], latStart, latEnd, yPos, yPos + ySize);
   
   //println("mapped tail x:" + mappedLong);
   float minDim = xSize < ySize ? xSize : ySize;
   stroke(0);
   strokeWeight(1);
   fill(#C88ED8);
   ellipse((float)mappedLong, (float)mappedLat, minDim / 25, minDim/25);
   
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
  
  
  //This displays the predicted drop location of the objects.
  void displayDropPrediction(float alt, double GPSSpeed, float xPos, float yPos, float xSize, float ySize){
    
  }
  
  
  
};
