import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;

class Background extends WatchUi.Drawable {

  function initialize(params as Object) {
    Drawable.initialize(params);
  }

  function draw(dc) {
    // Draw the background image
    var image = Application.loadResource( Rez.Drawables.background_image ) as BitmapResource;
    dc.drawBitmap( 0, 0, image );
  }
}