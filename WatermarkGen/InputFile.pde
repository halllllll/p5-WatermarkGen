public class InputFile {
  String path;
  String[] filterExtensions;
  InputFileUri fileUri;
  InputFileUri folderUri;
  InputFile(){
    // this.folderUri = _fileUri;
    this.path = "";
    selectFolder("Select a target folder.", "folderSelected", null, this);
  }
  InputFile(InputFileUri _fileUri, String[] _filterExtensions) {
    this.fileUri = _fileUri;
    this.filterExtensions = _filterExtensions;
    selectInput("Select a file to process:", "fileSelected", null, this);
  }
 
  void fileSelected(File selection) {
    if (selection == null){
      println("Window was closed or the user hit cancel.");
    }else if (!selection.isFile()){
      println("\"" + selection + "\" is an invalid file.");
    }else{
      // 拡張子判定
      for(String extension : filterExtensions){
        if(selection.getPath().toLowerCase().endsWith(extension)){
          println("User selected " + (path = selection.getAbsolutePath()));
          fileUri.setPath(path);
          break;
        }
      }
    }
    loop();
  }

  void folderSelected(File selection){
    if (selection == null){
      println("Window was closed or the user hit cancel.");
    }else if(selection.isFile()){
      println("selection is an invalid file.");
    }else if(selection.isDirectory()){
      println("isDirectoryなんてあるのね");
      path = selection.getAbsolutePath();
    }
    loop();
  }
}
