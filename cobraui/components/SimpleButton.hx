package cobraui.components;

import cobraui.graphics.Color;

import nme.display.Shape;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.ui.Multitouch;

enum ButtonState {
  normal;
  clicked;
}

class SimpleButton<T> extends Label<T> {
  public static var defaultClickBackground:Int = 0x777777;
  public var state(default, setState):ButtonState;
  public var stickyState:Bool;
  public var flagged(default, setFlagged):Bool;
  private var originalBackround:Color;
  private var flag:Shape;
  private var dirtyFlag:Bool;

  public var clickBackground:Color;
  public var onClick:MouseEvent->Void;

  public function new(content:T, ?margin:Int = 0) {
    super(content, margin);

    // Default is the centered
    this.hAlign = center;
    this.vAlign = middle;

    state = normal;
    stickyState = false;

    flag = new Shape();
    addChild(flag);
    flag.visible = false;

    flagged = false;
    dirtyFlag = true;

    if (Component.themeFactory == null) {
      clickBackground = new Color(defaultClickBackground);
    } else {
      loadFromThemeFactory("button");
    }

    addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
    addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
    addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
    if (Multitouch.supportsTouchEvents) {
      addEventListener(TouchEvent.TOUCH_OUT, onMouseOut);
    }
  }

  override public function loadFromThemeFactory(name:String) {
    super.loadFromThemeFactory(name);
    
    var tempClickBackground = Component.themeFactory.getColor(name, "clickBackground");
    if (tempClickBackground != null) {
      clickBackground = tempClickBackground;
    } else if (clickBackground == null) {
      clickBackground = new Color(defaultClickBackground);
    }
  }

  override public function resize(width:Float, height:Float) {
    super.resize(width, height);
    if (flagged) {
      renderFlag();
    } else {
      dirtyFlag = true;
    }
  }

  private function renderFlag() {
    var tempWidth = uWidth * 0.4;
    var tempHeight = uHeight * 0.4;
    var tempSize = Math.min(tempWidth, tempHeight);
    var gfx = flag.graphics;
    gfx.clear();
    gfx.beginFill(border.colorInt);
    gfx.moveTo(tempSize, 0);
    gfx.lineTo(tempSize, tempSize);
    gfx.lineTo(0, tempSize);
    gfx.lineTo(tempSize, 0);
    gfx.endFill();
    flag.x = uWidth - flag.width;
    flag.y = uHeight - flag.height;
    dirtyFlag = false;
  }

  private function setState(newState:ButtonState):ButtonState {
    if (state != newState) {
      if (state == normal && newState == clicked) {
        originalBackround = background;
        if (clickBackground != null) {
          background = clickBackground;
        }
      } else if (state == clicked && newState == normal) {
        background = originalBackround;
      }
      state = newState;

      redraw();
    }

    return newState;
  }

  private function setFlagged(flagged:Bool):Bool {
    this.flagged = flagged;
    if (flagged) {
      if (dirtyFlag) {
        renderFlag();
      }
      flag.visible = true;
    } else {
      flag.visible = false;
    }
    return flagged;
  }

  //
  // Event Handlers
  //
  private function onMouseUp(event:MouseEvent) {
    if (state == clicked) {
      if (onClick != null) {
        onClick(event);
      }
      if (!stickyState) {
        state = normal;
      }
    }
  }

  private function onMouseDown(event:MouseEvent) {
    state = clicked;
  }

  private function onMouseOut(event:MouseEvent) {
    if (!stickyState) {
      state = normal;
    }
  }

}

