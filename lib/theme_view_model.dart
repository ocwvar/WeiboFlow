import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weibo_flow/base/keys.dart';

class ThemeViewModel extends ChangeNotifier {

  // theme brightness mode
  DayNightMode _currentMode = DayNightMode.dark;
  ThemeMode get themeMode => _getThemeMode();

  // light theme
  late ThemeData _lightTheme;
  ThemeData get lightTheme => _lightTheme;

  // dark theme
  late ThemeData _darkTheme;
  ThemeData get darkTheme => _darkTheme;

  // is theme setting was synced
  bool get isSettingSynced => _isSettingSynced;
  bool _isSettingSynced = false;

  void debugD() {
    if (_currentMode == DayNightMode.system || _currentMode == DayNightMode.dark) {
      _currentMode = DayNightMode.light;
    } else {
      _currentMode = DayNightMode.dark;
    }
    notifyListeners();
  }

  void debugC() {
    _setThemeFromColorOf(Colors.blueAccent);
  }

  /// set new theme color
  void setNewThemeColor(Color newColor) {
    _saveThemeColor(newColor);
    _setThemeFromColorOf(newColor);
  }

  /// set day-night mode
  void setDayNightMode(DayNightMode newMode) {
    _saveDayNightMode(newMode);
    _currentMode = newMode;
    notifyListeners();
  }

  /// get current using [ThemeData]
  ThemeData getCurrentThemeData() {
    switch(_currentMode) {
      case DayNightMode.light:
        return _lightTheme;
      case DayNightMode.dark:
        return _darkTheme;
      case DayNightMode.system:
        final Brightness system = SchedulerBinding.instance!.window.platformBrightness;
        if (system == Brightness.dark) {
          return _darkTheme;
        }
        return _lightTheme;
    }
  }

  /// sync and set cached config or just use default setting
  void syncLastCachedConfig() {
    SharedPreferences.getInstance().then((SharedPreferences sp){
      // theme mode. default is follow system
      _currentMode = DayNightMode.values[sp.getInt(Keys.keyIntThemeMode) ?? 2];

      // base color
      final int? colorValue = sp.getInt(Keys.keyIntThemeBaseColor);
      final Color baseColor;
      if (colorValue == null) {
        baseColor = Colors.pinkAccent;
      } else {
        baseColor = Color(colorValue);
      }

      _isSettingSynced = true;
      _setThemeFromColorOf(baseColor);
    });
  }

  /// init theme with given [baseColor]
  /// should call this function before setting the Theme
  void _setThemeFromColorOf(Color baseColor) {
    final ThemeData lightTheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: baseColor, brightness: Brightness.light),
        useMaterial3: true,
        brightness: Brightness.light
    );

    final ThemeData darkTheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: baseColor, brightness: Brightness.dark,),
        useMaterial3: true,
        brightness: Brightness.dark
    );

    _lightTheme = lightTheme;
    _darkTheme = darkTheme;

    notifyListeners();
  }

  /// current [ThemeMode] we should use
  ThemeMode _getThemeMode() {
    switch(_currentMode) {
      case DayNightMode.light:
        return ThemeMode.light;
      case DayNightMode.dark:
        return ThemeMode.dark;
      case DayNightMode.system:
        return ThemeMode.system;
    }
  }

  /// save day-night mode into cache
  void _saveDayNightMode(DayNightMode newMode) {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sp.setInt(Keys.keyIntThemeMode, DayNightMode.values.indexOf(newMode));
    });
  }

  /// save theme color into cache
  void _saveThemeColor(Color newColor) {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sp.setInt(Keys.keyIntThemeBaseColor, newColor.value);
    });
  }

}

enum DayNightMode {
  light,
  dark,
  system
}