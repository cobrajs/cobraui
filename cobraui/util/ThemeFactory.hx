package cobraui.util;

import cobraui.graphics.Color;

import openfl.Assets;

class ThemeFactory {
  private var themeText:String;
  private var colors:Map<String,Map<String,Color>>;
  private var sizing:Map<String,Map<String,Int>>;

  public function new(themeFileName:String) {
    themeText = Assets.getText("assets/" + themeFileName);
    if (themeText == null) {
      throw "Could not load theme file: " + themeFileName;
    }

    colors = new Map<String,Map<String,Color>>();
    sizing = new Map<String,Map<String,Int>>();

    var styleLine:EReg = ~/^\s+([^:\s]*)\s*:\s*(.*)$/;
    var ignoreLine:EReg = ~/^\s*$|^#/;
    var currentType:String = "";

    for (line in themeText.split("\n")) {
      if (!ignoreLine.match(line)) {
        if (styleLine.match(line)) {
          if (currentType != "") {
            var name = styleLine.matched(1);
            var value = styleLine.matched(2);
            // Colors begin with #
            if (value.charAt(0) == "#") {
              value = value.substr(1);
              var tempColor = new Color(value);
              var tempMap:Map<String,Color> = null;
              if (colors.exists(currentType)) {
                tempMap = colors.get(currentType);
              } else {
                tempMap = new Map<String,Color>();
                colors.set(currentType, tempMap);
              }
              tempMap.set(name, tempColor);
            } else {
              var tempInt = Std.parseInt(value);
              var tempMap:Map<String,Int> = null;
              if (sizing.exists(currentType)) {
                tempMap = sizing.get(currentType);
              } else {
                tempMap = new Map<String,Int>();
                sizing.set(currentType, tempMap);
              }
              tempMap.set(name, tempInt);
            }
          }
        } else {
          currentType = StringTools.trim(line);
        }
      }
    }
  }

  public function getColor(type:String, name:String):Color {
    if (colors.exists(type)) {
      var tempColors:Map<String,Color> = colors.get(type);
      if (tempColors.exists(name)) {
        return tempColors.get(name);
      }
    }
    return null;
  }

  public function getSizing(type:String, name:String):Int {
    if (sizing.exists(type)) {
      var tempSizing:Map<String,Int> = sizing.get(type);
      if (tempSizing.exists(name)) {
        return tempSizing.get(name);
      }
    }
    return -1;
  }
}
