import processing.serial.*; 
String[] baudRates = {"300","1200","1800", "2400", "4800", "7200", "9600", "14400", "19200", "31250", "38400", "56000", "57600","1152000","5000000"}; 


void setup(){
  preferences = new Preferences();
  prepareExitHandler(); 
  fullScreen(); 
 
  //create a save file for the GPS data
  if(preferences.saveGPSDATA()){
    String fileName = "GPSDATA -- time"+hour()+"-"+minute()+"-"+second()+" -- date"+day()+"-"+month()+"-"+year()+".txt";
    GPSDATA = createWriter(fileName); 
    GPSDATA.println("GPS DATA LOG FILE");
    GPSDATA.println("TIME:"+hour()+":"+minute()+":"+second());
    GPSDATA.println("DATE:"+day()+":"+month()+":"+year());
    for(int i = 0; i < 60; i ++)
    GPSDATA.print("*");
    GPSDATA.println();
    GPSDATA.println("LONGITUDE,LATITUDE");
  }
 
  //create a save file for the Flight data
  if(preferences.saveFLIGHTDATA()){
    String fileName = "FLIGHTDATA -- "+hour()+"-"+minute()+"-"+second()+"-"+day()+"-"+month()+"-"+year()+".txt";
    FLIGHTDATA = createWriter(fileName); 
    FLIGHTDATA.println("FLIUGHT DATA LOG FILE");
    FLIGHTDATA.println("TIME:"+hour()+":"+minute()+":"+second());
    FLIGHTDATA.println("DATE:"+day()+":"+month()+":"+year());
    for(int i = 0; i < 60; i ++)
    FLIGHTDATA.print("*");
    FLIGHTDATA.println();
    FLIGHTDATA.println("ALTITUDE,AIRSPEED");
  }
 
   //create a save file for the GPS data
  if(preferences.saveDROPDATA()){
    String fileName = "DROPDATA -- "+hour()+"-"+minute()+"-"+second()+"-"+day()+"-"+month()+"-"+year()+".txt";
    DROPDATA = createWriter(fileName); 
    DROPDATA.println("GPS DATA LOG FILE");
    DROPDATA.println("TIME:"+hour()+":"+minute()+":"+second());
    DROPDATA.println("DATE:"+day()+":"+month()+":"+year());
    for(int i = 0; i < 60; i ++)
    DROPDATA.print("*");
    DROPDATA.println();
    DROPDATA.println("NULL");
  }
 
 //Set up the sizing for the display tabelts
 if(preferences.customTablets() == false){
   altGraphTablet = new Tablet(width / 35 - width / (35*2), height / 10, width / 3 - width / 30, height / 2,width > height ? height / 70 : width /70);
   GPSGraphTablet = new Tablet(width / 35 + (width / 3) - width / (35*2), height / 10, width / 3 - width / 30, height / 2,width > height ? height / 70 : width /70);
   flightInfoTablet = new Tablet(width / 35 +  2*(width / 3)- width / (35*2), height / 10, width / 3 - width / 30, height / 2,width > height ? height / 70 : width /70);
   dropInfoTablet = new Tablet(width / 35 + (width / 3) - width / (35*2), height / 10 + height / 2 + height/20, width / 3 - width / 30, height / 4,width > height ? height / 70 : width /70);
 }
 else{
   altGraphTablet = new Tablet(preferences.ALTX(), preferences.ALTY(), preferences.ALTXSIZE(), preferences.ALTYSIZE(),width > height ? height / 70 : width /70);
   GPSGraphTablet = new Tablet(preferences.GPSX(), preferences.GPSY(), preferences.GPSXSIZE(), preferences.GPSYSIZE(),width > height ? height / 70 : width /70);
   flightInfoTablet = new Tablet(preferences.FLIGHTX(), preferences.FLIGHTY(), preferences.FLIGHTXSIZE(), preferences.FLIGHTYSIZE(),width > height ? height / 70 : width /70);
   dropInfoTablet = new Tablet(preferences.DROPX(), preferences.DROPY(), preferences.DROPXSIZE(), preferences.DROPYSIZE(),width > height ? height / 70 : width /70);
 }
 
 printArray(preferences.parsed());
 
 //This is for setting up the alt graph 
 altGraph = new dataPlotter((int)preferences.altGraphDataPoints()); 
 
 //For the GPS Graph
 gpsplot = new GPSgraph(preferences.LONGSTART(), preferences.LONGEND(), preferences.LATSTART(), preferences.LATEND(), preferences.GPSTailLength()); //<>//
 
 dropdownSerial = new Dropdown(width/50.0,height/50.0,width/10.0,height/20.0,color(#D3D3D3),"COMS"); //<>//
 String[] serialOptions = new String[Serial.list().length+1];
 for(int i = 0;i < Serial.list().length; i++){
  serialOptions[i] = Serial.list()[i]; 
 }
 serialOptions[serialOptions.length-1]="SIMULATE";
 dropdownSerial.updateDropdownItems(serialOptions);
 
 dropdownBaud = new Dropdown(width/50.0 + width/10.0 + width/90.0,height/50.0,width/10.0,height/20.0,color(#D3D3D3),"BAUD");
 dropdownBaud.updateDropdownItems(baudRates);
 
 SerialRefresh = new Button(width/50.0 + width/10.0*2 + width / 90*2, height/50.0, height/20.0, height/20.0,color(#D3D3D3), "R");
 
 selectPort = new Button(width/50.0 + width/10.0*2 + width / 90*3 + height/20.0, height/50.0, height/20.0, height/20.0,color(#D3D3D3), "→");
 
 tabletPos = new Button(width - width/10.0 - width/90, height/50.0,width/10.0, height/20.0,color(#D3D3D3), "Pos Adj.");
 
 resetTabs = new Button(width - width/10.0 * 2 - width/90, height/50.0,width/10.0, height/20.0,color(#D3D3D3), "Reset Pos");
 
 //Create the flight data table
 flightData = new dataDisplay();
 flightData.addElement("ALT:", "");
 flightData.addElement("AIRSPEED:", "");
 flightData.addElement("LAT","");
 flightData.addElement("LONG", "");
 
 //The drop data table
 dropData = new dataDisplay(); 
 dropData.addElement("Water:", "NOT DROPPED");
 dropData.addElement("GLIDERS:", "NOT DROPPED");
 
 //The data stream evaluator
 dstreamEval = new Evaluator(); 
}

PrintWriter GPSDATA; 
PrintWriter FLIGHTDATA; 
PrintWriter DROPDATA; 

//The serial com port
Serial port; 

//The display tablets the control where things are displayed
Tablet altGraphTablet, GPSGraphTablet, flightInfoTablet, dropInfoTablet;

Preferences preferences; 

//The altidude graph
dataPlotter altGraph; 

//The GPS Graph
GPSgraph gpsplot; 

//Serial port dropdown menu
Dropdown dropdownSerial;

//Serial port dropdown menu
Dropdown dropdownBaud;

//Serial Port Refresh Button
Button SerialRefresh;

//Select Port Button
Button selectPort;

//Change Tablet Pos Button
Button tabletPos;

//Reset the tablet pos
Button resetTabs;

//Display the live flight data numbers
dataDisplay flightData, dropData; 

Evaluator dstreamEval;

DataStream dstream; 
//The selected com port
String com = ""; 
boolean portSelected = false;

boolean sim = false; 

//Vars for the sim data
float alt = 100;
float airSpeed = 100; 
float latitude = 100;
float longitude = 100; 

void draw(){
   
  
  if(portSelected && !sim){
    dstream.readSerial(); 
    dstreamEval.readAMESSAGE(dstream.getParsedAMESSAGE());
    dstreamEval.readBMESSAGE(dstream.getParsedBMESSAGE());
    
   flightData.updateElementData(str(dstreamEval.getAlt()).length() > 6 ? str(dstreamEval.getAlt()).substring(0,6) : str(dstreamEval.getAlt()),0);
   flightData.updateElementData(str(dstreamEval.getAirspeed()).length() > 6 ? str(dstreamEval.getAirspeed()).substring(0,6) : str(dstreamEval.getAirspeed()),1);
   flightData.updateElementData(str(dstreamEval.getLatitude()).length() > 6 ? str(dstreamEval.getLatitude()).substring(0,6) : str(dstreamEval.getLatitude()),2);
   flightData.updateElementData(str(dstreamEval.getLongitude()).length() > 6 ? str(dstreamEval.getLongitude()).substring(0,6) : str(dstreamEval.getLongitude()),3);
   altGraph.updateData(dstreamEval.getAlt());
   gpsplot.updatePosition(dstreamEval.getLongitude(), dstreamEval.getLatitude());
   
   if(preferences.saveGPSDATA())
      GPSDATA.println(dstreamEval.getLongitude()+","+ dstreamEval.getLatitude());
    }
    if(preferences.saveFLIGHTDATA()){
      FLIGHTDATA.println(dstreamEval.getAlt()+","+dstreamEval.getAirspeed()); 
    }
    
  if(sim)
  {
   flightData.updateElementData(str(alt).length() > 6 ? str(alt).substring(0,6) : str(alt),0);
   flightData.updateElementData(str(airSpeed).length() > 6 ? str(airSpeed).substring(0,6) : str(airSpeed),1);
   flightData.updateElementData(str(latitude).length() > 6 ? str(latitude).substring(0,6) : str(latitude),2);
   flightData.updateElementData(str(longitude).length() > 6 ? str(longitude).substring(0,6) : str(longitude),3);
   altGraph.updateData(alt);
   gpsplot.updatePosition(longitude, latitude);
   
   alt+=random(-0.2,0.2);
   airSpeed+=random(-0.2,0.2);
   latitude += random(-0.2, 0.2);
   longitude += random(-0.2,0.2);
  }
 
   
  background(255);
  fill(0);
 
   //Display the tablets
   GPSGraphTablet.display();
   altGraphTablet.display();
   flightInfoTablet.display();
   dropInfoTablet.display();
 
   //This Displays the plots where they are supposed to be positioned
  gpsplot.displayLatLongGraph(GPSGraphTablet.xPosition(), GPSGraphTablet.yPosition(), GPSGraphTablet.xSize(), GPSGraphTablet.ySize());
  altGraph.displayGraphMovingAxis(altGraphTablet.xPosition(), altGraphTablet.yPosition(), altGraphTablet.xSize(), altGraphTablet.ySize());
  flightData.display(flightInfoTablet.xPosition(), flightInfoTablet.yPosition(), flightInfoTablet.xSize(), flightInfoTablet.ySize(),2,2);
  dropData.display(dropInfoTablet.xPosition(), dropInfoTablet.yPosition(), dropInfoTablet.xSize(), dropInfoTablet.ySize(), 1, 2);
  
  //The dropdown menu for selecting a port
  dropdownSerial.displayDropdown();
  
  //The baud rate selector
  dropdownBaud.displayDropdown();
  
  //The dropdown refresh button
  SerialRefresh.displayButton();
  SerialRefresh.clickListener();
  if(SerialRefresh.eventTriggered()){
     String[] serialOptions = new String[Serial.list().length+1];
 for(int i = 0;i < Serial.list().length; i++){
  serialOptions[i] = Serial.list()[i]; 
 }
 serialOptions[serialOptions.length-1]="SIMULATE";
 dropdownSerial.updateDropdownItems(serialOptions);
  }
  
  //The alter pos button
  tabletPos.displayButton();
  tabletPos.clickListener();
  if(tabletPos.eventTriggered()){
    GPSGraphTablet.displayEdge(!GPSGraphTablet.displayEdge());
    altGraphTablet.displayEdge(!altGraphTablet.displayEdge());
    flightInfoTablet.displayEdge(!flightInfoTablet.displayEdge());
    dropInfoTablet.displayEdge(!dropInfoTablet.displayEdge());
  }
  
  //The reset position button
  resetTabs.displayButton();
  resetTabs.clickListener();
  if(resetTabs.eventTriggered()){
    GPSGraphTablet.resetDimensions();
    altGraphTablet.resetDimensions();
    flightInfoTablet.resetDimensions();
    dropInfoTablet.resetDimensions();
  }
  
  selectPort.displayButton();
  selectPort.clickListener();
  if(selectPort.eventTriggered()){
     com = dropdownSerial.getSelectedItem();
     if(!com.equals("SIMULATE")){
       portSelected = true;
       
       if(port!=null)
         port.stop();
       
       try{
         port = new Serial(this, com, int(dropdownBaud.selectedItem.trim()));
           dstream = new DataStream();
       dstream.setPort(port); 
     
       println(com + " Opened!"); 
     }
       catch(RuntimeException e){
         portSelected = false;   
       }
     
     }
     else{
       sim = true;
     }
  }
  
}


//Shutdown hook for saving data file
private void prepareExitHandler () {
Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
public void run () {

  if(preferences.saveGPSDATA())
    GPSDATA.close();
    
  if(preferences.saveFLIGHTDATA())
    FLIGHTDATA.close(); 
    
  if(preferences.saveDROPDATA())
    DROPDATA.close(); 
    
}
}));
}
