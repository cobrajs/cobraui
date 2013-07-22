package cobraui.util;

import flash.events.Event;
import flash.events.TouchEvent;
import flash.ui.Multitouch;
import flash.geom.Point;

class TouchManager {
  // Touch Gesture stuff
  public var threshold:Int;
  public var originPoint:Point;

  public var originPoints:Map<Int,Point>;
  public var touchPoints:Map<Int,Point>;
  public var touchCount:Int;
  public var lastPointID:Int;

  public var wasZooming:Bool;
  public var newScale:Float;
  public var translateX:Float;
  public var translateY:Float;

  private inline function checkCurrent(event:Event) {
    return event.target != event.currentTarget;
  }

  public function new() {
    originPoints = new Map<Int,Point>();
    touchPoints = new Map<Int,Point>();
    touchCount = 0;
    wasZooming = false;
  }

  public function onTouchBegin(event:TouchEvent) {
    if (checkCurrent(event)) {
      return;
    }

    if (touchCount < 2) {
      originPoints.set(event.touchPointID, new Point(event.stageX, event.stageY));
      touchPoints.set(event.touchPointID, new Point(event.stageX, event.stageY));
      lastPointID = event.touchPointID;
      touchCount++;
    }
  }

  public function onTouchMove(event:TouchEvent) {
    if (checkCurrent(event)) {
      return;
    }

    if (touchPoints.exists(event.touchPointID)) {
      var point = touchPoints.get(event.touchPointID);
      point.x = event.stageX;
      point.y = event.stageY;

      if (touchCount == 2) {
        var dif:Float = 0;
        var firstKey = -1;
        var secondKey = -1;
        for (key in touchPoints.keys()) {
          if (firstKey == -1) {
            firstKey = key;
            continue;
          } else if (secondKey == -1) {
            secondKey = key;
            break;
          }
        }
        var originDist = Point.distance(originPoints.get(firstKey), originPoints.get(secondKey));
        var newDist    = Point.distance(touchPoints.get(firstKey), touchPoints.get(secondKey));

        newScale = 1 + (newDist - originDist) / 100;

        var trans1x = touchPoints.get(firstKey).x - originPoints.get(firstKey).x;
        var trans1y = touchPoints.get(firstKey).y - originPoints.get(firstKey).y;
        var trans2x = touchPoints.get(secondKey).x - originPoints.get(secondKey).x;
        var trans2y = touchPoints.get(secondKey).y - originPoints.get(secondKey).y;
        translateX = (trans1x + trans2x) / 2;
        translateY = (trans1y + trans2y) / 2; 

        wasZooming = true;
      }

      var point = originPoints.get(event.touchPointID);
      point.x = event.stageX;
      point.y = event.stageY;
    }
  }

  public function onTouchEnd(event:TouchEvent):Void {
    if (checkCurrent(event)) {
      return;
    }

    if (touchPoints.exists(event.touchPointID)) {
      touchPoints.remove(event.touchPointID);
      originPoints.remove(event.touchPointID);
      touchCount--;

      if (touchCount == 0) {
        wasZooming = false;
      }
    }

  }

}
