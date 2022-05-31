using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Application.Properties;
using Toybox.Graphics;
using Toybox.System;

class ProtomoleculeSettingsMenu extends WatchUi.Menu2 {

  function initialize() {
    Menu2.initialize({:title => Settings.resource(Rez.Strings.SettingsMenuLabel)});
    
    Menu2.addItem(menuItem("layout", Settings.resource(Rez.Strings.SettingsLayoutTitle), getLayoutString(Settings.get("layout")))); 
    Menu2.addItem(menuItem("layoutSettings", Settings.resource(Rez.Strings.SettingsLayoutSettingsTitle), null));
    Menu2.addItem(menuItem("theme", Settings.resource(Rez.Strings.SettingsThemeTitle), getThemeString(Settings.get("theme"))));

    Menu2.addItem(toggleItem("activeHeartrate", 
      Settings.resource(Rez.Strings.ToggleMenuActiveHeartrateLabel), 
      Settings.resource(Rez.Strings.ToggleMenuActiveHeartrateEnabled), 
      Settings.resource(Rez.Strings.ToggleMenuActiveHeartrateDisabled)));
    Menu2.addItem(toggleItem("showMeridiemText", 
      Settings.resource(Rez.Strings.ToggleMenuShowAmPmLabel), 
      Settings.resource(Rez.Strings.ToggleMenuEnabled), 
      Settings.resource(Rez.Strings.ToggleMenuDisabled)));
    Menu2.addItem(toggleItem("sleepLayoutActive", 
      Settings.resource(Rez.Strings.ToggleMenuSleepTimeLayoutLabel), 
      Settings.resource(Rez.Strings.ToggleMenuEnabled), 
      Settings.resource(Rez.Strings.ToggleMenuDisabled)));
    Menu2.addItem(toggleItem("useSystemFontForDate", 
      Settings.resource(Rez.Strings.ToggleMenuSystemFontLabel), 
      Settings.resource(Rez.Strings.ToggleMenuSystemFontEnabled), 
      Settings.resource(Rez.Strings.ToggleMenuSystemFontDisabled)));

    Menu2.addItem(menuItem("caloriesGoal", 
      Settings.resource(Rez.Strings.SettingsCaloriesGoalTitle), 
      Settings.get("caloriesGoal").toString()));
    Menu2.addItem(menuItem("batteryThreshold", 
      Settings.resource(Rez.Strings.SettingsBatteryThresholdTitle), 
      Settings.get("batteryThreshold").toString()));
  }
}

class ProtomoleculeSettingsDelegate extends WatchUi.Menu2InputDelegate {

  function initialize() {
    Menu2InputDelegate.initialize();
  }

  function onSelect(item) {
    var layoutId = Settings.get("layout");

    if (item.getId().equals("layoutSettings")) {             
      if (layoutId == LayoutId.ORBIT) {
        pushOrbitSubMenu(); return;
      } else {
        pushCirclesSubMenu(); return;
      }
    }
    if (item.getId().equals("layout")) {
      pushLayoutOptionsMenu(item); return;
    }
    if (item.getId().equals("theme")) {
      pushThemeOptionsMenu(item); return;
    }
    if ("middle1middle2middle3".find(item.getId()) != null) {
      pushClockDatafieldOptionsMenu(item); return;
    }
    if (layoutId == LayoutId.ORBIT && "outerupper1upper2".find(item.getId()) != null) {
      pushOrbitDatafieldOptionsMenu(item); return;
    }
    if (layoutId == LayoutId.CIRCLES && "lower1lower2upper1upper2".find(item.getId()) != null) {
      pushInnerCirclesDatafieldOptionsMenu(item); return;
    }
    if (layoutId == LayoutId.CIRCLES && "outer".equals(item.getId())) {
      pushOuterCirclesDatafieldOptionsMenu(item); return;
    }
    if (item.getId().equals("caloriesGoal")) {
      pushCaloriesPicker(item); return;
    }
    if (item.getId().equals("batteryThreshold")) {
      pushBatteryPicker(item); return;
    }
    if (item instanceof ToggleMenuItem) {
      Settings.set(item.getId(), item.isEnabled());
    }
  }

  hidden function pushCaloriesPicker(parent) {
    var holder = new NumberFactory(1500, 4000, 100, parent.getId(), {});
    WatchUi.pushView(
      new OptionsMenu(holder, { :title => parent.getLabel() }), 
      new OptionsMenuDelegate(holder, parent), WatchUi.SLIDE_LEFT
    );
  }

