public class TilingPatternState extends State{
  PImage tileImg;
  PFont dummyBold;
  int margin_top;
  int margin_rlb;
  int area_h;
  int area_w;
  Watermark offscreen_state;
  PGraphics offscreen;
  int offscreen_bg;
  boolean visibleHelp;
  // window resize 検知したい
  int pre_w, pre_h;


  TilingPatternState(String x){
    super(x);
    tileImg = loadImage(x);
    margin_rlb = 30;
    margin_top = 20;   // とりあえず
    offscreen_bg = color(255);
    rectMode(CENTER);
    dummyBold = createFont("Arial Black ttf", 40, true);
    visibleHelp = false;
    offscreen_state = new Watermark(this.uri.x);
    area_h = height - margin_rlb - margin_top*2;
    area_w = width - margin_rlb*2;
    offscreen_state.resizePreviewScreen(area_w, area_h);
    pre_h = height;
    pre_w = width;
  }

  void drawState(){
    pushStyle();
      fill(255);
      text("here is pattern.(push 'h' to help)", width/2, margin_top);
    popStyle();
    pushStyle();
      fill(offscreen_bg);
      /*
      area_h = height - margin_rlb - margin_top*2;
      area_w = width - margin_rlb*2;
      */
      if(!visibleHelp){
        rect(width/2, height/2, area_w, area_h);
        PImage tiling = offscreen_state.getWatermarkPreview();
        image(tiling, width/2, height/2);
        textFont(dummyBold);
        String sizeStr = str(int(area_w)) + " x " + str(int(area_h));
        fill(unbinary(binary(~offscreen_bg, 8)), 230);
        text(sizeStr, width/2, height/2);
      }else{
        PImage h = drawHelp(width/2, height/2, area_w, area_h);
        image(h, width/2, height/2);
      }
    popStyle();

    if(pre_h != height || pre_w != width){
      area_h = height - margin_rlb - margin_top*2;
      area_w = width - margin_rlb*2;
      offscreen_state.resizePreviewScreen(area_w, area_h);
      pre_h = height;
      pre_w = width;
    }
  }

  PImage drawHelp(int cx , int cy, float w, float h){
    offscreen = createGraphics(round(w), round(h), P2D);
    offscreen.beginDraw();
    offscreen.background(240);
    offscreen.pushStyle();
    offscreen.fill(20);
      offscreen.pushStyle();
      offscreen.textAlign(CENTER);
      offscreen.textSize(20);
      offscreen.text("useage command operation.", w/2, 30);
      offscreen.popStyle();

      offscreen.pushStyle();
      offscreen.textAlign(LEFT);
      offscreen.textSize(16);
      String commands = "r\na / d\nw / s\n↑ / ↓\n← / →\nb\nshift + s\nh";
      offscreen.text(commands, 30, 100);
      offscreen.popStyle();

      offscreen.pushStyle();
      offscreen.textAlign(RIGHT);
      offscreen.textSize(16);
      String expression = "increment rotate angle.\nexpand / shrink horizontal margin.\nexpand / shrink vertical margin.\nincrement / decrement amount of loop.\nincrement / decrement transparent.\nswitch background color.\nnext step.\nshow or close help view.";
      offscreen.text(expression, w-30, 100);
      offscreen.popStyle();
    offscreen.popStyle();
    offscreen.endDraw();
    return offscreen;
  }


  void myKeyTyped(char k){
    switch(k){
      case 'r':
        // 回転
        offscreen_state.ang = (offscreen_state.ang+10)%360;
        break;
      case 'w':
        offscreen_state.space_y = min(offscreen_state.space_y+5, max(offscreen_state.w, offscreen_state.h));
        break;
      case 'a':
        offscreen_state.space_x = max(offscreen_state.space_x-5, 0);
        break;
      case 's':
        offscreen_state.space_y = max(offscreen_state.space_y-5, 0);
        break;
      case 'd':
        offscreen_state.space_x = min(offscreen_state.space_x+5, max(offscreen_state.w, offscreen_state.h));
        break;
      case 't':
        offscreen_state.threshold_switch = ! offscreen_state.threshold_switch;
        break;
      case 'b':
        offscreen_bg = unbinary(binary(~offscreen_bg, 8));
        break;
      case 'h':
        visibleHelp = !visibleHelp;
        break;
      default:
        break;
    }
    offscreen_state.updateWatermarkPreview();
  }

  void myKeyPressed(int keyCode){
    if(keyCode==UP || keyCode==DOWN || keyCode==RIGHT || keyCode==LEFT){
      if(keyCode==UP){
        offscreen_state.amount = min(offscreen_state.amount+1, 10);
      }else if(keyCode==DOWN){
        offscreen_state.amount = max(1, offscreen_state.amount-1);
      }else if(keyCode==RIGHT){
        offscreen_state.alpha = min(offscreen_state.alpha + 17, 255);
      }else if(keyCode==LEFT){
        offscreen_state.alpha = max(offscreen_state.alpha - 17, 0);
      }
      offscreen_state.updateWatermarkPreview();
    }
  };

  State decideState(){
    if(keyPressed && key=='S'){
      noLoop();
      return new FolderChooseState(this, offscreen_state);
    }
    return this;
  }
}