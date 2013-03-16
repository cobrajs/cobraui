package cobraui.util;

// TODO: Add next/prev, directional finding, limiting finding by active popup

import nme.display.DisplayObject;
import nme.display.DisplayObjectContainer;
import nme.display.Sprite;

class NodeWalker {
  public static function getChildren(node:DisplayObjectContainer):Array<DisplayObject> {
    var ret = new Array<DisplayObject>();
    if (node.numChildren > 0) {
      for (i in 0...node.numChildren) {
        ret.push(node.getChildAt(i));
      }
    }
    return ret;
  }

  public static function getSiblings(node:DisplayObject):Array<DisplayObject> {
    var ret = new Array<DisplayObject>();
    if (node.parent != null && node.parent.numChildren > 1) {
      for (i in 0...node.parent.numChildren) {
        var child = node.parent.getChildAt(i);
        if (child != node) {
          ret.push(child);
        }
      }
    }
    return ret;
  }

  public static function findChildrenByClass(node:DisplayObjectContainer, type:Dynamic, ?deep = false, ?found:Array<DisplayObject>):Array<DisplayObject> {
    var ret = found == null ? new Array<DisplayObject>() : found;
    for (child in getChildren(node)) {
      if (Std.is(child, type)) {
        ret.push(child);
      }
      if (deep) {
        if (Std.is(child, DisplayObjectContainer)) {
          var childContainer = cast(child, DisplayObjectContainer);
          if (childContainer.numChildren > 0) {
            findChildrenByClass(childContainer, type, deep, ret);
          }
        }
      }
    }
    return ret;
  }

}
