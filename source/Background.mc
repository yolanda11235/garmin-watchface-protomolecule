import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;

class Background extends WatchUi.Drawable {

  var mBurnInProtectionMode;

  function initialize(params as Object) {
    Drawable.initialize(params);
    mBurnInProtectionMode = params[:burnInProtectionMode] && System.getDeviceSettings().requiresBurnInProtection;
  }

  function draw(dc) {
    // use single background color in burn in protection mode - Image otherwise
    if (mBurnInProtectionMode) {
      dc.setColor(Graphics.COLOR_TRANSPARENT, themeColor(Color.BACKGROUND));
      dc.clear();
    } else {
      var image = Application.loadResource( Rez.Drawables.background_image ) as BitmapResource;
      dc.drawBitmap( 0, 0, image );
    }
  }
}