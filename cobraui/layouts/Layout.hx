package cobraui.layouts;

import cobraui.components.Component;

enum SizeType {
  pixel;
  percent;
}

class Layout {
  public var width (default, null):Float;
  public var height (default, null):Float;
  public var components (default, null):Array<Component>;
  public var packed:Bool;

  public var paddingX:Float;
  public var paddingY:Float;

  public function new(width:Float, height:Float) {
    components = new Array<Component>();

    this.width = width;
    this.height = height;

    this.paddingX = 0;
    this.paddingY = 0;

    packed = false;
  }

  public function addComponent(component:Component) {
    if (!packed) {
      components.push(component);
    }
    else {
      throw "No components may be added after packing";
    }
  }

  public function assignComponent(component:Component, position:Int, width:Float, height:Float, type:SizeType, ?customFunc:Void->Void) {
  }

  public function pack() {
    packed = true;
  }

  public function resize(width:Float, height:Float) {
    this.width = width;
    this.height = height;
    if (packed) {
      pack();
    }
  }
}

