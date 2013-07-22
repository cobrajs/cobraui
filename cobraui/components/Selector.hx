package cobraui.components;

import cobraui.components.Label;

import flash.events.MouseEvent;
import flash.events.Event;

class Selector<T> extends Label<T> {
  public var options (default, set):Array<T>;
  public var selected (get, set):T;
  public var selectedIndex (default, set):Int;

  public function new(options:Array<T>, ?defaultOption:Int = 0) {
    super(options[defaultOption], 0);

    this.options = options;
    this.selectedIndex = defaultOption;

    addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
  }

  private function mouseDown(event:MouseEvent) {
    selectedIndex++;
    dispatchEvent(new Event(Event.CHANGE));
  }

  private function set_options(o:Array<T>):Array<T> {
    options = o;
    selectedIndex = 0;
    return options;
  }

  private function get_selected():T {
    return options[selectedIndex];
  }

  private function set_selected(s:T):T {
    for (i in 0...options.length) {
      if (options[i] == s) {
        selectedIndex = i;
        break;
      }
    }
    return s;
  }

  private function set_selectedIndex(i:Int):Int {
    selectedIndex = i;
    if (selectedIndex >= options.length) {
      selectedIndex = 0;
    }

    content = options[selectedIndex];
    return selectedIndex;
  }

}
