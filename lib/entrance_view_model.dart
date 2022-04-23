import 'package:flutter/material.dart';

class ThemeViewModel extends ChangeNotifier {

  // theme brightness mode
  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  // light theme
  late ThemeData _lightTheme;
  ThemeData get lightTheme => _lightTheme;

  // dark theme
  late ThemeData _darkTheme;
  ThemeData get darkTheme => _darkTheme;

  /// init theme with given [baseColor]
  /// should call this function before setting the Theme
  void setThemeFromColorOf({required Color baseColor, bool update = true}) {
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

    _themeMode = ThemeMode.system;
    _lightTheme = lightTheme;
    _darkTheme = darkTheme;

    if (update) {
      notifyListeners();
    }
  }

}