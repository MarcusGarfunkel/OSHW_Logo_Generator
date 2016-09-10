/*
Project: Open Hardware Logo Generator
Author: Marcus Garfunkel
Date: 9/9/2016
Purpose: Generate Logos for use with Open Hardware projects

Comments/Questions/Suggestions: Twitter @mgarf

Copyright (c) 2016 Marcus Garfunkel
See end of file for terms of use. 
*/

// TODO:




import controlP5.*;
 
ControlP5 cp5;

PFont myFont; //create a PFont variable
PImage img;
CheckBox checkbox;
CheckBox checkbox_partial;

JSONObject options;

void setup()
{
  frameRate(15);
  myFont = loadFont("ArialMT-48.vlw");//Load the font to the variable
  options = loadJSONObject("/data/default.json");
  size(980, 900);
  cp5 = new ControlP5(this);
  
  checkbox = cp5.addCheckBox("checkBox")
        .setPosition(100, 50)
        .setSize(40, 40)
        .setItemsPerRow(1)
        .setSpacingColumn(30)
        .setSpacingRow(20)
        .addItem("S = Schematic", 0)
        .addItem("P = PCB", 0)
        .addItem("F = Firmware and/or software", 0)
        .addItem("M = Mechanical CAD files", 0)
        .addItem("D = Design Documentation", 0)
        .addItem("B = Bill Of Materials", 0)
        .addItem("C = License used allows for commercial use", 0)
        ;
        
  float cogOptions_S = int(options.getFloat("cogOptions_S"));
  float cogOptions_P = int(options.getFloat("cogOptions_P"));
  float cogOptions_F = int(options.getFloat("cogOptions_F"));
  float cogOptions_M = int(options.getFloat("cogOptions_M"));
  float cogOptions_D = int(options.getFloat("cogOptions_D"));
  float cogOptions_B = int(options.getFloat("cogOptions_B"));
  float cogOptions_C = int(options.getFloat("cogOptions_C"));
  float[] cogOptionsArray = {cogOptions_S, cogOptions_P, cogOptions_F, cogOptions_M, cogOptions_D, cogOptions_B, cogOptions_C};
  checkbox.setArrayValue(cogOptionsArray);

  checkbox_partial = cp5.addCheckBox("checkBox_partial")
        .setPosition(40, 50)
        .setSize(40, 40)
        .setItemsPerRow(1)
        .setSpacingColumn(30)
        .setSpacingRow(20)
        .addItem("Partial_S", 0)
        .addItem("Partial_P", 0)
        .addItem("Partial_F", 0)
        .addItem("Partial_M", 0)
        .addItem("Partial_D", 0)
        .addItem("Partial_B", 0)
        .addItem("Partial_C", 0)
        .hideLabels()
        ;

  cogOptions_S = int(options.getFloat("Partial_S"));
  cogOptions_P = int(options.getFloat("Partial_P"));
  cogOptions_F = int(options.getFloat("Partial_F"));
  cogOptions_M = int(options.getFloat("Partial_M"));
  cogOptions_D = int(options.getFloat("Partial_D"));
  cogOptions_B = int(options.getFloat("Partial_B"));
  cogOptions_C = int(options.getFloat("Partial_C"));
  float[] cogOptionsArray2 = {cogOptions_S, cogOptions_P, cogOptions_F, cogOptions_M, cogOptions_D, cogOptions_B, cogOptions_C};
  checkbox_partial.setArrayValue(cogOptionsArray2);

  // create a new button with name 'buttonA'
  cp5.addButton("save")
     //.setValue(0)
     .setPosition(40,470)
     .setSize(100,50)
     ;
     
  

}

