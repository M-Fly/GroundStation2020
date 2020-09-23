import processing.serial.*;

class DataStream {

  //The serial stream
  private Serial serialPort; 
  private String message;
  private String AMESSAGE, BMESSAGE, CMESSAGE, DMESSAGE;

  DataStream() {
    AMESSAGE = ""; 
    BMESSAGE = ""; 
    CMESSAGE = ""; 
    DMESSAGE = "";
  }
  //This is what sets the serial port for use
  //No other functions should be called without setting the serial port
  void setPort(Serial port) {
    serialPort = port;
  }

  void readSerial() {
    message = serialPort.readStringUntil(';');
    if(message!=null){
    // println("MESSAGE" + message + "END MESSAGE");
     //println("CHAR AT 0: "+message.charAt(0));
     //println("CHAR AT 1: "+message.charAt(1)); 
       //for(int i = 0; i < message.length(); i++){
      //   print("C("+i+")"+message.charAt(i)+" : ");
    //   }
       //println(); 
    }
    if (message!=null) {
      if (message.charAt(2) == 'A')
        AMESSAGE = message;
      else if (message.charAt(2) == 'B')
        BMESSAGE = message; 
      else if (message.charAt(2) == 'C')
        CMESSAGE = message; 
      else if (message.charAt(2) == 'D')
        DMESSAGE = message;
    }
  }
  void readSampleData(String sampleData) {
    message = sampleData;  
    if (message.charAt(0) == 'A')
      AMESSAGE = message;
    else if (message.charAt(0) == 'B')
      BMESSAGE = message; 
    else if (message.charAt(0) == 'C')
      CMESSAGE = message; 
    else if (message.charAt(0) == 'D')
      DMESSAGE = message;
  }

  //Return the messages as a string
  String getAMESSAGE() {
    return AMESSAGE;
  }

  String getBMESSAGE() {
    return BMESSAGE;
  }

  String getCMESSAGE() {
    return CMESSAGE;
  }

  String getDMESSAGE() {
    return DMESSAGE;
  }

  //Return the messages as a parsed array
  String[] getParsedAMESSAGE() {
    return split(AMESSAGE, ',');
  }

  String[] getParsedBMESSAGE() {
    //println("BMESSAGE: " + BMESSAGE); 
    return split(BMESSAGE, ',');
  }

  String[] getParsedCMESSAGE() {
    return split(CMESSAGE, ',');
  }

  String[] getParsedDMESSAGE() {
    return split(DMESSAGE, ',');
  }
};
