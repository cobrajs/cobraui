package cobraui.components;

import cobraui.components.Component;
import cobraui.components.Container;
import cobraui.components.Label;

import cobraui.layouts.BorderLayout;

class LabeledComponent extends Container {
  public var component:Component;
  public var label:Label;
  public var labelText:String;

  public function new(labelText:String, component:Component, ?labelPercent:Float = 0.3) {
    layout = new BorderLayout(10, 10);

    this.labelText = labelText;
    label = new Label<String>(labelText);
    label.hAlign = center;
    label.vAlign = middle;

    layout.assignComponent(label, BorderLayout.LEFT, labelPercent, 1, percent);
    addChild(label);

    this.component = component;
    layout.assignComponent(component, BorderLayout.RIGHT, 1 - labelPercent, 1, percent);
    addChild(component);

    layout.pack();
  }
}

