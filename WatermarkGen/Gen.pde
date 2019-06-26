class Gen{
  Watermark wm;
  WatermarkImage wi;
  File saveplace;
  String suffix;
  PImage current_processing;
  Gen (Watermark _wm, File _saveplace, WatermarkImage _wi){
    this.wm = _wm;
    this.wi = _wi;
    this.saveplace = _saveplace;
    suffix = "generate_" + String.valueOf(year())+String.valueOf(month())+String.valueOf(day());
    current_processing = new PImage();
    imageMode(CENTER);
  }

  void recursiveImgFile(File file, String uri, ArrayList<File> ret){
    for(File f : file.listFiles()){
      if(f.isDirectory()){
        if(match(f.getName(), suffix+".*\\d*$") != null){
          continue;
        }
        String next_uri = uri + "/" +  f.getName();
        recursiveImgFile(f, next_uri, ret);
      }else if (f.isFile()){
        String[] extensions = {"jpg", "png", "gif", "tiff"};
        for(String extension : extensions){
          if(f.getPath().toLowerCase().endsWith(extension)){
            // ここでmake fileして画像をコピーしてみる          
            File dir = new File(uri);
            if(!dir.exists()){
              // println("create directory of: ", dir.getPath(), " name : ", dir.getName());
              dir.mkdirs();
            }
            PImage copy = loadImage(f.getPath());
            Watermark pattern = wm.copy(wm, copy);
            pattern.updateWatermarkPreview();
            PGraphics offscreen_canvas = createGraphics(copy.width, copy.height);
            
            offscreen_canvas.beginDraw();
            offscreen_canvas.image(copy, 0, 0);
            offscreen_canvas.image(pattern.getWatermarkPreview(), 0, 0); 
            offscreen_canvas.save(uri + "/" + f.getName());
            current_processing = offscreen_canvas;
            offscreen_canvas.endDraw();
            wi.img = offscreen_canvas;
            // println("will make " + uri + " to " + f.getName());

            ret.add(f);
          }
        }
      }
    }
  }

  void loadImageFromFolder(){
    ArrayList<File> ret = new ArrayList<File>();
    if(saveplace != null){
      String base = saveplace.getName()+"/";
      println(saveplace.getPath());
      // まずbaseをもとにsuffixのディレクトリを作る必要がある
      // すでに存在していたらインクリメントする
      File dir = new File(saveplace.getPath() + "/" + suffix);
      int i=0;
      while(dir.exists()){
        i++;
        dir = new File(saveplace.getPath() + "/" + suffix + "_" + String.valueOf(i));
      }
      recursiveImgFile(saveplace, dir.getPath(), ret);
    }
    println("とってきたお");
    for(File f : ret){
      println(f.getAbsolutePath());
    }
  }
}