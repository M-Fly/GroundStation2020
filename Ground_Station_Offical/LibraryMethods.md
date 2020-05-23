## Button

<ol>
<li><strong>constructor</strong></li>
  Button(float xPos, float yPos, float xSize, float ySize, color buttonColor, String buttonName)<br><br>
  xPos - the x position of the button<br>
  yPos - the y position of the button<br>
  xSize - the width of the button<br>
  ySize - the height of the button<br>
  buttonColor - the default color of the button<br>
  buttonName - the name that is displayed inside of the button<br>
  <br><br>
  <li><strong>void displayButton()</strong></li>
  <br>
  void displayButton() - displayButton commands the program to show the button visually on the canvas with the specified text, color, and dimensions stated in the constructor.
  
  <br><br>
  <li><strong>void clickListener()</strong></li>
  <br>
  void clickListener() - clickListener is what listens for the button to be clicked. If the mouse is both pressed and released on top of the button,
  then clickListener will trigger an internal mechanism, allowing the user to add code that runs once after the button is clicked. 
  
   <br><br>
  <li><strong>boolean eventTriggered()</strong></li>
  <br>
  boolean eventTriggered() - eventTriggered returns true when the button has been clicked. This function should only ever be called in a loop
  if the clickListener is called in the same loop. If this triggers something where clickListener is not called again,
  then there is a possibility of an infinite loop. 
</ol>

# dataPlotter

<ol>
<li><strong>constructor</strong></li>
</ol>
