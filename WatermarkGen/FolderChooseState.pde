public class FolderChooseState extends State{
  State preState;
  Watermark wm;
  // InputFile select;
  String folderpath;
  boolean generate;
  String message;
  FolderChooseState(State _pre, Watermark _wm){
    this.preState = _pre;
    this.wm = _wm; 
    noLoop();
    // select = new InputFile();
    message = "";
    generate = false;
    selectFolder("Select a file to process:", "folderSelected", null, this);
  }

  void folderSelected(File selection){
    if (selection == null){
      println("Window was closed or the user hit cancel.");
      folderpath = "";
      loop();
    }else if(selection.isFile()){
      println("selection is an invalid file.");
    }else if(selection.isDirectory()){
      folderpath = selection.getAbsolutePath();
      loop();
      Gen save = new Gen(wm, selection, wi);
      save.loadImageFromFolder();
      wi = new WatermarkImage();  // 全部おわったのでリセット
    }
    // noLoop();
    println("は？なんこれ");
  }


  void drawState(){
    if(!generate){
      // message = String.format("select folder phase.\npush 'y' to return.\nor 'g' to generate in %s.", folderpath);
      message = String.format("select folder phase.\npush 'y' to return.\nor 'c' to select a folder %s.", folderpath);
    }else{      
      message = "generating...";
    }
    textAlign(CENTER);
    text(message, width/2, height/3, width/2, height/2);
  }

  void myKeyPressed(int keycode){

  }

  void myKeyTyped(char k){
  }

  State decideState(){
    if(!generate){
      if(keyPressed && key=='y' || this.folderpath == ""){
        println("戻ります");
        loop();
        return preState;
      }else if(keyPressed && key == 'g'){
        generate = true;   
        // preの中身どんなんなってるか確かめてみたい
        println(preState);
        println(wm.watermark_uri);
      }else if(keyPressed && key == 'c'){
        return new FolderChooseState(preState, wm);
      }
    }
    return this;
  }
}