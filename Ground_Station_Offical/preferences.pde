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
  boolean saveGPSDATA(){
   return parsedData[0].toUpperCase().trim().equals("TRUE");
  }
  
  //Should the ALT DATA be saved 
  boolean saveALTDATA(){
   return parsedData[1].toUpperCase().trim().equals("TRUE");
  }
  
  //Should the DROP DATA be saved 
  boolean saveDROPDATA(){
   return parsedData[2].toUpperCase().trim().equals("TRUE");
  }
  
  //Should the FLIGHT DATA be saved 
  boolean saveFLIGHTDATA(){
   return parsedData[3].toUpperCase().trim().equals("TRUE");
  }
  
  float GPSTailLength(){
    return float(parsedData[4]);
  }
  
  float altGraphDataPoints(){
   return float(parsedData[5]); 
  }
  
  boolean customTablets(){
   return parsedData[6].toUpperCase().trim().equals("TRUE"); 
  }
  
  float ALTX(){
    return float(parsedData[7]);    
  }

  float ALTY(){
    return float(parsedData[8]);    
  }
  
  float ALTXSIZE(){
    return float(parsedData[9]);    
  }
  
  float ALTYSIZE(){
    return float(parsedData[10]);    
  }
  
  float GPSX(){
    return float(parsedData[11]);    
  }

  float GPSY(){
    return float(parsedData[12]);    
  }
  
  float GPSXSIZE(){
    return float(parsedData[13]);    
  }
   
  float GPSYSIZE(){
    return float(parsedData[14]);    
  }

  float FLIGHTX(){
    return float(parsedData[15]);    
  }

  float FLIGHTY(){
    return float(parsedData[16]);    
  }

  float FLIGHTXSIZE(){
    return float(parsedData[17]);    
  }
  
  float FLIGHTYSIZE(){
    return float(parsedData[18]);    
  }

  float DROPX(){
    return float(parsedData[19]);    
  }

 float DROPY(){
    return float(parsedData[20]);    
  }

 float DROPXSIZE(){
    return float(parsedData[21]);    
 }
 
  
 float DROPYSIZE(){
    return float(parsedData[22]);    
  }

 String[] parsed(){
  return parsedData;  
 }

   float LATSTART(){
   return float(parsedData[23]);  
 }
 
  float LATEND(){
   return float(parsedData[24]);  
 }
 
  float LONGSTART(){
   return float(parsedData[25]);  
 }
 
  float LONGEND(){
   return float(parsedData[26]);  
 }

};
