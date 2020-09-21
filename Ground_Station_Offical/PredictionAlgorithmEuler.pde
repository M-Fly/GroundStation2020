 
 //The drop predictor for determining where the balls will drop from the plane
 
 class PredictionAlgorithmEuler {
   
        // Time Constant of Integration
        private double dt = (double)0.0001;       // [ s ]

        // Gravitational Constant
        private double g = (double)9.807;       // [ m/s^2 ]

        // Air Density
        private double rho =(double) 1.225;     // [ kg/m^2 ]

        // Payload Constants
        private double payload_mass = 1;    // [ kg ]
        private double payload_area = (double)0.1;  // [ m^2 ]
        private double payload_cdrg = (double)0.00005;  // Drag Coefficient
   
   
       public PredictionAlgorithmEuler(){}
   
   
         // PredictionIntegrationFunction
        //
        // Runs an Euler integration method to estimate the new position of the payload when the z-value of the position Vector3 is less than 0
        // ***Units must be in SI units for output parameters to make sense***
        // Does not modify the original inputted Vector3 position and velocity
        //
        // REQUIRES:
        //      PVector pos:        Initial position Vector of the payload in m/s. Integration stops when pos.z <= 0
        //      PVector vel:        Initial velocity vector of the payload in m/s
        //      PVector windVel:    Wind velocity vector (in terms of where the wind is blowing to) in m/s
        // MODIFIES: Nothing
        // EFFECTS:  Nothing
        
        
        public Vector PredictionIntegrationFunction(Vector pos, Vector vel, Vector windVel){ //<>//
          
            //Creates a clone of pos to ultimately return the new position at z=0 without modifying the original
            Vector posOut = pos; //<>//
            Vector velOut = vel; //<>//
            
             // Variable to hold the normal velocity during integration
            double velRelMag; //<>//


            while (posOut.z > 0)
            {
                // Find the relative velocity between the payload and the air
               // Vector velRel = velOut.sub(windVel);
               Vector velRel = velOut;
                //Find the magnitude of the velocity vector
                velRelMag = velRel.mag();
                
                // Find the new position based on the current velocity and given integration timestep
                posOut.x = posOut.x + velOut.x * dt;
                posOut.y = posOut.y + velOut.y * dt;
                posOut.z = posOut.z + velOut.z * dt;
                
                //Find the new velocity based on the acceleration on particle and the given integration timestep
                velOut.x = velOut.x - 0.5 * rho * velRelMag * payload_area * payload_cdrg * velRel.x * dt / payload_mass;
                velOut.y = velOut.y - 0.5 * rho * velRelMag * payload_area * payload_cdrg * velRel.y * dt / payload_mass;
                velOut.z = velOut.z - 0.5 * rho * velRelMag * payload_area * payload_cdrg * velRel.z * dt / payload_mass - g * dt;

            }
            
            //Return the final position vector of the payload
            return posOut;
      }
   
 }
