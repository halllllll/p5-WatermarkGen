abstract class State{
  // String file;
  InputFileUri uri = new InputFileUri();

  State(){
  }
  State(String _x){
    uri.x = _x;
  }
  State doState(){
    drawState();
    return decideState();
  }
  abstract void drawState();
  abstract void myKeyPressed(int keyCode);
  abstract void myKeyTyped(char k);
  abstract State decideState();
}
