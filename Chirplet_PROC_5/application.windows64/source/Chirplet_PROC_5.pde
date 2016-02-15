/* Processing code to plot any function like a Chirp function and send data to 3d plotter to plot the function in lightspace and time*/

import org.apache.commons.math3.*;
import processing.opengl.*;

//Variable definitions
float[] t = new float[1201];
float sum = 0;

float f0=0;
float f1=250;
float t1=1;
float beta = (f1-f0)/t1;

Complex[] sig = new Complex[1201];
int N = 1200;
int[] N_arr = new int[1201];
int n_sum = 0;
float a = 2.5;
float[] w = new float[1201];
float[] x = new float[1201];
float[] y = new float[1201];
float[] r = new float[1201];
float[] theta = new float[1201];
float px,pt,py,ppx,ppt,ppy;
int led_px, led_r;
float R_x = 0.0;
float T_x = 0.0;
boolean dirT_x = false;
boolean dirR_x = false;

color rectColor, rectHighlight;
color currentColor;
boolean rectOver = false;
boolean rectOver1 = false;
boolean rectOver2 = false;
boolean rectOver3 = false;
boolean rectOver4 = false;
boolean rectOver5 = false;
boolean rectOver6 = false;
boolean rectOver7 = false;
boolean rectOver8 = false;


float[] new_x = new float[1201];
float[] new_y = new float[1201];

boolean start_lightarr = false;
boolean stop_lightarr = false;
boolean num_lights_input = false;
boolean length_lights_input = false;
boolean length_plotter_input = false;
boolean rpm_input = false;
boolean lin_speed_input = false;




float zoom_val = 3;

int timer;

int rectX, rectY,rectX1,rectY1,rectX2,rectY2,rectX3,rectY3,rectX4,rectY4,rectX5,rectY5,rectX6,rectY6,rectX7, rectY7,rectX8, rectY8;      // Position of square button
int rectSize = 90;     // Diameter of rect

String input_str = "8";
String input_str1 = "57";
String input_str2 = "5.11";
String input_str3 = "120000";
String input_str4 = "0.057";

int num_lights = 8;
float length_plotter = 57;
float length_lights = 5.11;
float rpm = 120000;
float lin_speed = 0.057;


  int ctr = 0;
  
//Setup pre-processing of data and display environment

void setup() {
  size(1000,1500,OPENGL);
    surface.setResizable(true);

  t[0] = 0;
  background(255,255,255);

//Function definition - Gaussian Chirplet transform
  for(int i = 0;  i<1201; i++){
     t[i] = sum;
     sig[i] = sig[i].valueOf(0,(2*PI * ( 0.5* beta * pow(t[i],2) + f0*t[i])));
     sig[i] = sig[i].exp();
     N_arr[i] = n_sum-N/2;
     w[i] = exp(-0.5 * pow((a*N_arr[i]/(N/2)),2));
     x[i] = (float)sig[i].getReal() * w[i];
     y[i] = (float)sig[i].getImaginary()*w[i];
     r[i] = sqrt(pow(x[i],2)+pow(y[i],2));
     theta[i] = atan(y[i]/x[i]);
     n_sum = n_sum+1;
     sum = sum + 0.001;
     
  }
  
  //Color of buttons
  rectColor = color(51);
  rectHighlight = color(143,178,153);


}