  hidden function pushBatteryPicker(parent) {
    var holder = new NumberFactory(10, 55, 5, parent.getId(), {:suffix => "%"});
    WatchUi.pushView(
      new OptionsMenu(holder, { :title => parent.getLabel() }), 
      new OptionsMenuDelegate(holder, parent), WatchUi.SLIDE_LEFT
    );
  }

  hidden function pushThemeOptionsMenu(parent) {
    var holder = new FixedValuesFactory([ 
      getThemeString(0), getThemeString(1), 
      getThemeString(2), getThemeString(3)
    ], parent.getId(), {});
    WatchUi.pushView(
      new OptionsMenu(holder, { :title => parent.getLabel() }), 
      new OptionsMenuDelegate(holder, parent), WatchUi.SLIDE_LEFT
    );
  }

  hidden function pushLayoutOptionsMenu(parent) {
    var holder = new FixedValuesFactory([ getLayoutString(0), getLayoutString(1) ], parent.getId(), {});
    WatchUi.pushView(
      new OptionsMenu(holder, { :title => parent.getLabel() }), 
      new OptionsMenuDelegate(holder, parent), WatchUi.SLIDE_LEFT
    );
  }

  hidden function pushOrbitDatafieldOptionsMenu(parent) {
    var holder = new FixedValuesFactory([ 
      getDataFieldString(0), getDataFieldString(1), getDataFieldString(2), getDataFieldString(3),
      getDataFieldString(4), getDataFieldString(7), getDataFieldString(8)
    ], parent.getId(), {});
    WatchUi.pushView(
      new OptionsMenu(holder, { :title => parent.getLabel() }), 
      new OptionsMenuDelegate(holder, parent), WatchUi.SLIDE_LEFT
    );
  }
  
  hidden function pushInnerCirclesDatafieldOptionsMenu(parent) {
    var holder = new FixedValuesFactory([ 
      getDataFieldString(0), getDataFieldString(1), getDataFieldString(2),
      getDataFieldString(3), getDataFieldString(4), getDataFieldString(7),
      getDataFieldString(8), getDataFieldString(9)
    ], parent.getId(), {});
    WatchUi.pushView(
      new OptionsMenu(holder, { :title => parent.getLabel() }), 
      new OptionsMenuDelegate(holder, parent), WatchUi.SLIDE_LEFT
    );
  }
  
  hidden function pushOuterCirclesDatafieldOptionsMenu(parent) {
    var holder = new FixedValuesFactory([ 
      getDataFieldString(0), getDataFieldString(1), getDataFieldString(2), getDataFieldString(3)
    ], parent.getId(), {});
    WatchUi.pushView(
      new OptionsMenu(holder, { :title => parent.getLabel() }), 
      new OptionsMenuDelegate(holder, parent), WatchUi.SLIDE_LEFT
    );
  }
  
  hidden function pushClockDatafieldOptionsMenu(parent) {
    var holder = new FixedValuesFactory([ 
      getDataFieldString(0), getDataFieldString(2), getDataFieldString(4), getDataFieldString(5),
      getDataFieldString(6), getDataFieldString(7), getDataFieldString(8), getDataFieldString(9),
      getDataFieldString(10)
    ], parent.getId(), {});
    WatchUi.pushView(
      new OptionsMenu(holder, { :title => parent.getLabel() }), 
      new OptionsMenuDelegate(holder, parent), WatchUi.SLIDE_LEFT
    );
  }

  hidden function pushOrbitSubMenu() {
    var menu = new WatchUi.Menu2({ :title => Settings.resource(Rez.Strings.SettingsOrbitLayoutGroupTitle) });
    menu.addItem(toggleItem("showOrbitIndicatorText", 
      Settings.resource(Rez.Strings.ToggleMenuShowIndicatorTextLabel), 
      Settings.resource(Rez.Strings.ToggleMenuShowIndicatorTextEnabled), 
      Settings.resource(Rez.Strings.ToggleMenuShowIndicatorTextDisabled)));
    menu.addItem(menuItem("upper1", 
      Settings.resource(Rez.Strings.SettingsLeftOrbitTitle), 
      getDataFieldString(Settings.get("upper1"))));
    menu.addItem(menuItem("upper2", 
      Settings.resource(Rez.Strings.SettingsRightOrbitTitle), 
      getDataFieldString(Settings.get("upper2"))));
    menu.addItem(menuItem("outer", 
      Settings.resource(Rez.Strings.SettingsOuterOrbitTitle), 
      getDataFieldString(Settings.get("outer"))));
    menu.addItem(menuItem("middle1", 
      Settings.resource(Rez.Strings.SettingsSecondary1Title), 
      getDataFieldString(Settings.get("middle1"))));
    menu.addItem(menuItem("middle2", 
      Settings.resource(Rez.Strings.SettingsSecondary2Title), 
      getDataFieldString(Settings.get("middle2"))));
    menu.addItem(menuItem("middle3", 
      Settings.resource(Rez.Strings.SettingsSecondary3Title), 
      getDataFieldString(Settings.get("middle3"))));

    WatchUi.pushView(menu, new ProtomoleculeSettingsDelegate(), WatchUi.SLIDE_LEFT);
  }
  
