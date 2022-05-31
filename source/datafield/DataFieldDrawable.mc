using Toybox.WatchUi;
using Toybox.Application;

class DataFieldDrawable extends WatchUi.Drawable {

  hidden var mFieldId;
  hidden var mLastInfo = null;

  function initialize(params) {
    Drawable.initialize(params);
    
    mFieldId = params[:fieldId];
  }

  function draw(dc) {
    mLastInfo = DataFieldInfo.getInfoForField(mFieldId);
  }

  function drawPartialUpdate(dc, drawCallback) {
    var currentInfo = DataFieldInfo.getInfoForField(mFieldId);
    if (!currentInfo.equals(mLastInfo)) {
      mLastInfo = currentInfo;
      drawCallback.invoke(dc); // invoke update method of child class
    }
  }
}