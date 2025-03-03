import 'package:flutter/material.dart';

class Constants {
  static Map<String, BlendMode> layerBlendModes = {
    'Normal': BlendMode.srcOver,
    'Darken': BlendMode.darken,
    'Multiply': BlendMode.multiply,
    'Color Burn': BlendMode.colorBurn,
    'Lighten': BlendMode.lighten,
    'Screen': BlendMode.screen,
    'Color Dodge': BlendMode.colorDodge,
    'Add': BlendMode.plus,
    'Overlay': BlendMode.overlay,
    'Soft Light': BlendMode.softLight,
    'Hard Light': BlendMode.hardLight,
    'Difference': BlendMode.difference,
    'Exclusion': BlendMode.exclusion,
    'Hue': BlendMode.hue,
    'Saturation': BlendMode.saturation,
    'Color': BlendMode.color,
    'Luminosity': BlendMode.luminosity,
  };
}
