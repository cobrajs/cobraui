package cobraui.graphics;

import cobraui.graphics.Color;

import flash.display.BitmapData;

class ImageOpts {
  public static function keyBitmapData(imageData:BitmapData, ?colorKey:Int = 0xFF00FF) {
    imageData.lock();
    for (y in 0...Math.floor(imageData.height)) {
      for (x in 0...Math.floor(imageData.width)) {
        if (imageData.getPixel(x, y) == colorKey) {
          imageData.setPixel32(x, y, Color.transparent);
        }
      }
    }
    imageData.unlock();
  }

  public static function flipImageData(imageData:BitmapData, ?xFlip:Bool = true, ?yFlip:Bool = false):BitmapData {
    var tempData = new BitmapData(imageData.width, imageData.height, true);

    var xMin = xFlip ? imageData.width - 1 : 0;
    var xMax = xFlip ? -1 : imageData.width;
    var xInc = xFlip ? -1 : 1;
    var yMin = yFlip ? imageData.height - 1 : 0;
    var yMax = yFlip ? -1 : imageData.height;
    var yInc = yFlip ? -1 : 1;

    var sX = 0;
    var sY = 0;
    var x = xMin;
    var y = yMin;

    var checkX = xFlip ? function(x){return x>xMax;} : function(x){return x<xMax;};
    var checkY = yFlip ? function(y){return y>yMax;} : function(y){return y<yMax;};

    while(checkY(y)) {
      sX = 0;
      x = xMin;
      while(checkX(x)) {
        tempData.setPixel32(sX, sY, imageData.getPixel32(x, y));
        x += xInc;
        sX++;
      }
      y += yInc;
      sY++;
    }

    return tempData;
  }

  public static function rotateImageData(imageData:BitmapData, ?dir:Int = 90):BitmapData {
    var tempData = new BitmapData(imageData.width, imageData.height, true);

    var transformX = 
      dir == 90 ?   function(x, y) { return imageData.width - y - 1; } :
      dir == 180 ?  function(x, y) { return imageData.width - x - 1; } :
      /*     270 */ function(x, y) { return y; };

    var transformY = 
      dir == 90 ?   function(x, y) { return x; } :
      dir == 180 ?  function(x, y) { return imageData.height - y - 1; } :
      /*     270 */ function(x, y) { return imageData.height - x - 1; };

    for (y in 0...imageData.height) {
      for (x in 0...imageData.width) {
        tempData.setPixel32(transformX(x, y), transformY(x, y), imageData.getPixel32(x, y));
      }
    }

    return tempData;
  }
}
