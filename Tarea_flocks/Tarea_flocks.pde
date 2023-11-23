/**
 * Based on Flocking 
 * by Daniel Shiffman.  
 * 
 * An implementation of Craig Reynold's Boids program to simulate
 * the flocking behavior of birds. Each boid steers itself based on 
 * rules of avoidance, alignment, and coherence.
 * 
 * Click the mouse to add a new boid.
 */

Flock flock;// the flock system
PImage mountain;
PImage bird;
PImage field;
PImage reverse_bird_texture; // is a global variable because performance issues




void setup() {
  size(800, 540, P2D);
  frameRate(60);
  flock = new Flock();

  mountain = loadImage("mountain03.png");
  field = loadImage("field02.png");
  bird = loadImage("Bird04.png");
  
  reverse_bird_texture = getReversePImage( bird );

  // Add an initial set of boids into the system
  for (int i = 0; i < 30; i++) {
    flock.addBoid(new Boid(width/2,height/2, reverse_bird_texture));
  }
}

void draw() {
  background(20);
  image(field, 0, 0);
  flock.run();
}

// Add a new boid into the System
void mousePressed() {
  //flock.addBoid(new Boid(mouseX,mouseY));
  float r_scale = random(1.0,1.4);
  PVector s = new PVector(40*r_scale,45*r_scale);
  flock.addObstacle(new Obstacle(mouseX,mouseY,mountain, s));
}





PImage getReversePImage( PImage image ) {
    PImage reverse;
    reverse = createImage(image.width, image.height,ARGB );

    for( int i=0; i < image.width; i++ ){
      for(int j=0; j < image.height; j++){
        int xPixel, yPixel;
        xPixel = image.width - 1 - i;
        yPixel = j;
        reverse.pixels[yPixel*image.width+xPixel]=image.pixels[j*image.width+i] ;
      }
    }
    return reverse;
}

// The CollisionBox class. A rectangle

class CollisionBox{
  
  PVector origin;
  PVector dimension;
  PVector center;
  float rotation;
  
  CollisionBox(PVector new_origin, PVector new_dimension){
    
    if (new_origin != null && new_dimension != null){
      origin = new_origin; 
      dimension = new_dimension;  
      center = new PVector(origin.x + dimension.x,origin.y + dimension.y);
      rotation = 0.0;
    }
  
  }
  
  PVector get_center(){ return center;}
  PVector get_origin(){ return origin;}
  PVector get_dimension(){ return dimension;}

  void set_position(float x, float y){
    translate(x,y);
  }
  
  void set_rotation(float r){ rotation = r;}

  
  boolean is_colliding( CollisionBox other){
    
    PVector own_cpoint  = new PVector(origin.x + dimension.x, origin.y + dimension.y);
    PVector other_cpoint = new PVector(other.get_origin().x + other.get_dimension().x, other.get_origin().y+other.get_dimension().y);   
  
      return (origin.x < other_cpoint.x && 
          own_cpoint.x > other.get_origin().x &&
          origin.y < other_cpoint.y &&
          own_cpoint.y > other.get_origin().y );
  }

  // WARNING: the collision can rotate, but can't change position if a different vertex mapping is used in the parent object
  void render() {
    
    fill(255,0,255);
    stroke(255);
    
    pushMatrix();
    translate(origin.x-(dimension.x/2), origin.y-(dimension.y/2));
    rotate(rotation);
    beginShape();
    vertex(0, 0);
    vertex(0, dimension.y);
    vertex(dimension.x, dimension.y);
    vertex(dimension.x, 0);
    endShape(CLOSE);
    popMatrix();
  } 
  

}//end of Collision class

// The obstacle class

class Obstacle{
  PVector position;
  PVector size;  
  PVector fill_color;
  PVector default_color;
  PImage texture;
  CollisionBox collision;
  
  Obstacle(float x, float y, PImage img, PVector size){
    position = new PVector(x,y);
    this.size = size;    
    fill_color = new PVector(100,100,100);    
    collision = new CollisionBox(position,size);
    default_color = new PVector(255,0,255);
    texture = img;
  
  } 
  
  CollisionBox get_collision_box(){return collision;}
  PVector get_position(){return position;}
  
  void draw_collision_box(){
    collision.render();
  }
  
  PVector get_size(){
    return size;
  }
  
  boolean is_colliding(Obstacle other){
   return collision.is_colliding(other.get_collision_box());
  }
  
