class GPSgraph{
 
  //The length of the displayed gps tail
  private float tailLength; 
  
  //The x and y coordinates of the tail
  private double[] tailX;
  private double[] tailY;
  
  //The offset for updating data
  private int offset = 0;
  
  //The data the stores where the graph is positioned
  private float longStart; 
  private float longEnd; 
  private float latStart; 
  private float latEnd; 
  
  //These values are all used to calculate the velocity of the plane. 
  //This will take 2 longitude and latitude values, and also take the difference in time between the two values.
  //This will allow conversion from change in gps coordinates to meters per second. 
  private double longitude;
  private double latitude;
  private double platitude;
  private double plongitude;
  private double timeDifference;
  private double pMillis;
  private double currentMillis;
  
  private double earthRadius; 
  
  
  
  //The drop predictor that calculates where the plane is.
  PredictionAlgorithmEuler dropPredictor;
  
  //Default Constructor
  GPSgraph(float longStart, float longEnd, float latStart, float latEnd, float tailLength){
    this.tailLength = tailLength; 
    tailX = new double[(int)tailLength]; 
    tailY = new double[(int)tailLength]; 
    this.longStart = longStart; 
    this.longEnd = longEnd; 
    this.latStart = latStart; 
    this.latEnd = latEnd; 
    this.longitude = longStart; 
    this.latitude = latStart; 
    this.plongitude = longStart; 
    this.platitude = latStart; 
    this.timeDifference = 1; 
    this.earthRadius = 6371000; //Mean earth radius
     dropPredictor = new PredictionAlgorithmEuler();
  }
  
  
  //Update the gps data with the lat and long data
  void updatePosition(double longData, double latData){
    this.plongitude = this.longitude; 
    this.platitude = this.latitude; 
    this.longitude = longData; 
    this.latitude = latData; 
    this.pMillis = this.currentMillis; 
    this.currentMillis = millis();
    this.timeDifference = currentMillis - pMillis;
    
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
     float mappedLong1 = map((float)tailX[(int)getCircularIndex(iter)], (float)longStart,(float) longEnd, (float)xPos, (float)(xPos + xSize));
     float mappedLat1 = map((float)tailY[(int)getCircularIndex(iter)],(float) latStart,(float) latEnd,(float) yPos, (float)(yPos + ySize));
     float mappedLong2 = map((float)tailX[(int)getCircularIndex(iter - 1)], (float)longStart, (float)longEnd, (float)xPos,(float)( xPos + xSize));
     float mappedLat2 = map((float)tailY[(int)getCircularIndex(iter - 1)],(float) latStart,(float) latEnd, (float)yPos,(float)( yPos + ySize));
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
  
  
  //This displays the predicted drop location of the footballs
  void displayPredictedDropLocation(float altitude, double xPos, double yPos, double xSize, double ySize){
    
      //These are the position relative to the upper left hand corner of the graph
      float yDistance = calculateDistanceLatLong(latStart, longStart, latitude, longStart); //<>//
      float xDistance = calculateDistanceLatLong(latStart, longStart, latStart, longitude); //<>//
      
      PVector pos = new PVector(xDistance, yDistance, altitude);  //<>//
      
      PVector finalPos = dropPredictor.PredictionIntegrationFunction(pos, this.getGPSVelocity(), new PVector(0,0,0));
      
      //The distance in meters of the feild from start to finish as a whole. 
      float longDistance = calculateDistanceLatLong(latStart, longStart, latStart, longEnd);
      float latDistance = calculateDistanceLatLong(latStart, longStart, latEnd, longStart);
      
      float mappedxPos = map(finalPos.x, 0, longDistance, xPos, xPos + xSize);
      float mappedyPos = map(finalPos.y, 0, latDistance, yPos, yPos + ySize);
      
       float minDim = xSize < ySize ? xSize : ySize;
      
      fill(255,0,0);
      ellipse(mappedxPos, mappedyPos,minDim / 25, minDim/25);
    
  }
  
  
  //Returns the index of a peice of data, even if the indicated index is past the length of the dataset
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
  
  //This allows us to set what the earths radius is.
  void setEarthRadius(float radius){
   earthRadius = radius;  
  }
  
  //Returns a velocity vector that that detemines the planes heading. 
  private PVector getGPSVelocity(){
    
    float distance = calculateDistanceLatLong(this.platitude, this.plongitude, this.latitude, this.longitude);
    
    float dtSeconds = timeDifference / 1000; 
    
    float velocity = distance / dtSeconds; 
    
    PVector vel_vec = new PVector(longitude - plongitude, latitude - platitude); 
    
    vel_vec.normalize();
    
    vel_vec.mult(velocity); 
    
    return new PVector(vel_vec.x, vel_vec.y, 0);  
  }
  
  
  //returns the distance in meters between two lat and long coordinates
  //Using the haversine formula
  //a = sin²(Δφ/2) + cos φ1 ⋅ cos φ2 ⋅ sin²(Δλ/2)
  //c = 2 ⋅ atan2( √a, √(1−a) )
  //d = R ⋅ c
  
  private float calculateDistanceLatLong(float lat1, float lon1, float lat2, float lon2){
    float phi1 = lat1 * PI/180; // phi, lambda in radians
    float phi2 = lat2 * PI/180;
    float dphi = (lat2-lat1) * PI/180;
    float dlambda = (lon2-lon1) * PI/180;
    
    float a =  sin(dphi/2) * sin(dphi/2) +
               cos(phi1) * cos(phi2) *
               sin(dlambda/2) * sin(dlambda/2);
               
    float c = 2 * atan2(sqrt(a), sqrt(1-a));
    
    return c * earthRadius; 
  }
  
  float getGroundSpeed(){
   return this.getGPSVelocity().mag(); 
  }
  
  
};
