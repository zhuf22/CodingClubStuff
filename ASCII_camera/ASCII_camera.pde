import processing.video.*;
Capture cam;
int cam_scale = 10;
String ascii = "$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\\|()1{}[]?-_+~<>i!lI;:,\"^`\'.   ";

void setup(){
  size(640, 480);
  
  String[] cameras = Capture.list();
  cam = new Capture(this, width/cam_scale, height/cam_scale, cameras[0]);
  cam.start();
  
  textSize(cam_scale);
}

void draw(){
  background(0);
  if(cam.available()) cam.read();
  
  cam.loadPixels();
  for(int x = 0; x < cam.width; x++){
    for(int y = 0; y < cam.height; y++){
      color c = cam.pixels[y*cam.width + x];
      float brightness = (red(c) + green(c) + blue(c))/3.0/255.0;
      brightness = 1-brightness;
      brightness *= ascii.length();
      int index = floor(brightness);
      index = constrain(index, 0, ascii.length()-1);
      text(ascii.charAt(index), x*cam_scale, y*cam_scale);
    }
  }
}