  hidden function pushCirclesSubMenu() {
    var menu = new WatchUi.Menu2({ :title => Settings.resource(Rez.Strings.SettingsCirclesLayoutGroupTitle) });
    menu.addItem(menuItem("upper1", 
      Settings.resource(Rez.Strings.SettingsUpper1Title), 
      getDataFieldString(Settings.get("upper1"))));
    menu.addItem(menuItem("upper2", 
      Settings.resource(Rez.Strings.SettingsUpper2Title), 
      getDataFieldString(Settings.get("upper2"))));
    menu.addItem(menuItem("lower1", 
      Settings.resource(Rez.Strings.SettingsLower1Title), 
      getDataFieldString(Settings.get("lower1"))));
    menu.addItem(menuItem("lower2", 
      Settings.resource(Rez.Strings.SettingsLower2Title), 
      getDataFieldString(Settings.get("lower2"))));
    menu.addItem(menuItem("outer", 
      Settings.resource(Rez.Strings.SettingsOuterTitle), 
      getDataFieldString(Settings.get("outer"))));
    menu.addItem(menuItem("middle1", 
      Settings.resource(Rez.Strings.SettingsSecondary1Title), 
      getDataFieldString(Settings.get("middle1"))));
    menu.addItem(menuItem("middle2", 
      Settings.resource(Rez.Strings.SettingsSecondary2Title), 
      getDataFieldString(Settings.get("middle2"))));
    menu.addItem(menuItem("middle3", 
      Settings.resource(Rez.Strings.SettingsSecondary3Title), 
      getDataFieldString(Settings.get("middle3"))));
    
    WatchUi.pushView(menu, new ProtomoleculeSettingsDelegate(), WatchUi.SLIDE_LEFT);
  }


  function onBack() {
    WatchUi.popView(WatchUi.SLIDE_RIGHT);
  }
}

function toggleItem(id, label, enabledSubLabel, disabledSubLabel) {
  return new WatchUi.ToggleMenuItem(label, { :enabled => enabledSubLabel, :disabled => disabledSubLabel }, id, Settings.get(id), null);
}

function menuItem(id, label, subLabel) {
  return new WatchUi.MenuItem(label, subLabel, id, null);
}

var _theme = null;

function getThemeString(themeId) {
  if (_theme == null) {
    _theme = [
      Rez.Strings.ThemeExpanse,
      Rez.Strings.ThemeEarth,
      Rez.Strings.ThemeMars,
      Rez.Strings.ThemeBelt
    ];
  }
  return Settings.resource(_theme[themeId]);
}

var _layout = null;

function getLayoutString(layoutId) {
  if (_layout == null) {
    _layout = [
      Rez.Strings.LayoutOrbitItem,
      Rez.Strings.LayoutCirclesItem
    ];
  }
  return Settings.resource(_layout[layoutId]);
}

var _dataField = null;

function getDataFieldString(dfValue) {
  if (_dataField == null) {
    _dataField = [
      Rez.Strings.NoDataField,
      Rez.Strings.DataFieldSteps,
      Rez.Strings.DataFieldBattery,
      Rez.Strings.DataFieldCalories,
      Rez.Strings.DataFieldActiveMinutes,
      Rez.Strings.DataFieldHeartRate,
      Rez.Strings.DataFieldMessages,
      Rez.Strings.DataFieldFloorsUp,
      Rez.Strings.DataFieldFloorsDown,
      Rez.Strings.DataFieldBluetooth,
      Rez.Strings.DataFieldAlarms
    ];
  }
  return Settings.resource(_dataField[dfValue]);
}