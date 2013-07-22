package cobraui.popup;

import cobraui.layouts.Layout;
import cobraui.layouts.BorderLayout;
import cobraui.components.Component;
import cobraui.components.Label;
import cobraui.graphics.Color;
import cobraui.util.NodeWalker;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.events.MouseEvent;
import flash.events.Event;

import openfl.Assets;

class Popup extends Sprite {
  public static var nextId:Int = 0;
  private static var titleBarHeight:Int = 25;

  // In percent of screen
  private var pWidth:Float;
  private var pHeight:Float;
  
  // Calculated from percent
  private var uWidth:Float;
  private var uHeight:Float;

  private var window:Component;
  private var closeButton:Sprite;
  private var titleBar:Label<String>;
  private var overlay:Sprite;

  public var isActive:Bool;

  private var popupLayout:BorderLayout;
  public var layout:Layout;

  public var id:Int;

  private var addedToStage:Bool;
  private var needsResize:Bool;

  public function new(width:Float, height:Float, titleLabel:String, ?position:Int = -1, ?closeButton:Bool = true) {
    super();

    pWidth = width;
    pHeight = height;

    uWidth = 100; // Registry.stageWidth * pWidth;
    uHeight = 100; // Registry.stageHeight * pHeight;

    overlay = new Sprite();
    addChild(overlay);

    window = new Component();
    if (Component.themeFactory != null) {
      window.loadFromThemeFactory("window");
    }
    addChild(window);

    this.visible = false;
    isActive = false;

    if (closeButton) {
      this.closeButton = new Sprite();
      var tempBitmap = new Bitmap(Assets.getBitmapData("assets/close_button.png"));
      this.closeButton.addChild(tempBitmap);
      window.addChild(this.closeButton);
    }

    var hasTitleBar = false;
    if (titleLabel != "" && titleLabel != null) {
      hasTitleBar = true;
      titleBar = new Label<String>(titleLabel);
      titleBar.loadFromThemeFactory("titleBar");
      titleBar.hAlign = center;
      titleBar.y = -titleBarHeight;
      window.addChild(titleBar);
    }

    popupLayout = new BorderLayout(100, 100);
    popupLayout.assignComponent(window, position == -1 ? BorderLayout.MIDDLE : position, width, height, percent);

    id = ++nextId;

    needsResize = true;
    addedToStage = false;
    addEventListener(Event.ADDED_TO_STAGE, function(e:Event) {
      if (!addedToStage) {
        popupLayout.pack();

        if (hasTitleBar && position & BorderLayout.IS_TOP_EDGE != 0) {
          window.y += titleBarHeight;
        }
        if (this.closeButton != null) {
          this.closeButton.x = window.width;
        }

        sizeToStage();

        addedToStage = true;
      }
      stage.addEventListener(Event.RESIZE, function(e:Event) { 
        if (this.visible) {
          sizeToStage();
        } else {
          needsResize = true; 
        }
      });
    });

    addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
  }

  private function sizeToStage() {
    uWidth = stage.stageWidth * pWidth;
    uHeight = stage.stageHeight * pHeight;

    var gfx = overlay.graphics;
    gfx.clear();
    gfx.beginFill(0x555555, 0.5);
    gfx.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
    gfx.endFill();

    if (titleBar != null) {
      titleBar.resize(uWidth, 25);
    }

    popupLayout.resize(stage.stageWidth, stage.stageHeight);

    if (layout != null) {
      layout.resize(uWidth, uHeight);
    }

    needsResize = false;
  }

  public function popup() {
    if (needsResize) {
      sizeToStage();
    }
    this.visible = true;
    setActive(true);
  }

  public function hide():Void {
    this.visible = false;
    setActive(false);
  }

  public function setActive(active:Bool):Bool {
    this.isActive = active;
    if (stage != null) {
      if (active) {
        for (node in NodeWalker.findChildrenByClass(stage, Popup, true)) {
          var popupNode = cast(node, Popup);
          if (node != this) {
            popupNode.isActive = false;
          }
        }
      } else {
        for (node in NodeWalker.findChildrenByClass(stage, Popup, true)) {
          var popupNode = cast(node, Popup);
          if (node.visible) {
            popupNode.isActive = true;
          }
        }
      }
    }
    return active;
  }

  private function onMouseUp(event:MouseEvent) {
    if (event.target == closeButton) {
      this.visible = false;
    }
  }
}
