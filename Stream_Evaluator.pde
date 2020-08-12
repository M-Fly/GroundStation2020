class Evaluator{

  private float airSpeed; 
  private float alt;
  private float tach;
  private double latitude; 
  private double longitude; 
  
  //Default Constructor
  Evaluator(){}
  
  //Setters ------------------------------------
  
  void setAirspeed(float airSpeed){
    
    //REPLACE WITH CONVERSIONS FROM THE DAS NUMBERS TO THE WANTED OUTPUTS 
    this.airSpeed = airSpeed; 
  }

  void setAlt(float alt){
    
   //REPLACE WITH CONVERSIONS FROM THE DAS NUMBERS TO THE WANTED OUTPUTS 
   this.alt = alt;  
  }
  
  void setTach(float tach){
    
    //REPLACE WITH CONVERSIONS FROM THE DAS NUMBERS TO THE WANTED OUTPUTS 
   this.tach = tach;  
  }
  
  void setLatitude(float lat){
    
    //REPLACE WITH CONVERSIONS FROM THE DAS NUMBERS TO THE WANTED OUTPUTS 
   this.latitude = latitude;  
  }

  void setLongitude(float lon){
    
    //REPLACE WITH CONVERSIONS FROM THE DAS NUMBERS TO THE WANTED OUTPUTS 
   this.longitude = lon;  
  }
  
  float getAirspeed(){
   return airSpeed; 
  }
  
  float getAlt(){
   return alt;  
  }
  
  float getTach(){
   return tach; 
  }
  
  double getLatitude(){
   return latitude;  
  }
  
  double getLongitude(){
   return longitude;  
  }

  void readAMESSAGE(String[] AMESSAGE){
   if(AMESSAGE.length>=9){
    alt = float(AMESSAGE[3]);
   airSpeed = float(AMESSAGE[4]);
   }
  }
  
  void readBMESSAGE(String[] BMESSAGE){
   
   if(BMESSAGE.length >= 10){ 
   latitude = Double.parseDouble(BMESSAGE[4]); 
   longitude = Double.parseDouble(BMESSAGE[5]); 
   }
  }

}