void draw()
{
  background(color(#000000, 0));
  
  fill(255);
  text(("("+mouseX+","+mouseY+")"),50,height-10); 
  textAlign(CENTER);
  text("Partial", 60, 43);
  text("Options", 120, 43);
  img = loadImage("oshw-logo-800-px-original.png");
  imageMode(CENTER);
  image(img, width/2+80, height/2);
  image(makeImage(800, 800, getOptions(), getOptions_Partial()), width/2+80, height/2);
  
}

boolean[] getOptions(){
  
  boolean[] imageOptions = {false, false, false, false, false, false, false};
  for (int i=0;i<checkbox.getArrayValue().length;i++) {
    int n = (int)checkbox.getArrayValue()[i];
    if(n == 1){
      imageOptions[i] = true;
    }else{
      imageOptions[i] = false;
    }
    //print(n);
  }

  options.setFloat("cogOptions_S", int(imageOptions[0]));
  options.setFloat("cogOptions_P", int(imageOptions[1]));
  options.setFloat("cogOptions_F", int(imageOptions[2]));
  options.setFloat("cogOptions_M", int(imageOptions[3]));
  options.setFloat("cogOptions_D", int(imageOptions[4]));
  options.setFloat("cogOptions_B", int(imageOptions[5]));
  options.setFloat("cogOptions_C", int(imageOptions[6]));
  
  return imageOptions;
}

boolean[] getOptions_Partial(){
  
  boolean[] imageOptions = {false, false, false, false, false, false, false};
  for (int i=0;i<checkbox_partial.getArrayValue().length;i++) {
    int n = (int)checkbox_partial.getArrayValue()[i];
    if(n == 1){
      imageOptions[i] = true;
    }else{
      imageOptions[i] = false;
    }
    //print(n);
  }

  options.setFloat("Partial_S", int(imageOptions[0]));
  options.setFloat("Partial_P", int(imageOptions[1]));
  options.setFloat("Partial_F", int(imageOptions[2]));
  options.setFloat("Partial_M", int(imageOptions[3]));
  options.setFloat("Partial_D", int(imageOptions[4]));
  options.setFloat("Partial_B", int(imageOptions[5]));
  options.setFloat("Partial_C", int(imageOptions[6]));
  
  return imageOptions;
}

public void save() {
  
  
  int imageWidth = 761;
  int imageHeight = 800;
  

  saveJSONObject(options, "/data/default.json");
  createImages(imageWidth, imageHeight, getOptions(), getOptions_Partial());
}

void createImages(int imageWidth, int imageHeight, boolean[] imageOptions, boolean[] partialOptions)
{
  PGraphics Q1;
  
  Q1 = createGraphics(imageWidth, imageHeight);
  PImage temp = loadImage("oshw-logo-800-px-original.png");
  Q1.beginDraw();
  Q1.background(0, 0, 0, 0);
  Q1.image(temp, 0, 0);
  PGraphics pg = makeImage(imageWidth, imageHeight, imageOptions, partialOptions);
  pg.filter(BLUR, 1);
  Q1.image(pg, -20, 0);
  Q1.endDraw();
  Q1.save("/images/Open_HW_Logo.png");
  Q1.clear();
    
}


PGraphics makeImage(int imageWidth, int imageHeight, boolean[] imageOptions, boolean[] partialOptions)
{
  PGraphics pg = createGraphics(imageWidth, imageHeight);
  pg.beginDraw();
  pg.background(0, 0, 0, 0);
  
  pg. textSize(85);
  if(imageOptions[0]){
    // draw the S
    if(partialOptions[0]){
      pg.fill(255, 0, 0);
    }else{
      pg.fill(255);
    }
    pg.text("S", 201, 497);
  }
  if(imageOptions[1]){
    // draw the S
    if(partialOptions[1]){
      pg.fill(255, 0, 0);
    }else{
      pg.fill(255);
    }
    pg.text("P", 126, 328);
  }
  if(imageOptions[2]){
    // draw the S
    if(partialOptions[2]){
      pg.fill(255, 0, 0);
    }else{
      pg.fill(255);
    }
    pg.text("F", 198, 150);
  }
  if(imageOptions[3]){
    // draw the S
    if(partialOptions[3]){
      pg.fill(255, 0, 0);
    }else{
      pg.fill(255);
    }
    pg.text("M", 365, 70);
  }
  if(imageOptions[4]){
    // draw the S
    if(partialOptions[4]){
      pg.fill(255, 0, 0);
    }else{
      pg.fill(255);
    }
    pg.text("D", 550, 145);
  }
  if(imageOptions[5]){
    // draw the S
    if(partialOptions[5]){
      pg.fill(255, 0, 0);
    }else{
      pg.fill(255);
    }
    pg.text("B", 620, 325);
  }
  if(imageOptions[6]){
    // draw the S
    if(partialOptions[6]){
      pg.fill(255, 0, 0);
    }else{
      pg.fill(255);
    }
    pg.text("C", 545, 506);
  }
  pg.endDraw();
  return pg;
}



/*

┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                   TERMS OF USE: MIT License                                                  │                                                            
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation    │ 
│files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,    │
│modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software│
│is furnished to do so, subject to the following conditions:                                                                   │
│                                                                                                                              │
│The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.│
│                                                                                                                              │
│THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE          │
│WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR         │
│COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   │
│ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                         │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/