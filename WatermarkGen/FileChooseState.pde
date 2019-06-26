public class FileChooseState extends State{
  String[] extensions = {"jpg", "png", "ttf", "tga"};
  String message;
  void drawState(){
    if(this.uri.x == ""){
      message = "choose watermalk file. push ' f '.";
    }
    text(message, 0, 0, width, 100);
    text("target: " + this.uri.x, 0, textAscent() - textDescent() + 10, width, 100);
  };
  
  public void myKeyTyped(char k){
    if(keyPressed && k=='f'){
      noLoop();
      new InputFile(this.uri, extensions);
    }
  }
  void myKeyPressed(int k){

  };

  
  State decideState(){
    if(this.uri.x!=""){
      return new FileConfirmState(uri.x);
    }
    return this;
  };
}
