package cobraui.components;

import cobraui.components.Label;

import nme.events.MouseEvent;

class Selector<T> extends Label<T> {
  public var options(default, setOptions):Array<T>;
  public var selected(getSelected, setSelected):T;
  public var selectedIndex(default, setSelectedIndex):Int;

  public function new(options:Array<T>, ?defaultOption:Int = 0) {
    super(options[defaultOption], 0);

    this.options = options;
    this.selectedIndex = defaultOption;

    addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
  }

  private function mouseDown(event:MouseEvent) {
    selectedIndex++;
  }

  private function setOptions(o:Array<T>):Array<T> {
    options = o;
    selectedIndex = 0;
    return options;
  }

  private function getSelected():T {
    return options[selectedIndex];
  }

  private function setSelected(s:T):T {
    for (i in 0...options.length) {
      if (options[i] == s) {
        selectedIndex = i;
        break;
      }
    }
    return s;
  }

  private function setSelectedIndex(i:Int):Int {
    selectedIndex = i;
    if (selectedIndex >= options.length) {
      selectedIndex = 0;
    }

    content = options[selectedIndex];
    return selectedIndex;
  }

}
