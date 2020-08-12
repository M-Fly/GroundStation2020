import org.apache.commons.math3.analysis.function.*;

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
     return Math.sqrt(x*x + y*y + z*z); 
  }
  
  void mult(double n){
    x*=n;
    y*=n;
    z*=n;
  }
}
