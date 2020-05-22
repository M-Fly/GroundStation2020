

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
  Dropdown(float xPos, float yPos, float xSize, float ySize, color col, String...buttonText){
   this.xPos = xPos; 
   this.yPos = yPos; 
   this.xSize = xSize; 
   this.ySize = ySize;
   this.dropdownName = buttonText[0]; 
   dropdown = new Button(xPos, yPos, xSize, ySize, color(211,211,211),buttonText[0] + "↓"); 
   selectedItem = "";
  }
  
  void updateDropdownItems(String[] items){
     this.items = items; 
     if(menuItems.size() > 0)
       menuItems.clear();
       for(int i = 0; i < items.length; i++){
         menuItems.add(new Button(xPos, yPos + ySize * i, xSize, ySize, color(211, 211, 211), items[i]));
       }  
  }
  
  void displayDropdown(){
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
  
  String getSelectedItem(){
   return selectedItem;  
  }
  
}
