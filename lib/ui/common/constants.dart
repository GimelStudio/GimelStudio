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

  static List<String> supportedReadFileFormats = [
    'gimel',
    'jpg',
    'jpeg',
    'png',
    'gif',
    'bmp',
    'tiff',
    'tga',
    'ico',
  ];

  static List<String> supportedExportFileFormats = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'bmp',
    'tiff',
    'tga',
    'ico',
  ];

  static List<String> supportedRasterFileFormats = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'bmp',
    'tiff',
    'tga',
    'ico',
  ];
}

// Environment variables passed in during build.
const String envPlatform = String.fromEnvironment('PLATFORM', defaultValue: '');
const String envBuildDateTime = String.fromEnvironment('BUILD_DATETIME', defaultValue: '');
const String envBuildBranch = String.fromEnvironment('BUILD_BRANCH', defaultValue: '(unknown)');
const String envBuildCommit = String.fromEnvironment('BUILD_COMMIT', defaultValue: '(unknown)');
