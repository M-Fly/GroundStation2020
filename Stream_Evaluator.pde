import org.apache.commons.math3.analysis.function.*;

class Evaluator{

  private float airSpeed = 0; 
  private float alt = 0;
  private float tach = 0;
  private double latitude = 0; 
  private double longitude = 0; 
  private double gpsSpeed = 0; 
  private double gpsAlt = 0; 
  private double GPS_COURSE = 0;
  
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
  
  
  void setHeading(float heading){
     this.GPS_COURSE = heading;  
  }
  
  float getAirspeed(){
   return airSpeed; 
  }
  
  float getAlt(){
   return alt;  
  }
  
  float getAltFT(){
   return alt * 3.28;  
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

  double getGpsSpeed(){
    return (gpsSpeed / 1000)* 1.151;  
  }
  
  double getGpsSpeed_mps(){
   return (gpsSpeed / 1000) * 0.51444; 
  }
  
  double getGpsAlt(){
    return gpsAlt;  
  }
  
  double getHeading(){
   return Math.toRadians(this.GPS_COURSE / 1000);  
  }
  
  void readAMESSAGE(String[] AMESSAGE){
   if(AMESSAGE.length>=9){
    alt = float(AMESSAGE[3])  /* *3.28*/;
   airSpeed = float(AMESSAGE[4]);
   }
  }
  
  void readBMESSAGE(String[] BMESSAGE){
   
   // println("reading message"); 
    //println("MESSAGE LENGTH: " + BMESSAGE.length); 
    //if(BMESSAGE.length >= 4) 
    //println(BMESSAGE[4]); 
    
   if(BMESSAGE.length >= 10){ 
   latitude = Double.parseDouble(BMESSAGE[4].substring(0,2) + "."+BMESSAGE[4].substring(2)); 
   longitude = Double.parseDouble(BMESSAGE[5].substring(0,3) + "."+BMESSAGE[5].substring(3)); 
   gpsSpeed = Double.parseDouble(BMESSAGE[6]); 
   GPS_COURSE = Double.parseDouble(BMESSAGE[7]);
   gpsAlt = Double.parseDouble(BMESSAGE[8]);
   }
  }

}
