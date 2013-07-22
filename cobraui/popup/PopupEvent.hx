package cobraui.popup;

import flash.events.Event;

class PopupEvent extends Event {
  public static var MESSAGE:String = "PopupMessageEvent";
  public static var CLOSED:String = "PopupClosedEvent";
  public var message:String;
  public var id:Int;
  public function new(label:String, message:String, id:Int, ?bubbles:Bool = true, ?cancelable:Bool = false) {
    super(label, bubbles, cancelable);
    this.message = message;
    this.id = id;
  }
}
