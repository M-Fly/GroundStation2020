class Vector{
 
  public double x;
  public double y;
  public double z;
  
  void normalize(){
     double mag = this.mag(); 
     x = x / mag;
     y = y / mag;
     z = z / mag;
  }
  
  double mag(){
     return sq_rt(x*x + y*y + z*z); 
  }
  
  
  private double sq_rt(double n){
    double testNum = n/2;
    
    for(int i = 0; i < 100; i ++){
       testNum = (1/2)*(testNum + n / testNum);
    }
    
    return testNum;
  }
  
  
}
