double Map(double value, double range1_begin, double range1_end, double range2_begin, double range2_end){
 
    value -= range1_begin; 
    
    value /= range1_end - range1_begin; 
    
    value *= range2_end - range2_begin; 
    
    value += range2_begin; 
    
    return value; 
  
}
