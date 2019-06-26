public class Watermark{
  PImage watermark_img;
  PImage base_img;
  String watermark_uri;
  int w, h;
  int cx, cy;
  int amount;
  int ang;
  int space_x, space_y;
  int alpha;
  boolean threshold_switch;
  int threshold_x, threshold_y;
  PGraphics canvas;
  // これはプレビュー用のコンストラクタ
  Watermark(int _cx, int _cy, int _w, int _h){
    this.cx = _cx;
    this.cy = _cy;
    this.w = _w;
    this.h = _h;
  }
  // これは透かし画像のuriを取り込む用
  Watermark(String uri){
    watermark_img = loadImage(uri);
    watermark_uri = uri;
    // 各種パラメータ 初期化
    amount = 1;
    alpha = 255;
    ang = 0;

  }
  // コピー用
  Watermark(String _uri, int _cx, int _cy, int _w, int _h, int _amount, int _ang, int _space_y, int _space_x, int _alpha, boolean _threshold_switch, int _threshold_x, int _threshold_y){
    this.watermark_uri = _uri;
    this.cx = _cx;
    this.cy = _cy;
    this.w = _w;
    this.h = _h;
    this.amount = _amount;
    this.ang = _ang;
    this.space_y = _space_y;
    this.space_x = _space_x;
    this.alpha = _alpha;
    this.threshold_switch = _threshold_switch;
    this.threshold_y = _threshold_y;
    this.threshold_x = _threshold_x;
  }

  Watermark copy(Watermark _wm, PImage base){
    Watermark ret = new Watermark(_wm.watermark_uri, base.width/2, base.height/2,
    base.width, base.height, _wm.amount, _wm.ang, _wm.space_y,
    _wm.space_x, _wm.alpha, _wm.threshold_switch, _wm.threshold_y,
     _wm.threshold_x);
    return ret;
  }

  PImage getWatermarkPreview(){
    PImage ret = this.canvas;
    return ret;
  }

  void resizePreviewScreen(int w, int h){
    this.w = w;
    this.h = h;
    updateWatermarkPreview();
  }


  void updateWatermarkPreview(){
    // PGraphics offscreen = createGraphics(this.w, this.h, P2D);
    PGraphics offscreen = createGraphics(this.w, this.h);
    watermark_img = loadImage(watermark_uri);

    float ratio = min(float(this.h)/watermark_img.height, float(this.w)/watermark_img.width)/this.amount;
    watermark_img.resize(max(round(watermark_img.width * ratio), 1), max(round(watermark_img.height * ratio), 1));
    boolean deep = false;
    this.threshold_y = this.threshold_switch ? round(this.h/this.amount)/2 : 0;
    offscreen.beginDraw();
    offscreen.imageMode(CENTER);
    for(int i=floor((this.h/this.amount)/2) - this.threshold_y; i<=this.h + this.threshold_y; i+=round(this.h/this.amount)){
      float margin_v = map(i, 0, h, -1, 1) * this.space_y;
      this.threshold_x = this.threshold_switch && deep ? round(this.w/this.amount)/2 : 0;
      for(int j=floor((this.w/this.amount)/2) - this.threshold_x; j<=this.w + this.threshold_x; j+=round(this.w/this.amount)){
        float margin_h = map(j, 0, w, -1, 1) * this.space_x;
        offscreen.pushMatrix();
        offscreen.translate(j+margin_h, i+margin_v);
        offscreen.rotate(radians(this.ang));
        offscreen.tint(255, this.alpha);
        offscreen.image(watermark_img, 0, 0);
        offscreen.popMatrix();
      }
      deep = !deep;
    }
    // offscreen.save("watermark.png");
    offscreen.endDraw();
    this.canvas = offscreen;
  }
}