void draw() {
background(0); // set background to black
pushMatrix();
  translate(width/2,height/3,-height/3);
  scale(1,-1,1); // so Y is up, which makes more sense in plotting
  rotateY(radians(frameCount));
  //rotateY(15*PI/8);

  noFill();
  strokeWeight(1);
  box((width/4)*zoom_val,height/3*zoom_val*(2*length_lights/length_plotter),height/3*zoom_val*(2*length_lights/length_plotter));
  fill(255);
  //textSize(32);
  //text("(0,0,0)", width/2-750,width/2-750,width/2-750);
  if(!start_lightarr){
  //Plot 3d function
   for(int j = 0; j<1201; j++){
   px= map(x[j],min(x),max(x),-((height/3)*(2*length_lights/length_plotter)*zoom_val)/2,((height/3)*(2*length_lights/length_plotter)*zoom_val)/2);
   pt= map(t[j],min(t),max(t),-1*((width/4)*zoom_val)/2,((width/4)*zoom_val)/2);
   py= map(y[j],min(y),max(y),-((height/3)*(2*length_lights/length_plotter)*zoom_val)/2,((height/3)*(2*length_lights/length_plotter)*zoom_val)/2);
   line(ppt, ppx, ppy, pt, px, py);
   stroke(255);
   
   ppx=px;
   ppt=pt;
   ppy=py;



  }}




//Next is code to create the light array
if(start_lightarr){
  
    rotateX(R_x);
  translate(-1*((width/4)*zoom_val)/2 +T_x,-(height/3*zoom_val*(2*length_lights/length_plotter))/4,0); 
  fill(0,0,255);
  //translate(0,125*(2*length_lights/length_plotter)*zoom_val);
  strokeWeight(1);
 box(15,(height/3*zoom_val*(2*length_lights/length_plotter))/2, (height/3*zoom_val*(2*length_lights/length_plotter))/10);
  fill(0, 0, 0);
  translate(15,0);
  rotateY(PI/2);
  led_r = (int)map(r[(ctr)*2],min(r),max(r),1,8);

  for(int k = 0; k < num_lights; k++){
   if(k+1 == led_r){
       fill(255,255,0);
   append(new_x,(k*250/num_lights+125/num_lights-125)*(2*length_lights/length_plotter)*zoom_val);}
  ellipse(0,(k*250/num_lights+125/num_lights-125)*(2*length_lights/length_plotter)*zoom_val,(15/sqrt(num_lights/8))*(2*length_lights/length_plotter)*zoom_val,(15/sqrt(num_lights/8))*(2*length_lights/length_plotter)*zoom_val);
  }
   
  R_x +=  (4000*PI/60.0)*(rpm/120000.0);
   if(dirT_x){
  T_x -= ((50/60.0)* (lin_speed/0.057)) * zoom_val;  
  ctr--;  
}
  else{
  T_x += ((50/60.0)* (lin_speed/0.057)) * zoom_val;
ctr++;}
  
  
  if(T_x >= (width/4)*zoom_val){
    dirT_x = true;
  }
  else if(T_x <= 1){
    dirT_x = false;}    

}


 popMatrix();


  
 //UI stuff 
  update();
 //START BUTTON 
  if (rectOver || start_lightarr) {
    fill(rectHighlight);
  } else {
    fill(rectColor);
  }
  stroke(255);
  rect(rectX, rectY, rectSize, rectSize/2);
  rectX = width/3-rectSize-10;
  rectY = 2*height/3-rectSize/2;
  fill(255);
  textSize(22);
  text("START", width/3-7*rectSize/8-10,2*height/3-rectSize/8);
 
 //STOP BUTTON 
  if (rectOver1 || stop_lightarr) {
    fill(rectHighlight);
  } else {
    fill(rectColor);
  }
  stroke(255);
  rect(rectX1, rectY1, rectSize, rectSize/2);
  rectX1 = width/3-10+rectSize;
  rectY1 = 2*height/3-rectSize/2;
  fill(255);
  textSize(22);
  text("STOP", width/3+9*rectSize/8-10,2*height/3-rectSize/8); 
  
  //NUMBER OF LIGHTS INPUT BUTTON 
  if (rectOver2 || num_lights_input) {
    fill(rectHighlight);
  } else {
    fill(rectColor);
  }
  stroke(255);
  rect(rectX2, rectY2, 4*rectSize, rectSize/2);
  rectX2 = width/3-rectSize-10;
  rectY2 = 2*height/3+rectSize/2;
  fill(255);
  textSize(22);
  if(num_lights_input){
    text(input_str, width/3-7*rectSize/8-10,2*height/3+7*rectSize/8); }
  else{
  text("NUMBER OF LIGHTS: " + input_str, width/3-7*rectSize/8-10,2*height/3+7*rectSize/8); }

//LENGTH OF PLOTTER 
  if (rectOver3 || length_plotter_input) {
    fill(rectHighlight);
  } else {
    fill(rectColor);
  }
  stroke(255);
  rect(rectX3, rectY3, 4*rectSize, rectSize/2);
  rectX3 = width/3-rectSize-10;
  rectY3 = 2*height/3+3*rectSize/2;
  fill(255);
  textSize(22);
  if(length_plotter_input){
    text(input_str1 + " cm", width/3-7*rectSize/8-10,2*height/3+15*rectSize/8); }
  else{
  text("LENGTH OF PLOTTER: " + input_str1 + " cm", width/3-7*rectSize/8-10,2*height/3+15*rectSize/8); }

//LENGTH OF LIGHTS
  if (rectOver4 || length_lights_input) {
    fill(rectHighlight);
  } else {
    fill(rectColor);
  }
  stroke(255);
  rect(rectX4, rectY4, 4*rectSize, rectSize/2);
  rectX4 = width/3-rectSize-10;
  rectY4 = 2*height/3+5*rectSize/2;
  fill(255);
  textSize(22);
  if(length_lights_input){
    text(input_str2 + " cm", width/3-7*rectSize/8-10,2*height/3+23*rectSize/8); }
  else{
  text("LENGTH OF LIGHTS: " + input_str2 + " cm", width/3-7*rectSize/8-10,2*height/3+23*rectSize/8); }
  
  //RPM
  if (rectOver5 || rpm_input) {
    fill(rectHighlight);
  } else {
    fill(rectColor);
  }
  stroke(255);
  rect(rectX5, rectY5, 4*rectSize, rectSize/2);
  rectX5 = width/3-rectSize-10;
  rectY5 = 2*height/3+7*rectSize/2;
  fill(255);
  textSize(22);
  if(rpm_input){
    text(input_str3 , width/3-7*rectSize/8-10,2*height/3+31*rectSize/8); }
  else{
  text("RPM: " + input_str3, width/3-7*rectSize/8-10,2*height/3+31*rectSize/8); }
  
   //LINEAR SPEED
  if (rectOver6 || lin_speed_input) {
    fill(rectHighlight);
  } else {
    fill(rectColor);
  }
  stroke(255);
  rect(rectX6, rectY6, 4*rectSize, rectSize/2);
  rectX6 = width/3-rectSize-10;
  rectY6 = 2*height/3+9*rectSize/2;
  fill(255);
  textSize(22);
  if(lin_speed_input){
    text(input_str4 + "m/s", width/3-7*rectSize/8-10,2*height/3+39*rectSize/8); }
  else{
  text("LINEAR SPEED: " + input_str4 + "m/s", width/3-7*rectSize/8-10,2*height/3+39*rectSize/8); }
  
   //ZOOM IN BUTTON 
  if (rectOver7 ) {
    fill(rectHighlight);
  } else {
    fill(rectColor);
  }
  stroke(255);
  rect(rectX7, rectY7, 1.5*rectSize, rectSize/2);
  rectX7 = width/3-10+5*rectSize;
  rectY7 = 2*height/3+3*rectSize/2;
  fill(255);
  textSize(22);
  text("ZOOM IN", width/3+9*rectSize/8-10+4*rectSize,2*height/3+15*rectSize/8); 
  
   //ZOOM OUT BUTTON 
  if (rectOver8) {
    fill(rectHighlight);
  } else {
    fill(rectColor);
  }
  stroke(255);
  rect(rectX8, rectY8, 1.5*rectSize, rectSize/2);
  rectX8 = width/3-10+5*rectSize;
  rectY8 = 2*height/3+5*rectSize/2;
  fill(255);
  textSize(22);
  text("ZOOM OUT", width/3+9*rectSize/8-10+4*rectSize,2*height/3+23*rectSize/8); 
  
  //MAP TO LED
  
  

  
}


