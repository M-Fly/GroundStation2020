import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Ground_Station_Offical extends PApplet {

 
String[] baudRates = {"300","1200","1800", "2400", "4800", "7200", "9600", "14400", "19200", "31250", "38400", "56000", "57600","1152000","5000000"}; 


public void setup(){
  preferences = new Preferences();
  prepareExitHandler(); 
   
 
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
 gpsplot = new GPSgraph(preferences.LONGSTART(), preferences.LONGEND(), preferences.LATSTART(), preferences.LATEND(), preferences.GPSTailLength());
 
 dropdownSerial = new Dropdown(width/50.0f,height/50.0f,width/10.0f,height/20.0f,color(0xffD3D3D3),"COMS");
 String[] serialOptions = new String[Serial.list().length+1];
 for(int i = 0;i < Serial.list().length; i++){
  serialOptions[i] = Serial.list()[i]; 
 }
 serialOptions[serialOptions.length-1]="SIMULATE";
 dropdownSerial.updateDropdownItems(serialOptions);
 
 dropdownBaud = new Dropdown(width/50.0f + width/10.0f + width/90.0f,height/50.0f,width/10.0f,height/20.0f,color(0xffD3D3D3),"BAUD");
 dropdownBaud.updateDropdownItems(baudRates);
 
 SerialRefresh = new Button(width/50.0f + width/10.0f*2 + width / 90*2, height/50.0f, height/20.0f, height/20.0f,color(0xffD3D3D3), "R");
 
 selectPort = new Button(width/50.0f + width/10.0f*2 + width / 90*3 + height/20.0f, height/50.0f, height/20.0f, height/20.0f,color(0xffD3D3D3), "→");
 
 tabletPos = new Button(width - width/10.0f - width/90, height/50.0f,width/10.0f, height/20.0f,color(0xffD3D3D3), "Pos Adj.");
 
 resetTabs = new Button(width - width/10.0f * 2 - width/90, height/50.0f,width/10.0f, height/20.0f,color(0xffD3D3D3), "Reset Pos");
 
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

public void draw(){
   
  
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
   
   alt+=random(-0.2f,0.2f);
   airSpeed+=random(-0.2f,0.2f);
   latitude += random(-0.2f, 0.2f);
   longitude += random(-0.2f,0.2f);
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
         port = new Serial(this, com, PApplet.parseInt(dropdownBaud.selectedItem.trim()));
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
class Button{
  
  private float xPos, yPos, xSize, ySize; 
  private int buttonCol; 
  private String buttonText;
  private float textSize = 10;
  private boolean eventTriggered = false;  
  private boolean pmousePressed = false;
  
  
  //Constructor with custom coloring
  Button(float xPos, float yPos, float xSize, float ySize, int col, String...buttonText){
   this.xPos = xPos; 
   this.yPos = yPos; 
   this.xSize = xSize; 
   this.ySize = ySize;
   buttonCol = col;
   this.buttonText = buttonText[0];
  }
  
  //This displays the button on the screen
  public void displayButton(){
    stroke(0);
    strokeWeight(2);
    fill(buttonCol);
    rect(xPos, yPos, xSize, ySize);
  
    //Recolor button if the button was pressed
    if(mousePressed && mouseX > xPos && mouseX < xPos + xSize && mouseY > yPos && mouseY < yPos + ySize){
     noStroke();
     fill(0,0,0,50);
     rect(xPos, yPos, xSize, ySize);
    }
  
    
    //Auto size scales then displays the text in the button
    textSize(10);
    float ratio = (xSize / 2) / textWidth(buttonText);
    textSize = 10 * ratio;
    fill(0);
    textAlign(CENTER,CENTER);
    textSize(textSize);
    text(buttonText, (xPos + xSize / 2), (yPos + ySize /2));
  }
  
  //This listens for the button being clicked 
  public void clickListener(){
    
    //This is the first thing called
    //This allows a single loop to occur with the trigger as "true"
    eventTriggered = false; 
    
    //If the mouse was released. This is a click
    if(pmousePressed && !mousePressed && mouseX > xPos && mouseX < xPos + xSize && mouseY > yPos && mouseY < yPos + ySize){
    eventTriggered = true; 
    pmousePressed = false; 
    }
    
    pmousePressed = false; 
    
    //If the mouse is currently being pressed
    if(mousePressed && mouseX > xPos && mouseX < xPos + xSize && mouseY > yPos && mouseY < yPos + ySize){
      pmousePressed = true; 
    }
    
   
    
  }
  
  //This returns weather the button was clicked during a loop or not. 
  //All event that rely on a button click must occur after clickListener() has been called
  //Never call eventTriggered if clickListener is not called again
  //If this is called and clickLister is not called again, this will return true indefinitly
  public boolean eventTriggered(){
    return eventTriggered;
  }
  
  //SETTERS AND GETTERS
  public void setX(float xPos){
   this.xPos = xPos;  
  }
  
  public void setY(float yPos){
   this.yPos = yPos;  
  }
  
  public float getX(){
   return xPos;  
  }
  
  public float getY(){
   return yPos;  
  }
  
  public void setXSize(float xSize){
   this.xSize = xSize;  
  }
  
  public void setYSize(float ySize){
   this.ySize = ySize;  
  }
  
  public float getXSize(){
    return xSize; 
  }
  
  public float getYSize(){
   return ySize;  
  }
  
  public String getText(){
   return buttonText;
  }
  
  public void setText(String text){
    buttonText = text; 
  }
}
class dataPlotter{
  
    //stores the data that is currently displayed on the graph
    private float[] data;
    
    //Stores how many data points are currently being displayed
    private int dataSize; 
    
    //stores the max data value
    private float[] dataMax;
    
    //stores the min data value
    private float[] dataMin;
    
    //Stores where the newest data should be added
    private int offset = 0;
    
    //Default constructor for the data plotter
    public dataPlotter(int precision){
      data = new float[precision];
      dataSize = precision;
      dataMax = new float[2];
      dataMax[0] = 0;
      dataMax[1] = 0;
      dataMin = new float[2];
      dataMin[0] = 0;
      dataMin[1] = 0;
   }
  
  
   public void updateData(float datum){
     
      //This adds the element into the graph
      data[offset] = datum; 
      offset = offset >= dataSize - 1 ? 0 : offset + 1; 
      
      //If the maximum has gone off of the graph, 
      //A new max must be picked
      //This can be done by selecting a new maximum
      
      if(dataMax[0] <= datum){  
       //reset the maximum parameters
       dataMax[0] = datum; 
       dataMax[1] = 0;
      }
      else
      {
       //This is where the new maximum is selected
       dataMax[1]++;
       
       if(dataMax[1] >= dataSize){
         dataMax[0] = data[0];
         
         //The old max no longer exists, so find  a new one
         //Uses linear search
         for(int i = 0; i < dataSize; i ++){
           
           //if there is a relative max, store it
            if(dataMax[0] <= data[i]){
              dataMax[0] = data[i];
              int positionWithOffset = offset - i > 0?offset - i:offset - i+dataSize; 
              dataMax[1] = positionWithOffset;
            }
         }
       }
       
       //This is for determining if there is a new minimum value to display
       if(dataMin[0] >= datum){  
       //reset the maximum parameters
       dataMin[0] = datum; 
       dataMin[1] = 0;
      }
      else
      {
       //This is where the new maximum is selected
       dataMin[1]++;
       if(dataMin[1] >= dataSize){
         dataMin[0] = data[0];
         for(int i = 0; i < dataSize; i ++){
            if(dataMin[0] >= data[i]){
              dataMin[0] = data[i];
              int positionWithOffset = offset - i > 0?offset - i:offset - i+dataSize; 
              dataMin[1] = positionWithOffset;
            }
         }
       }
       
      }
     
   }
   
}

  //This is for visually displaying the screen on the graph
  public void displayGraphMovingAxis(float xPos, float yPos, float xSize, float ySize){
    xPos += xSize/7.0f;
    xSize -= xSize/7.0f;
    fill(0xff9B9B9B);
    stroke(0);
    strokeWeight(2);
    rect(xPos, yPos, xSize, ySize);
    
    
    
    float graphRange = abs(dataMax[0] - dataMin[0]);
   
     
      for(int i = 0; i < 5; i ++){
        
      //Display text increment boxes
      fill(0xff9B9B9B);
      strokeWeight(2);
      stroke(0);
      rect(xPos-xSize/7.0f, yPos + (ySize/5)*i + (ySize/20), xSize/10.0f, ySize/10.0f);
      line(xPos-xSize/7.0f+xSize/10.0f, yPos + (ySize/5)*i + ySize/10, xPos, yPos + (ySize/5)*i + ySize/10);
      strokeWeight(1);
      stroke(0xff292929);
      line(xPos, yPos + (ySize/5)*i + ySize/10, xPos + xSize, yPos + (ySize/5)*i + ySize/10);
      
      //Display text increments
      textAlign(CENTER,CENTER);
       
      
     
       String boxText = str(dataMax[0] - graphRange/5.0f * i - graphRange / 10.0f).length()
       > 5 ?  str(dataMax[0]-graphRange/5.0f * i - graphRange / 10.0f).substring(0,5) :  str(dataMax[0]-graphRange/5.0f * i - graphRange / 10.0f);
      // println("range: " + graphRange);
      // println(boxText);
       textSize(13);
       fill(0,0,255);
       float ratio = ((xSize) / 13) / textWidth(boxText);
       textSize(abs(13 * ratio));
       if(graphRange!=0){
         text(boxText, xPos-xSize/7.0f+xSize/20.0f, yPos + (ySize/5)*i + ySize/10);  
       }
      
    }
    
    //Displays the graph information
    overlayData(xPos, yPos, xSize, ySize);
    
  }


  //This is used to display the actual plotted data on the graph
  private void overlayData(float xPos, float yPos, float xSize, float ySize){
    
    int iter = offset; 
    for(int i = 0; i < dataSize; i++){
       float mappedDataVal1 = map(data[getDataCircular(iter)], dataMin[0], dataMax[0], yPos + ySize, yPos);
       float mappedDataVal2 = map(data[getDataCircular(iter-1)], dataMin[0], dataMax[0], yPos + ySize, yPos);
       
       stroke(0,0,255);
       line(xPos + xSize - (xSize / dataSize) * i, mappedDataVal1, xPos + xSize - (xSize / dataSize) * (i+1),  mappedDataVal2);
       iter--;
    }
    
  }

  //Returns the data, but if a value is out of range, it wraps around
  private int getDataCircular(int position){
    
    if(position >= dataSize){
     return position%dataSize; 
    }
    
    if(position < 0){
      while(position < 0)
      position += dataSize;
      return position;
    }
    
    return position;
  }


   //getters for some of the values
   public float getMaxVal(){
      return dataMax[0];
   }
    
   public float getMinVal(){
     return dataMin[0]; 
   }
   
   public float getMaxValTime(){
     return dataMax[1];
   }
   
   public float getMinValTime(){
     return dataMin[1];
   }

   public float getNewestData(){
    return data[getDataCircular(offset-1)]; 
   }
}

//An easy method for displaying data
class dataDisplay{
  
  private ArrayList<String> titles;  
  private ArrayList<String> datum;
  private float numElements;
  private float cellHeight;
  private float cellWidth;
  
  //default constructor
dataDisplay(){
  titles = new ArrayList<String>();
  datum = new ArrayList<String>();
  numElements = 0;
 }
 
 //This pushes an elemt into the class
 //Must add the title of the data along with its inital value
 public void addElement(String title, String datums){ 
   titles.add(title);
   datum.add(datums);
   ++numElements; 
 }
 
 public void updateElementData(String datums, int index){
   datum.set(index, datums);
 }
 
 //Displays the elements onto a readable table 
 //given the size constraints 
 //Also can select how many rows and columns the table has
 public void display(float xPos, float yPos, float xSize, float ySize, int rows, int columns){
   strokeWeight(2);
   stroke(0);
   fill(0xff9B9B9B);
   rect(xPos, yPos, xSize, ySize);
   
   cellHeight = ySize/rows;
   cellWidth = xSize/columns;   
    
   //This displays the horizontal grid lines
   for(float i = yPos + (ySize/rows); i < yPos + ySize; i+=(ySize/rows)){
      line(xPos, i, xPos + xSize, i);
   }
 
 
   //Displays the vertical grid lines 
   for(float i = xPos + (xSize/columns); i < xPos + xSize; i+=(xSize/columns)){
      line(i, yPos, i, yPos+ySize);
   }
   
   //Display the titles and the data in the given cell
   //Traverses the data by filling a row, then moving to next row
   int iter = 0;
   fill(0);
   textAlign(CENTER,CENTER);
   for(int i = 0; i < ceil((float)numElements/columns) && iter < titles.size(); i++){
     for(int j = 0; (j < columns) && iter < titles.size(); j++){
       
       //Displays the title information of the cell
       //Format textSize based on the size of the text
       textSize(13);
       fill(0,0,0);
       float ratio = (cellWidth / 2) / textWidth(titles.get(iter));
       textSize(13 * ratio);
       text(titles.get(iter),xPos+(xSize/columns)*j+cellWidth/2, yPos+(ySize/rows)*i+cellHeight/4);
       
       //Displays the data that is stored with the given title
       //Formats the text size so it fits within the box
       textSize(13);
       fill(0,0,255);
       ratio = (cellWidth / 2) / textWidth(datum.get(iter));
       textSize(13 * ratio);
       text(datum.get(iter),xPos+(xSize/columns)*j+cellWidth/2, yPos+(ySize/rows)*i+3*cellHeight/5);
       
       //move on to the next data
       iter++;
     }
   }
   
   
   
 }
 
 
  
}


class DataStream {
  
  //The serial stream
  private Serial serialPort; 
  private String message;
  private String AMESSAGE, BMESSAGE, CMESSAGE, DMESSAGE;
 
   DataStream(){
    AMESSAGE = ""; 
    BMESSAGE = ""; 
    CMESSAGE = ""; 
    DMESSAGE = ""; 
   }
  //This is what sets the serial port for use
  //No other functions should be called without setting the serial port
  public void setPort(Serial port){
    serialPort = port; 
  }
  
  public void readSerial(){
   message = serialPort.readStringUntil(';'); 
   if(message!=null){
   if(message.charAt(0) == 'A')
     AMESSAGE = message;
   else if(message.charAt(0) == 'B')
     BMESSAGE = message; 
   else if(message.charAt(0) == 'C')
     CMESSAGE = message; 
   else if(message.charAt(0) == 'D')
     DMESSAGE = message; 
  }
  }
  public void readSampleData(String sampleData){
   message = sampleData;  
    if(message.charAt(0) == 'A')
     AMESSAGE = message;
   else if(message.charAt(0) == 'B')
     BMESSAGE = message; 
   else if(message.charAt(0) == 'C')
     CMESSAGE = message; 
   else if(message.charAt(0) == 'D')
     DMESSAGE = message; 
  }
  
  //Return the messages as a string
  public String getAMESSAGE(){
    return AMESSAGE; 
  }
  
  public String getBMESSAGE(){
    return BMESSAGE; 
  }
  
  public String getCMESSAGE(){
    return CMESSAGE; 
  }
  
  public String getDMESSAGE(){
    return DMESSAGE; 
  }
  
  //Return the messages as a parsed array
  public String[] getParsedAMESSAGE(){
   return split(AMESSAGE, ','); 
  }
  
  public String[] getParsedBMESSAGE(){
   return split(BMESSAGE, ','); 
  }
  
  public String[] getParsedCMESSAGE(){
   return split(CMESSAGE, ','); 
  }
  
  public String[] getParsedDMESSAGE(){
   return split(DMESSAGE, ','); 
  }
  
  
};


class Dropdown{
  
  private float xPos, yPos, xSize, ySize; 
  private String textValues[]; 
  private String dropdownName; //The name that is displayed on the dropdown
  private Button dropdown; 
  private boolean selected = false;//Has anything been selected yet from the dropdown 
  private boolean dropped = false;  
  private String[] items=new String[0]; 
  private ArrayList<Button> menuItems = new ArrayList<Button>(); 
  private String selectedItem; 
  
  //The default constructor for the dropdown menu
  Dropdown(float xPos, float yPos, float xSize, float ySize, int col, String...buttonText){
   this.xPos = xPos; 
   this.yPos = yPos; 
   this.xSize = xSize; 
   this.ySize = ySize;
   this.dropdownName = buttonText[0]; 
   dropdown = new Button(xPos, yPos, xSize, ySize, color(211,211,211),buttonText[0] + "↓"); 
   selectedItem = "";
  }
  
  public void updateDropdownItems(String[] items){
     this.items = items; 
     if(menuItems.size() > 0)
       menuItems.clear();
       for(int i = 0; i < items.length; i++){
         menuItems.add(new Button(xPos, yPos + ySize * i, xSize, ySize, color(211, 211, 211), items[i]));
       }  
  }
  
  public void displayDropdown(){
    if(!dropped) 
    dropdown.displayButton();
    
    dropdown.clickListener();
   
    if(dropdown.eventTriggered())
       dropped = true; 
     
    //What to display once the menu has dropped down
    if(dropped){
      for(int i = 0; i < items.length; i++){
       menuItems.get(i).displayButton();
       menuItems.get(i).clickListener();
       
       if(menuItems.get(i).eventTriggered()){
          selected = true; 
          selectedItem = menuItems.get(i).getText();
          dropdown.setText(selectedItem + "↓");
          dropped = false;
       }
       
      }
    }
   
  }
  
  public String getSelectedItem(){
   return selectedItem;  
  }
  
}
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
  public void updatePosition(float longData, float latData){
    tailX[offset] = longData;  
    tailY[offset] = latData;
    offset = offset == tailLength - 1 ? 0 : offset + 1; 
  }
  
  //This displays the graph of the GPS coordinates
 public void displayLatLongGraph(float xPos, float yPos, float xSize, float ySize){
   strokeWeight(2);
   stroke(0);
   fill(0xff9B9B9B);
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
   fill(0xffC88ED8);
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
class Evaluator{

  private float airSpeed; 
  private float alt;
  private float tach;
  private float latitude; 
  private float longitude; 
  
  //Default Constructor
  Evaluator(){}
  
  //Setters ------------------------------------
  
  public void setAirspeed(float airSpeed){
    
    //REPLACE WITH CONVERSIONS FROM THE DAS NUMBERS TO THE WANTED OUTPUTS 
    this.airSpeed = airSpeed; 
  }

  public void setAlt(float alt){
    
   //REPLACE WITH CONVERSIONS FROM THE DAS NUMBERS TO THE WANTED OUTPUTS 
   this.alt = alt;  
  }
  
  public void setTach(float tach){
    
    //REPLACE WITH CONVERSIONS FROM THE DAS NUMBERS TO THE WANTED OUTPUTS 
   this.tach = tach;  
  }
  
  public void setLatitude(float lat){
    
    //REPLACE WITH CONVERSIONS FROM THE DAS NUMBERS TO THE WANTED OUTPUTS 
   this.latitude = latitude;  
  }

  public void setLongitude(float lon){
    
    //REPLACE WITH CONVERSIONS FROM THE DAS NUMBERS TO THE WANTED OUTPUTS 
   this.longitude = lon;  
  }
  
  public float getAirspeed(){
   return airSpeed; 
  }
  
  public float getAlt(){
   return alt;  
  }
  
  public float getTach(){
   return tach; 
  }
  
  public float getLatitude(){
   return latitude;  
  }
  
  public float getLongitude(){
   return longitude;  
  }

  public void readAMESSAGE(String[] AMESSAGE){
   if(AMESSAGE.length>=9){
    alt = PApplet.parseFloat(AMESSAGE[3]);
   airSpeed = PApplet.parseFloat(AMESSAGE[4]);
   }
  }
  
  public void readBMESSAGE(String[] BMESSAGE){
   
   if(BMESSAGE.length >= 10){ 
   latitude = PApplet.parseFloat(BMESSAGE[4]); 
   longitude = PApplet.parseFloat(BMESSAGE[5]); 
   }
  }

}
class Tablet{
 
 //The initial state values are stored
 private float defxPos, defyPos, defxSize, defySize;
 
 //The values that are allowed to change based on the program
 private float xPos, yPos, xSize, ySize;
 
 //The tablet border width
 private float borderWidth;

 //Adjust the table size
 private boolean adjustSize = false; 
 
 //Adjust the tablet position
 private boolean adjustPos = false; 
 
 //Display the tablet edges or not(for resizing)
 private boolean displayEdge = false;
 
 //Default constructor
 Tablet(float xPos, float yPos, float xSize, float ySize, float borderWidth){
   this.xPos = xPos; 
   this.yPos = yPos; 
   this.xSize = xSize; 
   this.ySize = ySize; 
   this.borderWidth = borderWidth;
   
   //Defaults
   defxPos = xPos; 
   defyPos = yPos; 
   defxSize = xSize; 
   defySize = ySize; 
 }
  
 //Edit if you want to show the edges of the display boxes or not
 public void displayEdge(boolean display){
  displayEdge = display;  
 }
   
  //Resets the dimesions of the square
  public void resetDimensions(){
   xPos = defxPos; 
   yPos = defyPos; 
   xSize = defxSize; 
   ySize = defySize; 
  }
   
 //This is for showing the egdes of the panels
 public void display(){
  if(displayEdge){
    
   //Display the actual square itself
   fill(0xff555151);
   stroke(0);
   strokeWeight(2);
   rect(xPos, yPos, xSize, ySize);
   
   fill(0xffE0E0E0);
   rect(xPos + borderWidth, yPos + borderWidth, xSize - borderWidth * 2, ySize - borderWidth * 2); 
  
  strokeWeight(1);
  stroke(0);
  rect(xPos + xSize - borderWidth, yPos + ySize - borderWidth, borderWidth, borderWidth);
  rect(xPos, yPos, borderWidth, borderWidth);
  
  
  //If they click the move boxes, then change the dimansions
  if(mousePressed && mouseX > xPos && mouseX < xPos + borderWidth && mouseY > yPos && mouseY < yPos + borderWidth){
   adjustPos = true; 
  }
  
  
  if(mousePressed && mouseX > xPos + xSize - borderWidth && mouseX < xPos + xSize && mouseY > yPos + ySize - borderWidth&& mouseY < yPos + ySize){
   adjustSize = true; 
  }
  }
  
  if(adjustSize){
   xSize += mouseX - pmouseX;
   ySize += mouseY - pmouseY;
  }
  if(adjustPos){
    xPos += mouseX - pmouseX;
    yPos += mouseY - pmouseY;
  }
  
  if(!mousePressed){
   adjustSize = false; 
   adjustPos = false;
  }
  
 }
 
 public float xPosition(){
  return xPos + borderWidth; 
 }
 
 public float yPosition(){
  return yPos + borderWidth; 
 }
 
 public float ySize(){
  return ySize - 2 * borderWidth; 
 }
 
 public float xSize(){
  return xSize - 2 * borderWidth; 
 }
 
 public boolean displayEdge(){
  return displayEdge; 
 }
 
}
class RuntimeExeption{}
class Preferences{
  String[] lines; 
  String[] parsedData; 
  Preferences(){
    lines = loadStrings("Preferences.txt");
    parsedData = new String[lines.length - 4];
    parsePreferences();
  }

  private void parsePreferences(){
    int skippedLines = 0;
    for(int i = 2; i < lines.length; i ++){
      if(i == 9 || i == 26){
        i++;
        skippedLines ++;   
    }
        parsedData[i-skippedLines - 2] = split(lines[i],':')[1]; 
    }
  }
  
  //Should the GPS DATA be saved 
  public boolean saveGPSDATA(){
   return parsedData[0].toUpperCase().trim().equals("TRUE");
  }
  
  //Should the ALT DATA be saved 
  public boolean saveALTDATA(){
   return parsedData[1].toUpperCase().trim().equals("TRUE");
  }
  
  //Should the DROP DATA be saved 
  public boolean saveDROPDATA(){
   return parsedData[2].toUpperCase().trim().equals("TRUE");
  }
  
  //Should the FLIGHT DATA be saved 
  public boolean saveFLIGHTDATA(){
   return parsedData[3].toUpperCase().trim().equals("TRUE");
  }
  
  public float GPSTailLength(){
    return PApplet.parseFloat(parsedData[4]);
  }
  
  public float altGraphDataPoints(){
   return PApplet.parseFloat(parsedData[5]); 
  }
  
  public boolean customTablets(){
   return parsedData[6].toUpperCase().trim().equals("TRUE"); 
  }
  
  public float ALTX(){
    return PApplet.parseFloat(parsedData[7]);    
  }

  public float ALTY(){
    return PApplet.parseFloat(parsedData[8]);    
  }
  
  public float ALTXSIZE(){
    return PApplet.parseFloat(parsedData[9]);    
  }
  
  public float ALTYSIZE(){
    return PApplet.parseFloat(parsedData[10]);    
  }
  
  public float GPSX(){
    return PApplet.parseFloat(parsedData[11]);    
  }

  public float GPSY(){
    return PApplet.parseFloat(parsedData[12]);    
  }
  
  public float GPSXSIZE(){
    return PApplet.parseFloat(parsedData[13]);    
  }
   
  public float GPSYSIZE(){
    return PApplet.parseFloat(parsedData[14]);    
  }

  public float FLIGHTX(){
    return PApplet.parseFloat(parsedData[15]);    
  }

  public float FLIGHTY(){
    return PApplet.parseFloat(parsedData[16]);    
  }

  public float FLIGHTXSIZE(){
    return PApplet.parseFloat(parsedData[17]);    
  }
  
  public float FLIGHTYSIZE(){
    return PApplet.parseFloat(parsedData[18]);    
  }

  public float DROPX(){
    return PApplet.parseFloat(parsedData[19]);    
  }

 public float DROPY(){
    return PApplet.parseFloat(parsedData[20]);    
  }

 public float DROPXSIZE(){
    return PApplet.parseFloat(parsedData[21]);    
 }
 
  
 public float DROPYSIZE(){
    return PApplet.parseFloat(parsedData[22]);    
  }

 public String[] parsed(){
  return parsedData;  
 }

   public float LATSTART(){
   return PApplet.parseFloat(parsedData[23]);  
 }
 
  public float LATEND(){
   return PApplet.parseFloat(parsedData[24]);  
 }
 
  public float LONGSTART(){
   return PApplet.parseFloat(parsedData[25]);  
 }
 
  public float LONGEND(){
   return PApplet.parseFloat(parsedData[26]);  
 }

};
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Ground_Station_Offical" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