  void change_color(PVector new_color){
  
    if(fill_color != null && new_color != null){
      fill_color = new_color;
    }
  }

  
  void render() {       
    pushMatrix();    
    // translate to the screen mouse position on click
    translate(position.x-(size.x/2), position.y-(size.y/2));

    noFill();    
    noStroke();  
    textureMode(NORMAL); 
    beginShape();
    texture(texture);
    vertex(0, 0, 0, 0);
    vertex(0, size.y, 1, 0);
    vertex(size.x, size.y, 1, 1);
    vertex(size.x, 0, 0, 1);
    endShape(CLOSE);
    popMatrix();
    //draw_collision_box();
  }  
}//end of class Obstacle


// The Boid class

class Boid {

  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector size;
  PImage texture;
  CollisionBox collision;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  float theta;       // Direction


    Boid(float x, float y, PImage img) {
    acceleration = new PVector(0, 0);

    // This is a new PVector method not yet implemented in JS
    // velocity = PVector.random2D();

    // Leaving the code temporarily this way so that this example runs in JS
    float angle = random(PI);
    velocity = new PVector(cos(angle)*1.0, sin(angle)*1.0);

    position = new PVector(x, y);
    r = 4.0;
    maxspeed = 1.35;
    maxforce = 0.04;
    size = new PVector(r*r,r*r); 
    collision = new CollisionBox(position, new PVector(size.x,size.y));
    texture = img;

  }
  
  boolean is_colliding(Obstacle o){
  
    return collision.is_colliding(o.get_collision_box());
  
  }

  void run(ArrayList<Boid> boids, ArrayList<Obstacle> obs) {
    flock(boids, obs);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }  
 

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids, ArrayList<Obstacle> obs) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    PVector avo = avoidance(obs);  // Avoidance
    // Arbitrarily weight these forces
    sep.mult(1.575);
    ali.mult(1.125);
    coh.mult(1.0);
    avo.mult(5.47);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
    applyForce(avo);
  }

  // Method to update position
  void update() {
    if (velocity.heading() <= 0.005){velocity.mult(1.05);}
    // Update velocity 
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset acceleration to 0 each cycle
    acceleration.mult(0.15);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);    
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }
  
  PVector no_seek(PVector target) {    
    PVector desired = PVector.sub(position, target);  // A vector pointing from the position to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed); 
     
    // Steering = Desired minus Velocity   
    PVector steer = PVector.sub(desired, velocity);     
    velocity.mult(1.05);
    steer.limit(maxforce*0.77);  // Limit to maximum steering force
    return steer;
  }
  
  void updateDirection(){
    //translate(position.x+size.x/2, position.y+size.y/2);
    translate(position.x, position.y);
    // rotated in the direction of velocity
    theta = velocity.heading() + radians(90); 
    rotate(theta);
  
  } 

  
  void drawObjectShape(){ 
 
    //fill(255);
    noFill();
    //stroke(255);
    noStroke();
    // translate must be in a pushMatrix block 
    pushMatrix();
    updateDirection();
    //update collision rotation
    collision.set_rotation(theta);   

    textureMode(NORMAL); 
    beginShape();
    texture(texture);
    vertex(0, 0, 0, 0);
    vertex(0, size.y, 1, 0);
    vertex(size.x, size.y, 1, 1);
    vertex(size.x, 0, 0, 1);
    endShape(CLOSE);
    //collision.render();
    popMatrix();

  }

  void render() {
      drawObjectShape();
  }

  // Wraparound
  void borders() {
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 30.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 45.0f;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
 
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50.0f;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } 
    else {
      return new PVector(0, 0);
    }
  }
  
  
  // Avoidance
  
  PVector avoidance (ArrayList<Obstacle> obs) {
   
    if (obs.size() == 0){ return new PVector(0,0);}
    float neighbordist;
    float d;
   

    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Obstacle other : obs) { 
      neighbordist = other.get_size().x*1.15; //repulsion radio
      //stroke(255);
      //circle(other.get_position().x,other.get_position().y,neighbordist);
      d = PVector.dist(position, other.get_position() );
      
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position 
        
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return no_seek(sum);  // Steer away the position
    } 
    else {
      return new PVector(0, 0);
    }
  }
  
}//end of class boid


//
  



// The Flock (a list of Boid objects)

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  ArrayList<Obstacle> obstacles;

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
    obstacles = new ArrayList<Obstacle>();
  }

  void run() {
    for (Obstacle o : obstacles){   
      o.render();   
      //o.draw_collision_box();
    }
    
    for (Boid b : boids) {
      b.run(boids,obstacles);  // Passing the entire list of boids to each boid individually
    }
    
    
  }

  void addBoid(Boid b) {
    boids.add(b);
  } 
  
  void addObstacle(Obstacle obs){
    int index = -1;
   
    for(Obstacle o : obstacles){
      if (o.is_colliding(obs)){          
        index = obstacles.indexOf(o);
        break;
      }          
    }   
    
    if (index < 0){ obstacles.add(obs); }else{obstacles.remove(index);}    
  }  

}
