package cobraui.util;

import cobraui.util.NodeWalker;

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

class Navigator extends Sprite {
  private var leftArrow:Shape;
  private var rightArrow:Shape;
  public var currentNode (default, set):DisplayObject;
  public var currentNodeIndex (default, null):Int;
  public var currentNodeList:Array<DisplayObject>;

  public function new(startNode:DisplayObject) {
    super();

    currentNode = startNode;
    currentNodeList = NodeWalker.getSiblings(currentNode);
    currentNodeIndex = Lambda.indexOf(currentNodeList, currentNode);

    leftArrow = new Shape();
    rightArrow = new Shape();
    drawArrows(20, 20);
    addChild(leftArrow);
    addChild(rightArrow);
    moveArrows();
  }

  public function nextNode() {
    if (currentNodeIndex < currentNodeList.length - 1) {
      currentNode = currentNodeList[++currentNodeIndex];
    } else {
      currentNode = currentNodeList[currentNodeIndex = 0];
    }
    moveArrows();
  }

  public function previousNode() {
    if (currentNodeIndex > 0) {
      currentNode = currentNodeList[--currentNodeIndex];
    } else {
      currentNode = currentNodeList[currentNodeIndex = currentNodeList.length - 1];
    }
    moveArrows();
  }

  public function clickNode() {
    var downEvent = new MouseEvent(MouseEvent.MOUSE_DOWN, false, false, currentNode.width / 2, currentNode.height / 2);
    var upEvent = new MouseEvent(MouseEvent.MOUSE_UP, false, false, currentNode.width / 2, currentNode.height / 2);
    currentNode.dispatchEvent(downEvent);
    currentNode.dispatchEvent(upEvent);
  }

  private function moveArrows() {
    var pos = new Point(currentNode.x, currentNode.y);
    this.x = pos.x;
    this.y = pos.y;
    leftArrow.x = 0;
    leftArrow.y = currentNode.height / 2;

    rightArrow.x = currentNode.width;
    rightArrow.y = currentNode.height / 2;
  }

  private function set_currentNode(node:DisplayObject):DisplayObject {
    currentNode = node;
    return node;
  }

  private function drawArrows(arrowWidth:Int, arrowHeight:Int) {
    var gfx = leftArrow.graphics;
    gfx.clear();
    gfx.lineStyle(2, 0x000000);
    gfx.beginFill(0xFFFFFF);
    gfx.moveTo(0, 0);
    gfx.lineTo(-arrowWidth, -arrowHeight / 2);
    gfx.lineTo(-arrowWidth, arrowHeight / 2);
    gfx.lineTo(0, 0);
    gfx.endFill();
    gfx.lineStyle();

    gfx = rightArrow.graphics;
    gfx.clear();
    gfx.lineStyle(2, 0x000000);
    gfx.beginFill(0xFFFFFF);
    gfx.moveTo(0, 0);
    gfx.lineTo(arrowWidth, -arrowHeight / 2);
    gfx.lineTo(arrowWidth, arrowHeight / 2);
    gfx.lineTo(0, 0);
    gfx.endFill();
    gfx.lineStyle();
  }
}
