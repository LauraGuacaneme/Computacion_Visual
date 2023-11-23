/**
 * Based on Recursive 2D Tree
 * by Daniel Shiffman. 
 *
 */
 
float theta;
int initial_line_length = 50;
int model = 0;
PGraphics canva_b4; 


int grid = 100;
PVector bpos = new PVector();
float bsize = grid;
boolean input1, input2, input3, input4;
float cameraRotateX;
float cameraRotateY;
float cameraRotateZ;
float cameraSpeed;
int gridCount = 50;
PVector pos, speed;
float accelMag;



void mouseMoved() {
  cameraRotateX += (mouseX - pmouseX) * cameraSpeed;
  cameraRotateY += (pmouseY - mouseY) * cameraSpeed;
 
  //cameraRotateY = constrain(cameraRotateY, -HALF_PI, 0);
  cameraRotateY = constrain(cameraRotateY, -PI/3, 0);
}

void mouseClicked() {
  switch(model){
    case 0:
      model = 1;
      break;
    case 1:
      model = 2;
      break;
    case 2:
      model = 3;
      break;
    case 3:
      model = 0;
      break;
  } 
}

void show_model(int h)
{
  switch(model){
    case 0:
      perspective();
      pushMatrix();
      branch1(h);
      popMatrix();
      break;
    case 1:
      perspective();
      pushMatrix();
      branch2(h);
      popMatrix();
      break;
    case 2:  
      perspective();
      pushMatrix();
      branch3(h);
      popMatrix();
      break;
    case 3:
        //ortho(-width/2, width/2, -height/2, height,0,1000);
        float n = 180;
        float a = 30;
        float r = 0.6; //PERFORMANCE WARNING: not set above 0.65!!  
        canva_b4.beginDraw();
        canva_b4.background(20,20,180);
        canva_b4.strokeWeight(2);
        canva_b4.stroke(255);
        canva_b4.translate(width/2,height);
        canva_b4.line(0,0,0,-n);
        canva_b4.translate(0,-n);  
        pushMatrix();      
        branch4(n,a,r);      
        popMatrix();
        canva_b4.endDraw();
        image(canva_b4, (-width/2)+200, -width/2,width/2, height/2);
      break;
  }   

}

void drawGrid(int count) {
  translate(-pos.x, 0, -pos.y);
  stroke(100);
  float size = (count -1) * bsize*2;
  for (int i = 0; i < count; i++) {
    float pos = map(i, 0, count-1, -0.5 * size, 0.5 * size);
    line(pos, 0, -size/2, pos, 0, size/2);
    line(-size/2, 0, pos, size/2, 0, pos);
  }
  stroke(255);
}

void setup() {
  size(840,580,P3D);
  cameraSpeed = TWO_PI / width;
  cameraRotateY = -PI/6;
  pos = new PVector();
  speed = new PVector();
  accelMag = 2; 
  canva_b4 = createGraphics(width, height, P2D);

}

void updateCameraRotation(){
  //rotateX(cameraRotateY);
  rotateY(cameraRotateX);


}

void getCameraCenter(){
  //camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  //camera(0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height, 0, 0, 1, 0);
  //translate(width/2, height/10);
  translate(width/2, height-10, -120);
  updateCameraRotation();
  
}

void draw() {
  frameRate(30);
  lights(); 
  
  //camera initial position
  getCameraCenter();
  background(125); 

  show_model(50);
  drawGrid(gridCount);
}

void branch1(float h) {
  
  theta = radians(30);
  stroke(255);
  line(0,0,0,-initial_line_length);  
  // Move to the end of that line
  translate(0,-initial_line_length);
  // Each branch will be 2/3rds the size of the previous one
  h *= 0.65; 
  
  // All recursive functions must have an exit condition!!!!

  if (h > 1.5) {    
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    rotateX(theta/2);   // Rotate by theta  
    line(0, 0, 0, 0,-h,0);  // Draw the branch  
    translate(0, -h); 
    rotateY(theta);

    branch1(h);       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
    
    // Repeat the same thing, only branch off to the "left" this time!    
    pushMatrix();
    rotateX(-theta*0.9);
    line(0, 0, 0, 0,-h,0);
    translate(0, -h);      
    branch1(h);
    popMatrix();
  }
}

//spike brush
// 
void branch2(float h){
  theta = radians(27.5);
  stroke(255);
  line(0,0,0,-initial_line_length);  
  // Move to the end of that line
  translate(0,-initial_line_length);

  h *= 0.65; 
  
  // All recursive functions must have an exit condition!!!!

  if (h > 1.5) {    
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    rotateX(theta);   // Rotate by theta  
    line(0, 0, 0, 0,-h,0);  // Draw the branch  
    rotateY(theta*h);
    stroke(0);
    line(0, 0, 0, -h/2,-h/2,0);  // Draw the spike  
    translate(0, -h); // Move to the end of the branch
    branch2(h);       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
    
    // Repeat the same thing, only branch off to the "left" this time!    
    pushMatrix();
    rotateX(-theta);
    line(0, 0, 0, 0,-h,0);
    translate(0, -h);      
    branch2(h);
    popMatrix();
  }

}

//long branches
//

void branch3(float h){ 
  theta = radians(18);
  stroke(255);
  line(0,0,0,-initial_line_length);  
  // Move to the end of that line
  translate(0,-initial_line_length);

  h *= 0.65; 

  // All recursive functions must have an exit condition!!!!
  if (h > 1.5) {
    
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    //rotateY(theta);   // Rotate by theta  
    //line(0, 0, 0, 0, h,0);  // Draw the branch  
    rotateZ(-theta/4);
    rotateY(-(theta/2)*h);
    branch3(h);       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
    
    // Repeat the same thing, only branch off to the "left" this time!    
    pushMatrix();
    rotateZ(-theta);
    line(0, 0, 0, 0,-h,0);    
    translate(0, -h);    
    branch3(h);
    popMatrix();
  } 
}

void branch4(float h,float a, float r) {    
  theta = radians(a);
  h *= r;
  
  // All recursive functions must have an exit condition!!!!
  if (h > 2) {
    canva_b4.pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    canva_b4.rotate(theta);   // Rotate by theta
    canva_b4.line(0, 0, 0, -h);  // Draw the branch
    canva_b4.translate(0, -h); // Move to the end of the branch 
    branch4(h,a,r);      // Ok, now call myself to draw two new branches!!
    canva_b4.popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
    
    //Repeat the same thing, only branch off to the "left" this time!
    canva_b4.pushMatrix();
    canva_b4.rotate(-theta);
    canva_b4.line(0, 0, 0, -h);    
    canva_b4.translate(0, -h);
    canva_b4.line(0, 0, 0, -h);
    canva_b4.translate(0, -h);
    branch4(h,a,r);
    canva_b4.popMatrix();
  } 
  
}
