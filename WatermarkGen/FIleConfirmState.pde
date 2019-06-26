class FileConfirmState extends State{
  PImage img;
  float ratio;
  FileConfirmState(String x){
    super(x);
    img = loadImage(x);
    imageMode(CENTER);
    float margin = 20;
    float h = max(height - margin * 10, 100);
    float w = width - margin * 2;
    ratio = min((h/img.height), (w/img.width));
    img.resize(int(img.width*ratio), int(img.height*ratio));
  }
  void drawState(){
    text("are you okay? [y/n]", width/2, height * 1/5);
    image(img, width/2, height/2);
  };
  void myKeyTyped(char k){

  }
  void myKeyPressed(int k){

  };


  State decideState(){
    if(keyPressed && key=='n'){
      return new FileChooseState();
    }else if(keyPressed && key=='y'){
      return new FileToTypeState(this.uri.x);
    }
    return this;
  };

}
