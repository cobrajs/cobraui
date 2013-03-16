package cobraui.popup;

import cobraui.popup.Popup;
import cobraui.popup.PopupEvent;

import cobraui.components.Label;
import cobraui.components.Container;
import cobraui.components.SimpleButton;
import cobraui.components.TextInput;

import cobraui.layouts.GridLayout;
import cobraui.layouts.BorderLayout;

import nme.events.MouseEvent;

class PromptPopup extends Popup {
  public static var TYPE:String = "promptpopup";

  private var value:String;
  private var message:String;

  private var textBox:TextInput;
  private var buttons:Container;

  public function new(defaultText:String, ?titleLabel:String) {
    super(0.7, 0.3, titleLabel != null ? titleLabel : "Prompt", 
#if (android)
        BorderLayout.TOP, 
#else
        BorderLayout.MIDDLE, 
#end
        false);

    layout = new BorderLayout(uWidth, uHeight);

    buttons = new Container();
    buttons.layout = new GridLayout(10, 10, 0, 1);
    var tempButton:SimpleButton<String> = null;
    var messageAndClose = function(message:String) {
      dispatchEvent(new PopupEvent(PopupEvent.MESSAGE, message, id));
      dispatchEvent(new PopupEvent(PopupEvent.CLOSED, TYPE, id));
      this.hide();
    };

    tempButton = new SimpleButton<String>("Ok");
    tempButton.onClick = function(event:MouseEvent) {
      messageAndClose(textBox.content);
    }
    buttons.addChild(tempButton);
    buttons.layout.addComponent(tempButton);
    tempButton = new SimpleButton<String>("Cancel");
    tempButton.onClick = function(event:MouseEvent) {
      messageAndClose("");
    }
    buttons.addChild(tempButton);
    buttons.layout.addComponent(tempButton);

    window.addChild(buttons);
    buttons.layout.pack();

    layout.assignComponent(buttons, BorderLayout.BOTTOM_RIGHT, 1, 0.3, percent);
    textBox = new TextInput(defaultText);
    //textBox.hAlign = center;
    window.addChild(textBox);
    layout.assignComponent(textBox, BorderLayout.TOP_RIGHT, 1, 0.7, percent);
    layout.pack();
  }

  override public function popup() {
    super.popup();
    textBox.activate();
  }

  override public function hide() {
    super.hide();
    textBox.deactivate();
  }

  public function addAllowed(allowed:EReg) {
    textBox.allowed = allowed;
  }

}

