class Button{
  
  private float xPos, yPos, xSize, ySize; 
  private color buttonCol; 
  private String buttonText;
  private float textSize = 10;
  private boolean eventTriggered = false;  
  private boolean pmousePressed = false;
  
  
  //Constructor with custom coloring
  Button(float xPos, float yPos, float xSize, float ySize, color col, String...buttonText){
   this.xPos = xPos; 
   this.yPos = yPos; 
   this.xSize = xSize; 
   this.ySize = ySize;
   buttonCol = col;
   this.buttonText = buttonText[0];
  }
  
  //This displays the button on the screen
  void displayButton(){
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
  void clickListener(){
    
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
  boolean eventTriggered(){
    return eventTriggered;
  }
  
  //SETTERS AND GETTERS
  void setX(float xPos){
   this.xPos = xPos;  
  }
  
  void setY(float yPos){
   this.yPos = yPos;  
  }
  
  float getX(){
   return xPos;  
  }
  
  float getY(){
   return yPos;  
  }
  
  void setXSize(float xSize){
   this.xSize = xSize;  
  }
  
  void setYSize(float ySize){
   this.ySize = ySize;  
  }
  
  float getXSize(){
    return xSize; 
  }
  
  float getYSize(){
   return ySize;  
  }
  
  String getText(){
   return buttonText;
  }
  
  void setText(String text){
    buttonText = text; 
  }
}
