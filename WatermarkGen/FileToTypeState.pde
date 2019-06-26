class FileToTypeState extends State{
  FileToTypeState(String x){
    super(x);
  }
  void drawState(){
    text("select watermalk pattern.", width/2, 10);
    pushStyle();
    fill(250, 0, 0);

    textSize(25);
    text("!! NOTE !!\nthis version is not supported \nany options \nbesides 'tiling' !!\n push 't' key to next section.", width/2, height * 2/5+30);
    popStyle();
  };
  void myKeyTyped(char k){
  };
  void myKeyPressed(int k){
  };

  State decideState(){
    if(keyPressed && key=='t'){
      return new TilingPatternState(this.uri.x);
    }
    return this;
  };

}
