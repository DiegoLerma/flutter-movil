import 'package:flutter/material.dart';

const Color _customColor = Color.fromRGBO(250, 247, 242, 1);

const List<Color> _colorThemes = [
  _customColor,
  Colors.black,
  Colors.red,
  Colors.redAccent,
  Colors.blue,
  Colors.white,
  Colors.orange,
  Colors.purple,
  Colors.pinkAccent,
];

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
      : assert(selectedColor >= 0 && selectedColor <= _colorThemes.length - 1,
            'Colors must be between 0 and ${_colorThemes.length - 1}');
  ThemeData theme() {
    return ThemeData(
        useMaterial3: true, colorSchemeSeed: _colorThemes[selectedColor]);
  }
}
