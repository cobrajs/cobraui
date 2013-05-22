package cobraui.util;

// TODO: Convert to Component to allow use with BorderLayout

import nme.display.DisplayObject;
import nme.display.Sprite;
import nme.display.Shape;
import nme.geom.Rectangle;
import nme.geom.Point;
import nme.events.Event;
import nme.events.MouseEvent;

class ScrollBox extends Sprite {
  private static var SCROLLWIDTH:Int = 20;
  public var scrollBox:Sprite;
  private var scrollBoxRect:Rectangle;
  private var originClick:Point;
  private var originPoint:Point;
  private var scrollTolerance:Int;
  private var checkTolerance:Bool;

  private var scrollIndicator:Shape;

  // Interval so the scrolling doesn't update as often
  private var counter:Int;
  private var checkInterval:Int;

  public function new(width:Int, height:Int, ?scrollTolerance:Int = 5) {
    super();
    scrollBox = new Sprite();
    addChild(scrollBox);

    scrollBoxRect = new Rectangle(0, 0, width, height);
    refreshScrollRect();

    this.scrollTolerance = scrollTolerance;
    this.checkTolerance  = true;

    scrollIndicator = new Shape();
    var scrollHeight = height * 0.2;
    var gfx = scrollIndicator.graphics;
    gfx.beginFill(0xDDDDDD);
    gfx.drawRect(0, 0, SCROLLWIDTH, scrollHeight / 2);
    gfx.endFill();
    gfx.beginFill(0x888888);
    gfx.drawRect(0, scrollHeight / 2, SCROLLWIDTH, scrollHeight / 2);
    gfx.endFill();
    scrollIndicator.x = width - SCROLLWIDTH;
    scrollIndicator.y = 0;
    scrollIndicator.visible = false;
    addChild(scrollIndicator);

    counter = 0;
    checkInterval = 10;

    addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
    addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

    addEventListener(Event.ADDED_TO_STAGE, addedToStage);
  }

  public function scrollTop() {
    scrollBoxRect.y = 0;
    refreshScrollRect();
  }

  private function addedToStage(event:Event) {
    stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
  }

  private function refreshScrollRect():Void {
    scrollBox.scrollRect = scrollBoxRect;
  }

  private function onMouseDown(event:MouseEvent) {
    originClick = new Point(event.stageX, event.stageY);
    originPoint = new Point(scrollBoxRect.x, scrollBoxRect.y);
  }

  private function onMouseMove(event:MouseEvent) {
    if (originClick != null && counter % checkInterval == 0) {
      var diff = originClick.y - event.stageY;
      if (!checkTolerance || (checkTolerance && Math.abs(diff) > scrollTolerance)) {
        scrollBoxRect.y = originPoint.y + diff;
        if (scrollBoxRect.y < 0) {
          scrollBoxRect.y = 0;
        }
        else if (scrollBoxRect.y + scrollBoxRect.height > scrollBox.height) {
          scrollBoxRect.y = scrollBox.height - scrollBoxRect.height;
        }
        scrollIndicator.y = (scrollBoxRect.height - scrollIndicator.height) * (scrollBoxRect.y / (scrollBox.height - scrollBoxRect.height));
        refreshScrollRect();

        if (checkTolerance) {
          scrollIndicator.visible = true;
          dispatchEvent(new Event(Event.SCROLL));
        }
        checkTolerance = false;
      }
    }
    counter++;
  }

  private function onMouseUp(event:MouseEvent) {
    originClick = null;
    originPoint = null;
    checkTolerance = true;
    scrollIndicator.visible = false;
  }

  public function resize(width:Float, height:Float) {
    scrollBoxRect.width = width;
    scrollBoxRect.height = height;
    scrollIndicator.x = width - SCROLLWIDTH;
    refreshScrollRect();
  }
}
