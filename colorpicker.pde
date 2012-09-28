// tobystereo20120913.pde
// 
// http://www.tobystereo.com
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
 * changing colors and size by moving the mouse
 * 	 
 * MOUSE
 * position x          : size
 * position y          : color
 * 
 * KEYS
 * s                   : save png
 * p                   : save pdf
 */

import processing.pdf.*;
import java.awt.datatransfer.*;
import java.awt.Toolkit; 
import processing.opengl.*;
import javax.swing.*; 
import controlP5.*;

boolean savePDF = false;
PImage img;
PImage theImage;
PImage imageCache;
boolean newImage = true;

ControlP5 cp5;
ControlWindow controlWindow;
ControlWindowCanvas cc;

int index = 0;
int cH1 = 0;
int cH2, cH3;
int cS = 0;
int cB = 0;
int color2Distance = 60;
int color3Distance = 120;
color c;
float ellipseX = width/2;
float ellipseY = height/2;
int windowWidth = 500;
int windowHeight = 500;
int rectH = 50;
int[][] values;
int[][] colorvalues;
int controlPosX = 100;
int controlWidth = 200;
int controlHeight = 400;
String c1 = "";
String c2 = "";
String c3 = "";
String statusText = "";

// your controlWindowCanvas class
class MyCanvas extends ControlWindowCanvas {
  
  public void draw(PApplet theApplet) {
    theApplet.colorMode(HSB, 360, 100, 100);
    theApplet.stroke(2);
    // draw the color picker circle 
    theApplet.fill(cH1, cS, cB);
    // draw the first (selected) color box
    theApplet.rect(0, rectH, controlWidth, 2*rectH);
  
    // draw the second (first derived) color box
    // if the distance to the parent color brings it beyond the scope, adjust it accordingly
    if (cH1+color2Distance<0) {
      cH3=cH1+color2Distance+360;
    }
    else if (cH1+color2Distance>360) {
      cH3=cH1+color2Distance-360;
    }
    else {
      cH3=cH1+color2Distance;
    };
    // set the fill color to the derived color
    theApplet.fill(cH2, cS, cB);
    // draw the box for the derived color
    theApplet.rect(0, 3*rectH, controlWidth, 2*rectH);
  
    // draw the third (second derived) color box
    // if the distance to the parent color brings it beyond the scope, adjust it accordingly
    if (cH1+color3Distance<0) {
      cH3=cH1+color3Distance+360;
    }
    else if (cH1+color3Distance>360) {
      cH3=cH1+color3Distance-360;
    }
    else {
      cH3=cH1+color3Distance;
    };
    // set the fill color to the derived color
    theApplet.fill(cH3, cS, cB);
    // draw the box for the derived color
    theApplet.rect(0, 5*rectH, controlWidth, 2*rectH);
    
    theApplet.fill(0,0,100);
    theApplet.text("Load new image ⇧", 20,20,controlWidth-40,rectH);
    
    theApplet.fill(0,0,0);
    theApplet.text(c1, 10, controlHeight-20-(6*rectH), controlWidth, 20);  // Text wraps within text box
    theApplet.fill(0,0,100);
    theApplet.text(c1, 10, controlHeight-20-(6*rectH)+20, controlWidth, 20);  // Text wraps within text box
    
    theApplet.fill(0,0,0);
    theApplet.text(c2, 10, controlHeight-20-(4*rectH), controlWidth, 20);  // Text wraps within text box
    theApplet.fill(0,0,100);
    theApplet.text(c1, 10, controlHeight-20-(4*rectH)+20, controlWidth, 20);  // Text wraps within text box
    
    theApplet.fill(0,0,0);
    theApplet.text(c2, 10, controlHeight-20-(2*rectH), controlWidth, 20);  // Text wraps within text box
    theApplet.fill(0,0,100);
    theApplet.text(c1, 10, controlHeight-20-(2*rectH)+20, controlWidth, 20);  // Text wraps within text box
   
    theApplet.text(statusText, 10, controlHeight-40, controlWidth-20, rectH);  // Text wraps within text box
    
    if(theApplet.mousePressed){
     if(theApplet.mouseY < rectH){Load_Image(0);}
    }
  }

}

public void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getName());
}

// function colorA will receive changes from 
public void Load_Image(int theValue)  { theImage = openImage(); }


void setup() {
  size(windowWidth, windowHeight);
  theImage = loadImage("fallback.png");
  cp5 = new ControlP5(this);
  img = loadImage("fallback.png");
  c = get(int(ellipseX), int(ellipseY));
  smooth();
  
  controlWindow = cp5.addControlWindow("controlP5window", 100, 100, 200, rectH*8)
  .hideCoordinates()
  .setBackground(color(40))
  ;
  controlWindow.setUpdateMode(ControlWindow.NORMAL);
  
  cc = new MyCanvas();
  cc.pre();
  controlWindow.addCanvas(cc);
  Load_Image(0);
}


