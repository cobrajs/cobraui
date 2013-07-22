package cobraui.graphics;

import cobraui.graphics.ImageOpts;

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

class Tilesheet {
  private var data:BitmapData;
  public var rects (default, null):Array<Rectangle>;
  public var tilesX (default, null):Int;
  public var tilesY (default, null):Int;
  public var tileWidth (default, null):Float;
  public var tileHeight (default, null):Float;

  public function new(imageData:BitmapData, ?tilesX:Int = 0, ?tilesY:Int = 0) {
    this.tilesX = tilesX;
    this.tilesY = tilesY;

    data = new BitmapData(imageData.width, imageData.height, true);
    data.copyPixels(imageData, new Rectangle(0, 0, imageData.width, imageData.height), new Point(0, 0), null, null, true);
    ImageOpts.keyBitmapData(data);

    rects = new Array<Rectangle>();

    // Autochopping
    if (tilesX != 0 && tilesY != 0) {
      tileWidth = imageData.width / tilesX;
      tileHeight = imageData.height / tilesY;
      for (y in 0...tilesY) {
        for (x in 0...tilesX) {
          addTileRect(new Rectangle(x * tileWidth, y * tileHeight, tileWidth, tileHeight));
        }
      }
    }
  }

  public function addTileRect(rect:Rectangle) {
    rects.push(rect);
  }

  public function drawTiles(gfx:Graphics, tileData:Array<Float>) {
    for (i in 0...tileData.length) {
      if (i % 3 == 0) {
        var x = Std.int(tileData[i]);
        var y = Std.int(tileData[i + 1]);
        var tileIndex = Std.int(tileData[i + 2]);
        var rect = rects[tileIndex];
        gfx.beginBitmapFill(data, new Matrix(1, 0, 0, 1, -rect.x + x, -rect.y + y));
        gfx.drawRect(x, y, rect.width, rect.height);
        gfx.endFill();
      }
    }
  }
  
  public function drawTilesBitmapData(drawTo:BitmapData, tileData:Array<Float>) {
    for (i in 0...tileData.length) {
      if (i % 3 == 0) {
        var x = tileData[i];
        var y = tileData[i + 1];
        var tileIndex = Std.int(tileData[i + 2]);
        var rect = rects[tileIndex];
        drawTo.copyPixels(data, rect, new Point(x, y), null, null, true);
      }
    }
  }

  public function drawTile(graphics:Graphics, x:Float, y:Float, tileIndex:Int) {
    drawTiles(graphics, [x, y, tileIndex]);
  }

  public function drawTileBitmapData(drawTo:BitmapData, x:Float, y:Float, tileIndex:Int) {
    drawTilesBitmapData(drawTo, [x, y, tileIndex]);
  }
}
