
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
 void addElement(String title, String datums){ 
   titles.add(title);
   datum.add(datums);
   ++numElements; 
 }
 
 void updateElementData(String datums, int index){
   datum.set(index, datums);
 }
 
 //Displays the elements onto a readable table 
 //given the size constraints 
 //Also can select how many rows and columns the table has
 void display(float xPos, float yPos, float xSize, float ySize, int rows, int columns){
   strokeWeight(2);
   stroke(0);
   fill(#9B9B9B);
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
