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
      dataSize = precision;//How many data points there are
      dataMax = new float[2];//the maximum value that has occured on the graph
      dataMax[0] = 0;
      dataMax[1] = 0;
      dataMin = new float[2];//The minimum value that has occured in the data
      dataMin[0] = 0;
      dataMin[1] = 0;
   }
  
  
   //This function adds a new data point into the data, and delets the oldest data
   void updateData(float datum){
     
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
  void displayGraphMovingAxis(float xPos, float yPos, float xSize, float ySize){
    xPos += xSize/7.0;
    xSize -= xSize/7.0;
    fill(#9B9B9B);
    stroke(0);
    strokeWeight(2);
    rect(xPos, yPos, xSize, ySize);
    
    
    
    float graphRange = abs(dataMax[0] - dataMin[0]);
   
     
      for(int i = 0; i < 5; i ++){
        
      //Display text increment boxes
      fill(#9B9B9B);
      strokeWeight(2);
      stroke(0);
      rect(xPos-xSize/7.0, yPos + (ySize/5)*i + (ySize/20), xSize/10.0, ySize/10.0);
      line(xPos-xSize/7.0+xSize/10.0, yPos + (ySize/5)*i + ySize/10, xPos, yPos + (ySize/5)*i + ySize/10);
      strokeWeight(1);
      stroke(#292929);
      line(xPos, yPos + (ySize/5)*i + ySize/10, xPos + xSize, yPos + (ySize/5)*i + ySize/10);
      
      //Display text increments
      textAlign(CENTER,CENTER);
       
      
     
       String boxText = str(dataMax[0] - graphRange/5.0 * i - graphRange / 10.0).length()
       > 5 ?  str(dataMax[0]-graphRange/5.0 * i - graphRange / 10.0).substring(0,5) :  str(dataMax[0]-graphRange/5.0 * i - graphRange / 10.0);
      // println("range: " + graphRange);
      // println(boxText);
       textSize(13);
       fill(0,0,255);
       float ratio = ((xSize) / 13) / textWidth(boxText);
       textSize(abs(13 * ratio));
       if(graphRange!=0){
         text(boxText, xPos-xSize/7.0+xSize/20.0, yPos + (ySize/5)*i + ySize/10);  
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
   float getMaxVal(){
      return dataMax[0];
   }
    
   float getMinVal(){
     return dataMin[0]; 
   }
   
   float getMaxValTime(){
     return dataMax[1];
   }
   
   float getMinValTime(){
     return dataMin[1];
   }

   float getNewestData(){
    return data[getDataCircular(offset-1)]; 
   }
}
