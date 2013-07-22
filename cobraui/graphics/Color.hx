package cobraui.graphics;

import flash.display.BitmapData;
import flash.geom.ColorTransform;

class Color {
  public static var transparent:Int = 0x00000000;
  
  public var colorInt:Int;
  public var alpha:Int;
  public var colorARGB (get, set):Int;
  public var r (get, set):Int;
  public var g (get, set):Int;
  public var b (get, set):Int;

  public static function getARGB(color:Int, alpha:Int):Int {
    return (alpha << 24) | color;
  }
  
  public static function getAlpha(color:Int):Int {
    return color >> 24;
  }

  public static function generateTransform(color:Int) {
    return 
      new ColorTransform(1, 1, 1, 1,
        (color & (0xFF << 16)) >> 16, // R
        (color & (0xFF << 8)) >> 8,   // G
        color & 0xFF                  // B
      );
  }

  public static function stringToColor(color:String, ?parts:Int = 3) {
    if (color.length != parts * 2) {
      throw "Invalid color for part size";
    }

    var retColor:Int = 0;
    var use:Int = 0, charCode:Int = 0;
    var max:Int = parts * 2;
    for (i in 0...max) {
      // Walk backwards through string since the numbers work the other way (or something)
      charCode = color.charCodeAt(max - 1 - i);
      if (charCode >= 48 && charCode <= 57) {
        use = charCode - 48;
      }
      else if (charCode >= 65 && charCode <= 70) {
        use = charCode - 65 + 10;
      }
      else if (charCode >= 97 && charCode <= 102) {
        use = charCode - 97 + 10;
      }
      retColor |= use << (i * 4);
    }
    
    return retColor;
  }

  public static function lookupColor(colorName:String):Int {
    switch(colorName) {
      case 'white':
        return 0xFFFFFF;
      case 'gray', 'grey':
        return 0x777777;
      case 'black':
        return 0x000000;
      default:
        return -1;
    }
  }

  //
  // Instance methods
  //

  public function new(colorVal:Dynamic, ?alpha:Int = 0xFF) {
    if (Std.is(colorVal, Int) || Std.is(colorVal, Float)) {
      this.colorInt = colorVal;
    } else if (Std.is(colorVal, String)) {
      this.colorInt = Color.lookupColor(colorVal);
      if (this.colorInt == -1) {
        this.colorInt = Color.stringToColor(colorVal);
      }
    } else {
      throw "Invalid type passed to Color. Should be Int or String";
    }
    this.alpha = alpha;
  }

  //
  // Property getter/setters
  // 
  
  private function get_colorARGB():Int {
    return Color.getARGB(this.colorInt, this.alpha);
  }

  private function set_colorARGB(color:Int):Int {
    // Int: 0xAARRGGBB
    this.alpha = color >> 24;
    this.colorInt = color & (0xFFFFFF);
    return color;
  }

  // Individual Color Components
  private function get_r():Int {
    return (colorInt & (0xFF0000)) >> 16;
  }
  private function set_r(color:Int):Int {
    colorInt &= 0x00FFFF;
    colorInt |= color << 16;
    return color;
  }

  private function get_g():Int {
    return (colorInt & (0xFF00)) >> 8;
  }
  private function set_g(color:Int):Int {
    colorInt &= 0xFF00FF;
    colorInt |= color << 8;
    return color;
  }

  private function get_b():Int {
    return (colorInt & (0xFF));
  }
  private function set_b(color:Int):Int {
    colorInt &= 0xFFFF00;
    colorInt |= color;
    return color;
  }

  public function toHexString():String {
    return StringTools.hex(colorInt);
  }

  public function update(colorVal:Dynamic) {
    if (Std.is(colorVal, Int) || Std.is(colorVal, Float)) {
      this.colorInt = colorVal;
    } else if (Std.is(colorVal, String)) {
      this.colorInt = Color.lookupColor(colorVal);
      if (this.colorInt == -1) {
        this.colorInt = Color.stringToColor(colorVal);
      }
    } else {
      throw "Invalid type passed to Color. Should be Int or String";
    }
  }
}
