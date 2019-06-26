public class InputFileUri{
  String x;
  ArrayList<String> allx;
  InputFileUri(){
    x = "";
    allx = new ArrayList<String>();
  }
  void setPath(String _x){
    x = _x;
  }
  void addPath(String _x){
    allx.add(_x);
  }
}