void update() {
 if ( overRect(rectX, rectY, rectSize, rectSize/2) ) {
    rectOver = true;
  } else {
     rectOver = false;
  }
  if ( overRect(rectX1, rectY1, rectSize, rectSize/2) ) {
    rectOver1 = true;
  } else {
     rectOver1 = false;
  } 
  if ( overRect(rectX2, rectY2, 4*rectSize, rectSize/2) ) {
    rectOver2 = true;
  } else {
     rectOver2 = false;
  } 
  
  if ( overRect(rectX3, rectY3, 4*rectSize, rectSize/2) ) {
    rectOver3 = true;
  } else {
     rectOver3 = false;
  } 
  if ( overRect(rectX4, rectY4, 4*rectSize, rectSize/2) ) {
    rectOver4 = true;
  } else {
     rectOver4 = false;
  } 
    if ( overRect(rectX5, rectY5, 4*rectSize, rectSize/2) ) {
    rectOver5 = true;
  } else {
     rectOver5 = false;
  } 
   if ( overRect(rectX6, rectY6, 4*rectSize, rectSize/2) ) {
    rectOver6 = true;
  } else {
     rectOver6 = false;
  } 
  
   if ( overRect(rectX7, rectY7, 4*rectSize, rectSize/2) ) {
    rectOver7 = true;
  } else {
     rectOver7 = false;
  } 
  
   if ( overRect(rectX8, rectY8, 4*rectSize, rectSize/2) ) {
    rectOver8 = true;
  } else {
     rectOver8 = false;
  } 
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void mousePressed() {

  if (rectOver) {
    start_lightarr = true;
  }
  if(rectOver1){
    start_lightarr = false;
    stop_lightarr = true;
  }
  if(rectOver2){
    num_lights_input = true;
  }
  if(rectOver3){
    length_plotter_input = true;
  }
  if(rectOver4){
    length_lights_input = true;
  }
  if(rectOver5){
    rpm_input = true;
  }
    if(rectOver6){
    lin_speed_input = true;
  }
      if(rectOver7){
     zoom_val += 0.5;
  }
      if(rectOver8){
    zoom_val -= 0.5;    
  }
}


void keyPressed(){
  if(num_lights_input){
     if (keyCode == BACKSPACE) {
    if (input_str.length() > 0) {
       input_str = input_str.substring(0, input_str.length()-1);
    }
  } else if (keyCode == DELETE) {
    input_str = "";
  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT && (keyCode >= '0' && keyCode <= '9')) {
    input_str = input_str + key;
  }
  else if(keyCode == ENTER) {
    num_lights = int(input_str);
    num_lights_input = false;
  }
  }
  
   if(length_plotter_input){
     if (keyCode == BACKSPACE) {
    if (input_str1.length() > 0) {
       input_str1 = input_str1.substring(0, input_str1.length()-1);
    }
  } else if (keyCode == DELETE) {
    input_str1 = "";
  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT && ((keyCode >= '0' && keyCode <= '9') || keyCode == '.') ) {
    input_str1 = input_str1 + key;
  }
  else if(keyCode == ENTER) {
    length_plotter = float(input_str1);
    length_plotter_input = false;
  }
  }
  
  
   if(length_lights_input){
     if (keyCode == BACKSPACE) {
    if (input_str2.length() > 0) {
       input_str2 = input_str2.substring(0, input_str2.length()-1);
    }
  } else if (keyCode == DELETE) {
    input_str2 = "";
  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT && ((keyCode >= '0' && keyCode <= '9') || keyCode == '.') ) {
    input_str2 = input_str2 + key;
  }
  else if(keyCode == ENTER) {
    length_lights = float(input_str2);
    length_lights_input = false;
  }
  }
  
  
 if(rpm_input){
     if (keyCode == BACKSPACE) {
    if (input_str3.length() > 0) {
       input_str3 = input_str3.substring(0, input_str3.length()-1);
    }
  } else if (keyCode == DELETE) {
    input_str3 = "";
  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT && ((keyCode >= '0' && keyCode <= '9') || keyCode == '.') ) {
    input_str3 = input_str3 + key;
  }
  else if(keyCode == ENTER) {
    rpm = float(input_str3);
    rpm_input = false;
  }
  }
  
   if(lin_speed_input){
     if (keyCode == BACKSPACE) {
    if (input_str4.length() > 0) {
       input_str4 = input_str4.substring(0, input_str4.length()-1);
    }
  } else if (keyCode == DELETE) {
    input_str4 = "";
  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT && ((keyCode >= '0' && keyCode <= '9') || keyCode == '.') ) {
    input_str4 = input_str4 + key;
  }
  else if(keyCode == ENTER) {
    lin_speed = float(input_str4);
    lin_speed_input = false;
  }
  }
  
}