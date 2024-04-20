import 'package:flutter/material.dart';

const Color _customColor = Color.fromRGBO(130, 193, 40, 1);

const List<Color> _colorThemes = [
  _customColor,
  Color.fromRGBO(255, 125, 10, 1),
  Colors.teal,
  Color.fromRGBO(13, 146, 118, 1),
  Color.fromRGBO(154, 200, 205, 1),
  Color.fromRGBO(22, 121, 171, 1),
  Color.fromRGBO(219, 19, 122, 1),
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
