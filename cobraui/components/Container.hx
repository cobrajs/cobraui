package cobraui.components;

import cobraui.components.Component;
import cobraui.layouts.Layout;

class Container extends Component {
  public var layout:Layout;

  public function new() {
    super();

    background = null;
  }

  override public function resize(width:Float, height:Float) {
    super.resize(width, height);

    layout.resize(width, height);
  }
}
