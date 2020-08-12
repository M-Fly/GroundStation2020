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
 void displayEdge(boolean display){
  displayEdge = display;  
 }
   
  //Resets the dimesions of the square
  void resetDimensions(){
   xPos = defxPos; 
   yPos = defyPos; 
   xSize = defxSize; 
   ySize = defySize; 
  }
   
 //This is for showing the egdes of the panels
 void display(){
  if(displayEdge){
    
   //Display the actual square itself
   fill(#555151);
   stroke(0);
   strokeWeight(2);
   rect(xPos, yPos, xSize, ySize);
   
   fill(#E0E0E0);
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
 
 float xPosition(){
  return xPos + borderWidth; 
 }
 
 float yPosition(){
  return yPos + borderWidth; 
 }
 
 float ySize(){
  return ySize - 2 * borderWidth; 
 }
 
 float xSize(){
  return xSize - 2 * borderWidth; 
 }
 
 boolean displayEdge(){
  return displayEdge; 
 }
 
}
