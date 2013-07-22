package cobraui.components;

import cobraui.graphics.Color;
import cobraui.components.Container;
import cobraui.components.SimpleButton;
import cobraui.components.Label;
import cobraui.layouts.BorderLayout;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Multitouch;

class Slider extends Container {
  private var value:Int;
  private var oldValue:Int;

  public var minimum:Int;
  public var maximum:Int;
  public var step:Int;

  private var slider:Component;
  private var dragging:Bool;
  private var sliderBackground:Component;

  private var startDragPos:Point;
  private var sliderStartX:Float;

  private var valueLabel:Label<String>;

  public function new(minimum:Int, maximum:Int, ?defaultValue:Int, ?step:Int = 1) {
    this.minimum = minimum;
    this.maximum = maximum;
    this.step = step;

    super();

    layout = new BorderLayout(10, 10);

    startDragPos = new Point(0, 0);

    sliderBackground = new Component();
    sliderBackground.borderWidth = 2;
    sliderBackground.background = new Color(0xCCCCCC);
    addChild(sliderBackground);
    var sliderBackgroundPercent:Float = 0.7;
    layout.assignComponent(sliderBackground, BorderLayout.RIGHT, sliderBackgroundPercent, 1, percent);

    slider = new Component();
    slider.borderWidth = 2;
    sliderBackground.addChild(slider);
    layout.assignComponent(slider, BorderLayout.CUSTOM, 0.2, 1, percent, function() {
      slider.x = ((value - minimum) * ((this.uWidth * sliderBackgroundPercent) - slider.uWidth)) / (maximum - minimum);
    });
    slider.mouseEnabled = false;

    dragging = false;

    sliderBackground.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent) {
      startDragPos.x = e.stageX;
      startDragPos.y = e.stageY;

      sliderStartX = slider.x;

      dragging = true;
    });

    sliderBackground.addEventListener(MouseEvent.MOUSE_MOVE, function(e:MouseEvent) {
      if (dragging) {
        var newPos = sliderStartX + (e.stageX - startDragPos.x);

        if (newPos <= 0) {
          newPos = 0;
        }
        if (newPos >= sliderBackground.uWidth - slider.uWidth) {
          newPos = sliderBackground.uWidth - slider.uWidth;
        }

        var stepWidth = ((sliderBackground.uWidth - slider.uWidth) / ((maximum - minimum) / step));

        newPos = Std.int(newPos / stepWidth) * stepWidth;

        slider.x = newPos;

        var tempValue = minimum + Std.int(slider.x / stepWidth);
        if (tempValue != oldValue) {
          value = tempValue;
          oldValue = value;
          updateLabel(value);
          dispatchEvent(new Event(Event.CHANGE));
        }
      }
    });

    var stopDragging = function(e:MouseEvent) {
      startDragPos.x = 0;
      startDragPos.y = 0;

      dragging = false;
    };

    sliderBackground.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
    sliderBackground.addEventListener(MouseEvent.MOUSE_OUT, stopDragging);

    if (Multitouch.supportsTouchEvents) {
      slider.addEventListener(TouchEvent.TOUCH_OUT, stopDragging);
    }

    valueLabel = new Label<String>("");
    valueLabel.background = new Color(0xAAAAAA);
    valueLabel.hAlign = center;
    valueLabel.borderWidth = 2;
    addChild(valueLabel);
    layout.assignComponent(valueLabel, BorderLayout.LEFT, 0.3, 1, percent);
    
    setValue(defaultValue == null ? Std.int((maximum - minimum) / step / 2) * step : defaultValue);

    layout.pack();
  }

  private function updateLabel(value:Int) {
    valueLabel.content = Std.string(value);
  }

  public function setValue(value:Int):Int {
    this.value = value;
    updateLabel(value);
    var stepWidth = ((sliderBackground.uWidth - slider.uWidth) / ((maximum - minimum) / step));
    slider.x = stepWidth * (value - minimum);
    return value;
  }

  public function getValue():Int {
    return value;
  }
}
