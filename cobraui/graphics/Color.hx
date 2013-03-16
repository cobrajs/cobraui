package cobraui.graphics;

import nme.display.BitmapInt32;
import nme.display.BitmapData;
import nme.geom.ColorTransform;

class Color {
#if neko
  public static var transparent:BitmapInt32 = {rgb: 0x000000, a: 0x00};
#else
  public static var transparent:BitmapInt32 = 0x00000000;
#end
  
  public var colorInt:Int;
  public var alpha:Int;
  public var colorARGB(getARGBcolor, setARGBcolor):BitmapInt32;
  public var r(getR, setR):Int;
  public var g(getG, setG):Int;
  public var b(getB, setB):Int;

  public static function getARGB(color:Int, alpha:Int):BitmapInt32 {
#if neko
    return {rgb: color, a:alpha};
#else
    return (alpha << 24) | color;
#end
  }
  
  public static function getAlpha(color:BitmapInt32):Int {
#if neko
    return color.a;
#else
    return color >> 24;
#end
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
  
  private function getARGBcolor():BitmapInt32 {
    return Color.getARGB(this.colorInt, this.alpha);
  }

  private function setARGBcolor(color:BitmapInt32):BitmapInt32 {
#if neko
    // BitmapInt32: {rgb: rgb, a: a}
    this.colorInt = color.rgb;
    this.alpha = color.a;
#else
    // BitmapInt: 0xAARRGGBB
    this.alpha = color >> 24;
    this.colorInt = color & (0xFFFFFF);
#end
    return color;
  }

  // Individual Color Components
  private function getR():Int {
    return (colorInt & (0xFF0000)) >> 16;
  }
  private function setR(color:Int):Int {
    colorInt &= 0x00FFFF;
    colorInt |= color << 16;
    return color;
  }

  private function getG():Int {
    return (colorInt & (0xFF00)) >> 8;
  }
  private function setG(color:Int):Int {
    colorInt &= 0xFF00FF;
    colorInt |= color << 8;
    return color;
  }

  private function getB():Int {
    return (colorInt & (0xFF));
  }
  private function setB(color:Int):Int {
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
