import 'package:flutter/material.dart';

const Color _customColor = Color.fromRGBO(250, 247, 242, 1);

const List<Color> _colorThemes = [
  _customColor,
  Color.fromRGBO(179, 219, 218, 1),
  Color.fromRGBO(254, 229, 224, 1),
  Color.fromRGBO(13, 146, 118, 1),
  Color.fromRGBO(255, 191, 195, 1),
  Color.fromRGBO(169, 160, 153, 1),
  Color.fromRGBO(218, 235, 250, 1),
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
