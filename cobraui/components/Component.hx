package cobraui.components;

import cobraui.graphics.Color;
import cobraui.util.ThemeFactory;

import flash.display.Sprite;
import flash.events.Event;
import flash.display.Graphics;

class Component extends Sprite {
  public static var themeFactory:ThemeFactory;

  public static var defaultBackground:Int = 0xDDDDDD;
  public static var defaultForeground:Int = 0x000000;
  public static var defaultBorder:Int = 0x777777;
  public static var defaultBorderWidth:Int = 0;

  public var uWidth (default, null):Float;
  public var uHeight (default, null):Float;
  public var margin (default, set):Int;
  public var background:Color;
  public var foreground:Color;
  public var border:Color;
  public var borderWidth:Int;
  public var ready:Bool;

  public var isClickable:Bool;

  public var predraw:Graphics->Float->Float->Void;

  public function new() {
    super();

    ready = false;
    uWidth = 10;
    uHeight = 10;
    margin = 0;

    isClickable = false;
    
    // Set a default since it can't be null
    borderWidth = -1;

    if (Component.themeFactory == null) {
      background = new Color(defaultBackground);
      foreground = new Color(defaultForeground);
      
      border = new Color(defaultBorder);
      borderWidth = defaultBorderWidth;
    } else {
      loadFromThemeFactory("component");
    }

    predraw = null;

    addEventListener(Event.ADDED, function(e:Event) {
      ready = true;
      redraw();
    });
  }

  public function loadFromThemeFactory(name:String) {
    var tempBackground = Component.themeFactory.getColor(name, "background");
    if (tempBackground != null) {
      background = tempBackground;
    } else if (background == null) {
      background = new Color(defaultBackground);
    }

    var tempForeground = Component.themeFactory.getColor(name, "foreground");
    if (tempForeground != null) {
      foreground = tempForeground;
    } else if (foreground == null) {
      foreground = new Color(defaultForeground);
    }

    var tempBorder = Component.themeFactory.getColor(name, "border");
    if (tempBorder != null) {
      border = tempBorder;
    } else if (border == null) {
      border = new Color(defaultBorder);
    }

    var tempBorderWidth = Component.themeFactory.getSizing(name, "borderWidth");
    if (tempBorderWidth != -1) {
      borderWidth = tempBorderWidth;
    } else if (borderWidth == -1) {
      borderWidth = defaultBorderWidth;
    }
  }

  public function resize(width:Float, height:Float) {
    uWidth = width;
    uHeight = height;
    redraw();
  }

  public function redraw() {
    if (ready) {
      var gfx = this.graphics;
      gfx.clear();
      if (predraw != null) {
        predraw(this.graphics, uWidth, uHeight);
      }
      if (background != null) {

        if (borderWidth > 0) {
          gfx.lineStyle(borderWidth, border.colorInt, border.alpha);
        }

        gfx.beginFill(background.colorInt, background.alpha);
        //gfx.drawRect(-borderWidth, -borderWidth, uWidth + (borderWidth * 2), uHeight + (borderWidth * 2));
        //gfx.drawRect(borderWidth, borderWidth, uWidth - (borderWidth * 2), uHeight - (borderWidth * 2));
        gfx.drawRect(0, 0, uWidth, uHeight);
        gfx.endFill();
        gfx.lineStyle();
      }
      else if (borderWidth > 0) {
        gfx.lineStyle(borderWidth, border.colorInt, border.alpha);
        //gfx.drawRect(-borderWidth, -borderWidth, uWidth + (borderWidth * 2), uHeight + (borderWidth * 2));
        //gfx.drawRect(borderWidth, borderWidth, uWidth - (borderWidth * 2), uHeight - (borderWidth * 2));
        gfx.drawRect(0, 0, uWidth, uHeight);
        gfx.lineStyle();
      }
    }
  }

  private function set_margin(margin:Int):Int {
    this.margin = margin;
    redraw();
    return margin;
  }
}
