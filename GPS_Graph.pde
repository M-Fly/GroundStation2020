import org.apache.commons.math3.analysis.function.*;

class GPSgraph {

  //This is the distance calculator that will be used to evaluate the distance between two different lat and long coordinates. 
  private DistanceCalculator dist_calc; 
  private PredictionAlgorithmEuler drop_predictor; 
  
  
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
  
  private float xLength_meters; 
  private float yLength_meters; 



  //Default Constructor
  GPSgraph(double longStart, double longEnd, double latStart, double latEnd, float tailLength) {
    this.tailLength = tailLength; 
    tailX = new double[(int)tailLength]; 
    tailY = new double[(int)tailLength]; 
    this.longStart = longStart; 
    this.longEnd = longEnd; 
    this.latStart = latStart; 
    this.latEnd = latEnd;
    
    dist_calc = new DistanceCalculator(); 
    drop_predictor = new PredictionAlgorithmEuler(); 
    
    this.xLength_meters = (float) dist_calc.distance(latStart, longStart, latStart, longEnd, "meters" ); 
    this.yLength_meters = (float) dist_calc.distance(latStart, longStart, latEnd, longStart, "meters" ); 
  }


  //Update the gps data with the lat and long data
  void updatePosition(double longData, double latData) {

    longitude = longData; 
    latitude = latData; 

    tailX[offset] = longData;  
    tailY[offset] = latData;
    offset = offset == tailLength - 1 ? 0 : offset + 1;
  }

  //This displays the graph of the GPS coordinates
  void displayLatLongGraph(float xPos, float yPos, float xSize, float ySize) {
    strokeWeight(2);
    stroke(0);
    fill(#9B9B9B);
    rect(xPos, yPos, xSize, ySize);

    int iter = offset-1;
    strokeWeight(1);
    stroke(0, 0, 255);

    //This displays the tail in the graph
    for (int i = 1; i < tailLength; i++) {
      double mappedLong1 = Map(tailX[(int)getCircularIndex(iter)], longStart, longEnd, xPos, xPos + xSize);
      double mappedLat1 = Map(tailY[(int)getCircularIndex(iter)], latStart, latEnd, yPos, yPos + ySize);
      double mappedLong2 = Map(tailX[(int)getCircularIndex(iter - 1)], longStart, longEnd, xPos, xPos + xSize);
      double mappedLat2 = Map(tailY[(int)getCircularIndex(iter - 1)], latStart, latEnd, yPos, yPos + ySize);
      iter--;
      line((float)mappedLong1, (float)mappedLat1, (float) mappedLong2, (float) mappedLat2);
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
    
    fill(0); 
    textAlign(CENTER, CENTER); 
    textSize(10); 
    text("longitude", xPos + xSize / 2, yPos + ySize + 10); 
  }


  private float getCircularIndex(int index) {
    if (index >= tailLength) {
      return index % tailLength;
    } else if (index < 0) {
      while (index < 0) {
        index += tailLength;
      }
    } 
    return index;
  }


  //This displays the predicted drop location of the objects.
  void displayDropPrediction(float alt, double GPSSpeed, double heading, float xPos, float yPos, float xSize, float ySize) {
    double metersX = dist_calc.distance(latStart, longStart, latStart, longitude, "meters"); 
    double metersY = dist_calc.distance(latStart, longStart, latitude, longStart, "meters");
    
   Vector position = new Vector(metersX, metersY, alt); 
   
   heading -= Math.PI/2; 
   
   heading = Math.PI * 2 - heading; 
   
   double x_vel = GPSSpeed * Math.sin( heading ); 
   double y_vel = GPSSpeed * Math.cos( heading ); 
      
   Vector vel = new Vector(x_vel,y_vel,0); 
   
   Vector wind = new Vector(0,0,0); 
   Vector dropLocation = drop_predictor.PredictionIntegrationFunction(position, vel, wind); 
   
   float drop_x = map((float)dropLocation.x, 0, xLength_meters,xPos, xPos+xSize);  
   float drop_y = map((float)dropLocation.y, 0, yLength_meters,yPos, yPos+ySize); 
   
   float minDim = xSize < ySize ? xSize : ySize;
   
   fill(#E30B0B); 
   ellipse(drop_x, drop_y, minDim/25, minDim/25); 
   
  }
};
