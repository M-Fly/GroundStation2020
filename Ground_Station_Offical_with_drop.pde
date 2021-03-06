//     __  ___      ________         _________       __    __     ______            __             __   _____       ______
//    /  |/  /     / ____/ /_  __   / ____/ (_)___ _/ /_  / /_   / ____/___  ____  / /__________  / /  / ___/____  / __/ /__      ______ _________
//   / /|_/ /_____/ /_  / / / / /  / /_  / / / __ `/ __ \/ __/  / /   / __ \/ __ \/ __/ ___/ __ \/ /   \__ \/ __ \/ /_/ __/ | /| / / __ `/ ___/ _ \
//  / /  / /_____/ __/ / / /_/ /  / __/ / / / /_/ / / / / /_   / /___/ /_/ / / / / /_/ /  / /_/ / /   ___/ / /_/ / __/ /_ | |/ |/ / /_/ / /  /  __/
// /_/  /_/     /_/   /_/\__, /  /_/   /_/_/\__, /_/ /_/\__/   \____/\____/_/ /_/\__/_/   \____/_/   /____/\____/_/  \__/ |__/|__/\__,_/_/   \___/
//                      /____/             /____/
//                             //<>//
// 
import org.apache.commons.math3.analysis.function.*;

import processing.serial.*; 
String[] baudRates = {"300", "1200", "1800", "2400", "4800", "7200", "9600", "14400", "19200", "31250", "38400", "56000", "57600", "1152000", "5000000"}; 


