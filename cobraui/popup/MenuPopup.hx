package cobraui.popup;

import cobraui.popup.Popup;
import cobraui.popup.PopupEvent;

import cobraui.components.Label;
import cobraui.components.Component;

import cobraui.layouts.GridLayout;
import cobraui.layouts.BorderLayout;

import flash.events.MouseEvent;

class MenuPopup extends Popup {
  public static var TYPE:String = "menupopup";

  public function new(?sizeX:Int = 0, ?sizeY:Int = 1) {
    super(1, 0.3, "", BorderLayout.BOTTOM, false);

    layout = new GridLayout(uWidth, uHeight, sizeX, sizeY);
  }

  public function addComponent(c:Component) {
    window.addChild(c);
    layout.addComponent(c);
  }

  override public function popup() {
    super.popup();
  }

  override public function onMouseUp(event:MouseEvent) {
    if (event.target == overlay) {
      hide();
    }
  }

  override public function hide() {
    super.hide();
    dispatchEvent(new PopupEvent(PopupEvent.CLOSED, TYPE, this.id, true));
  }
}
