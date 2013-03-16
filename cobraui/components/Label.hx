package cobraui.components;

import cobraui.components.Component;
import cobraui.graphics.BitmapFont;

import nme.display.Sprite;
import nme.display.BitmapData;
import nme.geom.Matrix;
import nme.geom.Point;

enum HAlignment {
  left;
  center;
  right;
}

enum VAlignment {
  top;
  middle;
  bottom;
}

class Label<T> extends Component {
  public static var font:BitmapFont;
  public var content(default, setContent):T;
  public var hAlign:HAlignment;
  public var vAlign:VAlignment;

  public function new(content:T, ?margin:Int = 0) {
    super();

    this.content = content;
    this.margin = margin;

    // Default is the left, middle
    this.hAlign = left;
    this.vAlign = middle;
  }

  private function getDrawPoint(width:Float, height:Float):Point {
    var pnt = new Point(margin, margin);
    if (uWidth != 10 && uHeight != 10) {
      switch(hAlign) {
        case center:
          pnt.x = Std.int((uWidth / 2) - (width / 2));
        case right:
          pnt.x = Std.int(uWidth - width - margin);
        case left:
      }
      switch(vAlign) {
        case middle:
          pnt.y = Std.int((uHeight / 2) - (height / 2));
        case bottom:
          pnt.y = Std.int(uHeight - height - margin);
        case top:
      }
    }
    return pnt;
  }

  override public function redraw() {
    if (ready) {
      super.redraw();
      if (Std.is(content, String)) { 
        var string = cast(content, String);
        var pnt = getDrawPoint(Label.font.getWidth(string), Label.font.fontHeight);
        Label.font.drawText(this.graphics, Std.int(pnt.x), Std.int(pnt.y), string);
      }
      else if (Std.is(content, BitmapData)) {
        var gfx = this.graphics;
        var temp = cast(content, BitmapData);
        var pnt = getDrawPoint(temp.width, temp.height);
        gfx.beginBitmapFill(temp, new Matrix(1, 0, 0, 1, pnt.x, pnt.y));
        gfx.drawRect(pnt.x, pnt.y, temp.width, temp.height);
        gfx.endFill();
      }
    }
  }

  private function setContent(t:T):T {
    content = t;
    redraw();
    return content;
  }

  override private function setMargin(m:Int):Int {
    margin = m;
    redraw();
    return margin;
  }

}
