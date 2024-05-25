import Toybox.Graphics;
import Toybox.Math;
import Toybox.WatchUi;
import Toybox.Lang;

class ProgressBarDataField extends DataFieldDrawable {
  hidden var mShowIcon;

  (:typecheck(false))
  function initialize(params) {
    DataFieldDrawable.initialize(params);
    mShowIcon = params[:showIcon];
    locX = params[:x];
    locY = params[:y];
    width = params[:width];
  }

  function draw(dc) {
    DataFieldDrawable.draw(dc);
    if (mLastInfo != null) {
      update(dc);
    }
  }

  function update(dc) {
    setClippingRegion(dc, Settings.get("strokeWidth"));
    setAntiAlias(dc, true);
    dc.setPenWidth(Settings.get("strokeWidth"));
    if (mLastInfo.progress > 1.0) {
      mLastInfo.progress = 1.0;
    }
    drawRemainingArc(dc, mLastInfo.progress);
    drawProgressArc(dc, mLastInfo.progress);

    if (mShowIcon) {
      if (mLastInfo.progress == 0) {
        dc.setColor(themeColor(Color.TEXT_INACTIVE), Graphics.COLOR_TRANSPARENT);
      } else {
        dc.setColor(themeColor(Color.TEXT_ACTIVE), Graphics.COLOR_TRANSPARENT);
      }
      mLastInfo.icon.invoke(
        dc,
        locX,
        locY, 
        Settings.get("iconSize"), 
        Settings.get("strokeWidth"),
        mLastInfo.text
      );
    }

    setAntiAlias(dc, false);
  }

  function partialUpdate(dc) {
    drawPartialUpdate(dc, method(:update));
  }

  hidden function drawRemainingArc(dc, fillLevel) {
    if (fillLevel < 1.0) {
      dc.setColor(themeColor(Color.INACTIVE), Graphics.COLOR_TRANSPARENT);
      dc.drawLine(locX, locY, locX+width, locY);
    }
  }

  hidden function drawProgressArc(dc, fillLevel) {
    dc.setColor(getForeground(), Graphics.COLOR_TRANSPARENT);
    if (fillLevel > 0.0) {
      dc.drawLine(locX , locY, locX + fillLevel*width, locY);
    }
  }

  hidden function setClippingRegion(dc, penSize) {
    dc.setColor(getForeground(), Graphics.COLOR_TRANSPARENT);
    
    dc.setClip(
      locX - penSize,
      locY - penSize,
      (width + penSize * 2),
      penSize*2
    );
    dc.clear();
  }

  hidden function getForeground() {
    if (mFieldId == FieldId.OUTER || mFieldId == FieldId.SLEEP_BATTERY) {
      return themeColor(Color.PRIMARY);
    } else if (mFieldId == FieldId.UPPER_1) {
      return themeColor(Color.SECONDARY_1);
    } else if (mFieldId == FieldId.UPPER_2) {
      return themeColor(Color.SECONDARY_1);
    } else if (mFieldId == FieldId.LOWER_1) {
      return themeColor(Color.SECONDARY_2);
    } else if (mFieldId == FieldId.LOWER_2) {
      return themeColor(Color.SECONDARY_2);
    }
    return themeColor(Color.FOREGROUND);
  }
}