void setup() {
  preferences = new Preferences();
  prepareExitHandler(); 
  fullScreen(); 

  //create a save file for the GPS data
  if (preferences.saveGPSDATA()) {
    String fileName = "GPSDATA -- time"+hour()+"-"+minute()+"-"+second()+" -- date"+day()+"-"+month()+"-"+year()+".txt";
    GPSDATA = createWriter(fileName); 
    GPSDATA.println("GPS DATA LOG FILE");
    GPSDATA.println("TIME:"+hour()+":"+minute()+":"+second());
    GPSDATA.println("DATE:"+day()+":"+month()+":"+year());
    for (int i = 0; i < 60; i ++)
      GPSDATA.print("*");
    GPSDATA.println();
    GPSDATA.println("LONGITUDE,LATITUDE");
  }

  //create a save file for the Flight data
  if (preferences.saveFLIGHTDATA()) {
    String fileName = "FLIGHTDATA -- "+hour()+"-"+minute()+"-"+second()+"-"+day()+"-"+month()+"-"+year()+".txt";
    FLIGHTDATA = createWriter(fileName); 
    FLIGHTDATA.println("FLIUGHT DATA LOG FILE");
    FLIGHTDATA.println("TIME:"+hour()+":"+minute()+":"+second());
    FLIGHTDATA.println("DATE:"+day()+":"+month()+":"+year());
    for (int i = 0; i < 60; i ++)
      FLIGHTDATA.print("*");
    FLIGHTDATA.println();
    FLIGHTDATA.println("ALTITUDE,AIRSPEED");
  }

  //create a save file for the GPS data
  if (preferences.saveDROPDATA()) {
    String fileName = "DROPDATA -- "+hour()+"-"+minute()+"-"+second()+"-"+day()+"-"+month()+"-"+year()+".txt";
    DROPDATA = createWriter(fileName); 
    DROPDATA.println("GPS DATA LOG FILE");
    DROPDATA.println("TIME:"+hour()+":"+minute()+":"+second());
    DROPDATA.println("DATE:"+day()+":"+month()+":"+year());
    for (int i = 0; i < 60; i ++)
      DROPDATA.print("*");
    DROPDATA.println();
    DROPDATA.println("NULL");
  }

  //Set up the sizing for the display tabelts
  if (preferences.customTablets() == false) {
    altGraphTablet = new Tablet(width / 35 - width / (35*2), height / 10, width / 3 - width / 30, height / 2, width > height ? height / 70 : width /70);
    GPSGraphTablet = new Tablet(width / 35 + (width / 3) - width / (35*2), height / 10, width / 3 - width / 30, height / 2, width > height ? height / 70 : width /70);
    flightInfoTablet = new Tablet(width / 35 +  2*(width / 3)- width / (35*2), height / 10, width / 3 - width / 30, height / 2, width > height ? height / 70 : width /70);
    dropInfoTablet = new Tablet(width / 35 + (width / 3) - width / (35*2), height / 10 + height / 2 + height/20, width / 3 - width / 30, height / 4, width > height ? height / 70 : width /70);
  } else {
    altGraphTablet = new Tablet(preferences.ALTX(), preferences.ALTY(), preferences.ALTXSIZE(), preferences.ALTYSIZE(), width > height ? height / 70 : width /70);
    GPSGraphTablet = new Tablet(preferences.GPSX(), preferences.GPSY(), preferences.GPSXSIZE(), preferences.GPSYSIZE(), width > height ? height / 70 : width /70);
    flightInfoTablet = new Tablet(preferences.FLIGHTX(), preferences.FLIGHTY(), preferences.FLIGHTXSIZE(), preferences.FLIGHTYSIZE(), width > height ? height / 70 : width /70);
    dropInfoTablet = new Tablet(preferences.DROPX(), preferences.DROPY(), preferences.DROPXSIZE(), preferences.DROPYSIZE(), width > height ? height / 70 : width /70);
  }

  printArray(preferences.parsed());

  //This is for setting up the alt graph 
  altGraph = new dataPlotter((int)preferences.altGraphDataPoints()); 

  //For the GPS Graph
  gpsplot = new GPSgraph(preferences.LONGSTART(), preferences.LONGEND(), preferences.LATSTART(), preferences.LATEND(), preferences.GPSTailLength());

  //Create a dropdown menu with all the available serial ports
  dropdownSerial = new Dropdown(width/50.0, height/50.0, width/10.0, height/20.0, color(#D3D3D3), "COMS");
  String[] serialOptions = new String[Serial.list().length+1];
  for (int i = 0; i < Serial.list().length; i++) {
    serialOptions[i] = Serial.list()[i]; //This creates a list that is fed to the dropdown menu
  }

  //add a serial option that allows for "simulated" or "test" data to be used rather than serial data
  //This is best for showing how the program works or teaching about the program
  serialOptions[serialOptions.length-1]="SIMULATE";
  dropdownSerial.updateDropdownItems(serialOptions);

  //Add a dropdown menu for the different available baud rates
  dropdownBaud = new Dropdown(width/50.0 + width/10.0 + width/90.0, height/50.0, width/10.0, height/20.0, color(#D3D3D3), "BAUD");
  dropdownBaud.updateDropdownItems(baudRates);

  //Create a button that will allow the user to refresh the serial ports
  //(If a new device was plugged in and is not showing up, refresh the ports)
  SerialRefresh = new Button(width/50.0 + width/10.0*2 + width / 90*2, height/50.0, height/20.0, height/20.0, color(#D3D3D3), "R");

  //Once a port and a baud rate have been selected, this is the "Continue" button
  selectPort = new Button(width/50.0 + width/10.0*2 + width / 90*3 + height/20.0, height/50.0, height/20.0, height/20.0, color(#D3D3D3), "→");

  //The button that allows the user to toggle the option to move around the data widgets
  tabletPos = new Button(width - width/10.0 - width/90, height/50.0, width/10.0, height/20.0, color(#D3D3D3), "Pos Adj.");

  //Reset the tabs to their default position
  //If custom positions were used, this will reset them to their default positions
  resetTabs = new Button(width - width/10.0 * 2 - width/90, height/50.0, width/10.0, height/20.0, color(#D3D3D3), "Reset Pos");

  //Create the flight data table
  //The data that is displayed: Altitude, Airspeed, Latitude, Longitude
  //TODO: Add a reading for an onboard tachometer
  flightData = new dataDisplay();
  flightData.addElement(" ALT(ft) ", "");
  flightData.addElement(" ALT(m) ", "");
  flightData.addElement("AIRSPEED:", "");
  flightData.addElement("    LAT    ", "");
  flightData.addElement("   LONG  ", "");
  flightData.addElement("GPS SPEED(mph)" , ""); 
  flightData.addElement("  GPS ALT  ", ""); 
  flightData.addElement("GPS Heading", ""); 
  
  //The drop data table
  //TODO: Implment the data streams that actually deal with this data
  dropData = new dataDisplay(); 
  dropData.addElement("Water:", "NOT DROPPED");
  dropData.addElement("GLIDERS:", "NOT DROPPED");

  //The data stream evaluator
  //This takes the raw serial data (unprocessed) and process to get its values
  dstreamEval = new Evaluator();
}

PrintWriter GPSDATA; //File writer for the GPS data
PrintWriter FLIGHTDATA;//File writer for the Flight data
PrintWriter DROPDATA; //File writer for the Drop data

//The serial com port
Serial port; 

//The display tablets the control where things are displayed
Tablet altGraphTablet, GPSGraphTablet, flightInfoTablet, dropInfoTablet;

//A preferences getter. Determines what it is that the user wants in the program based on the 
//preferences file
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

//The Serial data processor
Evaluator dstreamEval;

//This is what reads the unprocessed serial data 
DataStream dstream; 

//The selected com port
String com = ""; 
boolean portSelected = false;

//Running on simulated data or not
boolean sim = false; 

//Vars for the sim data
float alt = 100;
float airSpeed = 100; 
double latitude = 100;
double longitude = 100; 
double heading = 0; 


void draw() {

  //If a port is selected and its not the simulated data port
  if (portSelected && !sim) {
    
    
    //Read in the serial data bits
    dstream.readSerial(); 

    //Send the serial data off to get processed and converted
    //TODO: Create the CMESSAGE and DMESSAGE classes, if needed
    dstreamEval.readAMESSAGE(dstream.getParsedAMESSAGE());
    dstreamEval.readBMESSAGE(dstream.getParsedBMESSAGE());

    //Update the data. This gets the data from the dstreamEvaluator.
    //This also checks how long the data is. The requires that no data is longer than 6 characters in lengths
    flightData.updateElementData(str(dstreamEval.getAlt()).length() > 6 ? str(dstreamEval.getAlt()).substring(0, 6) : str(dstreamEval.getAlt()), 1);
    flightData.updateElementData(str(dstreamEval.getAltFT()).length() > 6 ? str(dstreamEval.getAltFT()).substring(0, 6) : str(dstreamEval.getAltFT()), 0);
    flightData.updateElementData(str(dstreamEval.getAirspeed()).length() > 6 ? str(dstreamEval.getAirspeed()).substring(0, 6) : str(dstreamEval.getAirspeed()), 2);
   // flightData.updateElementData(str((float)dstreamEval.getLatitude()).length() > 6 ? str((float)dstreamEval.getLatitude()).substring(0, 6) : str((float)dstreamEval.getLatitude()), 2);
    //flightData.updateElementData(str((float)dstreamEval.getLongitude()).length() > 6 ? str((float)dstreamEval.getLongitude()).substring(0, 6) : str((float)dstreamEval.getLongitude()), 3);
    flightData.updateElementData(Double.toString(dstreamEval.getLatitude()), 3); 
    flightData.updateElementData(Double.toString(dstreamEval.getLongitude()), 4); 
    flightData.updateElementData(Double.toString(dstreamEval.getGpsSpeed()), 5); 
    flightData.updateElementData(Double.toString(dstreamEval.getGpsAlt()), 6); 
    flightData.updateElementData(Double.toString(dstreamEval.getHeading()), 7);
    //flightData.updateElementData((dstream.getParsedBMESSAGE()[4]), 2);
    //flightData.updateElementData((dstream.getParsedBMESSAGE()[5]), 3);
    
    altGraph.updateData(dstreamEval.getAlt());

    //Update the gps data with the new serial data
    gpsplot.updatePosition(dstreamEval.getLongitude(), dstreamEval.getLatitude());

    //Save the data if the preferences says that is what is supposed to be done
    if (preferences.saveGPSDATA())
      GPSDATA.println(dstreamEval.getLongitude()+","+ dstreamEval.getLatitude());
  }
  if (preferences.saveFLIGHTDATA()) {
    FLIGHTDATA.println(dstreamEval.getAlt()+","+dstreamEval.getAirspeed());
  }

  //If the user selected sim data.
  if (sim)
  {
    flightData.updateElementData(str(alt).length() > 6 ? str(alt).substring(0, 6) : str(alt), 0);
    flightData.updateElementData(str(airSpeed).length() > 6 ? str(airSpeed).substring(0, 6) : str(airSpeed), 1);
    flightData.updateElementData(str((float)latitude).length() > 6 ? str((float)latitude).substring(0, 6) : str((float)latitude), 2);
    flightData.updateElementData(str((float)longitude).length() > 6 ? str((float)longitude).substring(0, 6) : str((float)longitude), 3);
    altGraph.updateData(alt);
    gpsplot.updatePosition(longitude, latitude);

    //Randomizes the test data
    // alt+= Math.random(-0.2,0.2);
    //airSpeed+= Math.random(-0.2,0.2);
    //latitude +=Math.random(-0.2, 0.2);
    //longitude += Math.random(-0.2,0.2);

    //Randomizes the test data
    alt=sin((float)millis()/500) + 100;
    airSpeed+=random(-0.2, 0.2);

    double pLat = latitude; 
    double pLong = longitude; 
    
    latitude = sin((float)millis()/500)/120 + 100;
    longitude = cos((float)millis()/500)/120 + 100;
  
    heading = Math.atan2( (latitude - pLat) , (longitude - pLong) ); 
    
    Vector dheading = new Vector( (longitude - pLong) , (latitude - pLat) , 0); 
    Vector north = new Vector( 0, 1, 0); 
    
    double angle = Math.atan2(dheading.y, dheading.x); 
    heading = angle; 
   // heading = heading < 0 ? heading + Math.PI : heading; 
    
    println(heading); 
}

  //Set background to white
  background(255);
  fill(0);

  //Display the tablets
  //Tablets only show up when display is called if Tablet.displayEdge(true) is called.
  GPSGraphTablet.display();
  altGraphTablet.display();
  flightInfoTablet.display();
  dropInfoTablet.display();


  //This Displays the plots where they are supposed to be positioned
  gpsplot.displayLatLongGraph(GPSGraphTablet.xPosition(), GPSGraphTablet.yPosition(), GPSGraphTablet.xSize(), GPSGraphTablet.ySize());
  gpsplot.displayDropPrediction(alt, dstreamEval.getGpsSpeed_mps(), dstreamEval.getHeading(), GPSGraphTablet.xPosition(), GPSGraphTablet.yPosition(), GPSGraphTablet.xSize(), GPSGraphTablet.ySize());
  
  
  altGraph.displayGraphMovingAxis(altGraphTablet.xPosition(), altGraphTablet.yPosition(), altGraphTablet.xSize(), altGraphTablet.ySize());
  flightData.display(flightInfoTablet.xPosition(), flightInfoTablet.yPosition(), flightInfoTablet.xSize(), flightInfoTablet.ySize(), 4, 2);
  dropData.display(dropInfoTablet.xPosition(), dropInfoTablet.yPosition(), dropInfoTablet.xSize(), dropInfoTablet.ySize(), 1, 2);

  //The dropdown menu for selecting a port
  dropdownSerial.displayDropdown();

  //The baud rate selector
  dropdownBaud.displayDropdown();

  //The dropdown refresh button
  SerialRefresh.displayButton();
  SerialRefresh.clickListener();
  if (SerialRefresh.eventTriggered()) {
    //All the ports must be refreshed. We must reread the com information, and then 
    //Also add back the "SIMULATE" option
    String[] serialOptions = new String[Serial.list().length+1]; 

    //Put all the serial information into the new array
    for (int i = 0; i < Serial.list().length; i++) {
      serialOptions[i] = Serial.list()[i];
    }

    //Add the "SIMULATE" option then update the information in the dropdown menu. 
    serialOptions[serialOptions.length-1]="SIMULATE";
    dropdownSerial.updateDropdownItems(serialOptions);
  }

  //The alter pos button
  tabletPos.displayButton();
  tabletPos.clickListener();
  if (tabletPos.eventTriggered()) {

    //Calling the .displayEdge(boolean) function changes wheather to display the edges that appear.
    //Calling .displayEdge() return the current state, so !displayEdge() will return the opposite of the current state.
    //Set the state to oposite will invert the current display state.
    GPSGraphTablet.displayEdge(!GPSGraphTablet.displayEdge());
    altGraphTablet.displayEdge(!altGraphTablet.displayEdge());
    flightInfoTablet.displayEdge(!flightInfoTablet.displayEdge());
    dropInfoTablet.displayEdge(!dropInfoTablet.displayEdge());
  }

  //The reset position button
  resetTabs.displayButton();
  resetTabs.clickListener();
  if (resetTabs.eventTriggered()) {
    GPSGraphTablet.resetDimensions();
    altGraphTablet.resetDimensions();
    flightInfoTablet.resetDimensions();
    dropInfoTablet.resetDimensions();
  }

  //The select port button display and listener
  selectPort.displayButton();
  selectPort.clickListener();
  if (selectPort.eventTriggered()) {

    //Set the com port to equal whatever is currently selected in the
    //Port selection dropdown menu
    com = dropdownSerial.getSelectedItem();

    //If the com port is not the sim port, then 
    //a new port object must be created
    if (!com.equals("SIMULATE")) {

      //A port has been selected 
      portSelected = true;

      //If a new port is opened, the old port must be closed to avoid error
      if (port!=null)
        port.stop();

      //Ports may be busy. This handles busy ports by catching the thrown runtime exception
      try {

        //Create new port object
        port = new Serial(this, com, int(dropdownBaud.selectedItem.trim()));

        //Open new dstream and set the port of the new datastream
        dstream = new DataStream();
        dstream.setPort(port); 

        println(com + " Opened!");
      }
      catch(RuntimeException e) {
        //If an errord port was selected, do nothing
        portSelected = false;
      }
    } else {
      sim = true;
    }
  }
}


//Shutdown hook for saving data file
private void prepareExitHandler () {
  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run () {

      if (preferences.saveGPSDATA())
      GPSDATA.close();

      if (preferences.saveFLIGHTDATA())
      FLIGHTDATA.close(); 

      if (preferences.saveDROPDATA())
      DROPDATA.close();
    }
  }
  ));
}