void draw() {
  background(40);
  // this line will start pdf export, if the variable savePDF was set to true 
  if (savePDF) beginRecord(PDF, timestamp()+".pdf");
  // set colorMode to HSB to be able to derive colors by just changing the hue value
  colorMode(HSB, 360, 100, 100);
  ellipseMode(CENTER);
  stroke(2);

  // display the loaded image
  image(img, 0, 0);

  // draw the color picker circle 
  fill(cH1, cS, cB);
  ellipse(ellipseX, ellipseY, 50, 50);

  // end of pdf recording
  if (savePDF) {
    savePDF = false;
    endRecord();
  }
}

void mouseReleased() {
  // read the color of the clicked loaction
  color pixelCol = get(mouseX, mouseY);
  // read the HSB values of the color
  cH1 = int(hue(pixelCol));
  cS = int(saturation(pixelCol));
  cB = int(brightness(pixelCol));
  // position the color picker circle at the clicked position
  ellipseX = mouseX;
  ellipseY = mouseY;
  
  // convert the colors to HEX
  c1 = "#"+hex(color(cH1,cS,cB),6);
  c2 = "#"+hex(color(cH2,cS,cB),6);
  c3 = "#"+hex(color(cH3,cS,cB),6);
  // print them out in the console
  println("color1 = "+c1+" color2 = "+c2+" color3 = "+c3);
  // and copy them to the clipboard
  cp.copyString("color1 = "+c1+" color2 = "+c2+" color3 = "+c3);
  statusText = "color values have been copied to the clipboard";
}


void keyPressed() {
  if (key=='s' || key=='S') saveFrame(timestamp()+"_##.png");
  if (key=='p' || key=='P') savePDF = true;
  if (key=='c' || key=='C') cp.copyString(""+(int)random(255));
}


String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("$ty$tm$td_$tH$tM$tS", now);
}

ClipHelper cp = new ClipHelper();

// CLIPHELPER OBJECT CLASS:

class ClipHelper {
  Clipboard clipboard;
  
  ClipHelper() {
    getClipboard();  
  }
  
  void getClipboard () {
    // this is our simple thread that grabs the clipboard
    Thread clipThread = new Thread() {
	public void run() {
	  clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
	}
    };
  
    // start the thread as a daemon thread and wait for it to die
    if (clipboard == null) {
	try {
	  clipThread.setDaemon(true);
	  clipThread.start();
	  clipThread.join();
	}  
	catch (Exception e) {}
    }
  }
  
  void copyString (String data) {
    copyTransferableObject(new StringSelection(data));
  }
  
  void copyTransferableObject (Transferable contents) {
    getClipboard();
    clipboard.setContents(contents, null);
  }
  
  String pasteString () {
    String data = null;
    try {
	data = (String)pasteObject(DataFlavor.stringFlavor);
    }  
    catch (Exception e) {
	System.err.println("Error getting String from clipboard: " + e);
    }
    return data;
  }
  
  Object pasteObject (DataFlavor flavor)  
  throws UnsupportedFlavorException, IOException
  {
    Object obj = null;
    getClipboard();
    
    Transferable content = clipboard.getContents(null);
    if (content != null)
    obj = content.getTransferData(flavor);
    
    return obj;
  }
}

PImage openImage() {
   /**
    filechooser taken from http://processinghacks.com/hacks:filechooser
    @author Tom Carden
  */
   // set system look and feel 
   
  img = loadImage("fallback.png");
 
  try { 
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName()); 
  } catch (Exception e) { 
    e.printStackTrace();  
  } 
  
  // create a file chooser 
  final JFileChooser fc = new JFileChooser(); 
   
  // in response to a button click: 
  int returnVal = fc.showOpenDialog(this); 
   
  if (returnVal == JFileChooser.APPROVE_OPTION) { 
    File file = fc.getSelectedFile(); 
    // see if it's an image 
    // (better to write a function and check for all supported extensions) 
    if (file.getName().endsWith("jpg") || file.getName().endsWith("png") || file.getName().endsWith("gif") || file.getName().endsWith("tiff") || file.getName().endsWith("jpeg")) { 
      // load the image using the given file path
      img = loadImage(file.getPath()); 
      if (img != null) { 
        // size the window and show the image
        img.loadPixels(); 
        values = new int[img.width][img.height];
        colorvalues = new int[img.width][img.height];
        for (int y = 0; y < img.height; y++) {
          for (int x = 0; x < img.width; x++) {
            color pixel = img.get(x, y);
            values[x][y] = int(brightness(pixel));
          }
        }
        for (int y = 0; y < img.height; y++) {
          for (int x = 0; x < img.width; x++) {
            colorvalues[x][y] = color (img.get(x, y));
          }
        }
        size(img.width,img.height); 
        image(img,width,height);
        newImage = true;
        return img;
      } 
    } else { 
      // load the dafault image 
      img = loadImage("fallback.png");
    
      
    } 
  } else { 
    println("Open command cancelled by user."); 
  }
  
  return img;
}

/* 
 TODO
 
 - adjust window size to image loaded
 - export .ase file for colors
 
 */
