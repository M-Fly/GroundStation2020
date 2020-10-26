import org.apache.commons.math3.analysis.function.*;

//This class is for 
class Vector{
 
  public double x;
  public double y;
  public double z;
  
  Vector(double x, double y, double z){
    this.x=x; 
    this.y=y; 
    this.z=z; 
  }
  
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
  
  double dot(Vector lhs){
   return (x * lhs.x) + (y * lhs.x) + (z * lhs.z);  
  }
}
