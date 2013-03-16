package cobraui.util;

import cobraui.graphics.Color;

import nme.Assets;

class ThemeFactory {
  private var themeText:String;
  private var colors:Hash<Hash<Color>>;
  private var sizing:Hash<Hash<Int>>;

  public function new(themeFileName:String) {
    themeText = Assets.getText("assets/" + themeFileName);
    if (themeText == null) {
      throw "Could not load theme file: " + themeFileName;
    }

    colors = new Hash<Hash<Color>>();
    sizing = new Hash<Hash<Int>>();

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
              var tempHash:Hash<Color> = null;
              if (colors.exists(currentType)) {
                tempHash = colors.get(currentType);
              } else {
                tempHash = new Hash<Color>();
                colors.set(currentType, tempHash);
              }
              tempHash.set(name, tempColor);
            } else {
              var tempInt = Std.parseInt(value);
              var tempHash:Hash<Int> = null;
              if (sizing.exists(currentType)) {
                tempHash = sizing.get(currentType);
              } else {
                tempHash = new Hash<Int>();
                sizing.set(currentType, tempHash);
              }
              tempHash.set(name, tempInt);
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
      var tempColors:Hash<Color> = colors.get(type);
      if (tempColors.exists(name)) {
        return tempColors.get(name);
      }
    }
    return null;
  }

  public function getSizing(type:String, name:String):Int {
    if (sizing.exists(type)) {
      var tempSizing:Hash<Int> = sizing.get(type);
      if (tempSizing.exists(name)) {
        return tempSizing.get(name);
      }
    }
    return -1;
  }
}
