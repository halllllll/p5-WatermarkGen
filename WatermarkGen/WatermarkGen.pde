State state;
PFont myfont;
public WatermarkImage wi;
void setup(){
  surface.setResizable(true);
  surface.setSize(400, 400);  // Note 背景色？
  surface.setFrameRate(10);
  // size(400, 400, P2D);
  size(400, 400);
  // pixelDensity(displayDensity());
  smooth(4);
  textAlign(CENTER, CENTER);

  state = new FileChooseState();
  wi = new WatermarkImage();
  myfont = createFont("SourceHanSansJP-Light.otf", 20, true);
  textFont(myfont);
}

void draw(){
  background(180);
  state = state.doState();
  float ratio = 1.0;
  if(wi.img.width>0 || wi.img.height>0){
    ratio = min(float(width)/wi.img.width, float(height)/wi.img.height);
  }
  imageMode(CENTER);
  image(wi.img, width/2, height/2, round(wi.img.width*ratio),  round(wi.img.height*ratio));
}

void keyTyped(){
  state.myKeyTyped(key);
}

void keyPressed(){
  state.myKeyPressed(keyCode);
}
