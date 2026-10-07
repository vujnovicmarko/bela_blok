import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff496722),
      surfaceTint: Color(0xff496722),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff98bb6c),
      onPrimaryContainer: Color(0xff2e4b07),
      secondary: Color(0xff51613f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff697a56),
      onSecondaryContainer: Color(0xfff9ffeb),
      tertiary: Color(0xff006c51),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff65c1a0),
      onTertiaryContainer: Color(0xff004d39),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffafaf0),
      onSurface: Color(0xff1a1c17),
      onSurfaceVariant: Color(0xff44483c),
      outline: Color(0xff74796b),
      outlineVariant: Color(0xffc4c8b8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f312b),
      inversePrimary: Color(0xffaed280),
      primaryFixed: Color(0xffc9ef9a),
      onPrimaryFixed: Color(0xff102000),
      primaryFixedDim: Color(0xffaed280),
      onPrimaryFixedVariant: Color(0xff324f0b),
      secondaryFixed: Color(0xffd7e9be),
      onSecondaryFixed: Color(0xff121f05),
      secondaryFixedDim: Color(0xffbbcda3),
      onSecondaryFixedVariant: Color(0xff3c4b2c),
      tertiaryFixed: Color(0xff98f5d1),
      onTertiaryFixed: Color(0xff002117),
      tertiaryFixedDim: Color(0xff7cd8b6),
      onTertiaryFixedVariant: Color(0xff00513d),
      surfaceDim: Color(0xffdadbd1),
      surfaceBright: Color(0xfffafaf0),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f4ea),
      surfaceContainer: Color(0xffeeeee5),
      surfaceContainerHigh: Color(0xffe8e9df),
      surfaceContainerHighest: Color(0xffe3e3da),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff233d00),
      surfaceTint: Color(0xff496722),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff577630),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2c3a1c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff62724f),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003e2e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff107c5f),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffafaf0),
      onSurface: Color(0xff10120d),
      onSurfaceVariant: Color(0xff33382c),
      outline: Color(0xff4f5447),
      outlineVariant: Color(0xff6a6f61),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f312b),
      inversePrimary: Color(0xffaed280),
      primaryFixed: Color(0xff577630),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff3f5d19),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff62724f),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4a5a38),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff107c5f),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff006149),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc6c7be),
      surfaceBright: Color(0xfffafaf0),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f4ea),
      surfaceContainer: Color(0xffe8e9df),
      surfaceContainerHigh: Color(0xffddddd4),
      surfaceContainerHighest: Color(0xffd2d2c9),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff1c3200),
      surfaceTint: Color(0xff496722),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff34510e),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff223013),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff3f4e2e),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003325),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff00543f),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffafaf0),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff292e22),
      outlineVariant: Color(0xff464b3e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f312b),
      inversePrimary: Color(0xffaed280),
      primaryFixed: Color(0xff34510e),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff213900),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff3f4e2e),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff293719),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff00543f),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff003b2b),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb9b9b1),
      surfaceBright: Color(0xfffafaf0),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f1e8),
      surfaceContainer: Color(0xffe3e3da),
      surfaceContainerHigh: Color(0xffd4d5cc),
      surfaceContainerHighest: Color(0xffc6c7be),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb3d785),
      surfaceTint: Color(0xffaed280),
      onPrimary: Color(0xff1f3700),
      primaryContainer: Color(0xff98bb6c),
      onPrimaryContainer: Color(0xff2e4b07),
      secondary: Color(0xffbbcda3),
      onSecondary: Color(0xff263517),
      secondaryContainer: Color(0xff859670),
      onSecondaryContainer: Color(0xff202d11),
      tertiary: Color(0xff81ddbb),
      onTertiary: Color(0xff003829),
      tertiaryContainer: Color(0xff65c1a0),
      onTertiaryContainer: Color(0xff004d39),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff12140f),
      onSurface: Color(0xffe3e3da),
      onSurfaceVariant: Color(0xffc4c8b8),
      outline: Color(0xff8e9383),
      outlineVariant: Color(0xff44483c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e3da),
      inversePrimary: Color(0xff496722),
      primaryFixed: Color(0xffc9ef9a),
      onPrimaryFixed: Color(0xff102000),
      primaryFixedDim: Color(0xffaed280),
      onPrimaryFixedVariant: Color(0xff324f0b),
      secondaryFixed: Color(0xffd7e9be),
      onSecondaryFixed: Color(0xff121f05),
      secondaryFixedDim: Color(0xffbbcda3),
      onSecondaryFixedVariant: Color(0xff3c4b2c),
      tertiaryFixed: Color(0xff98f5d1),
      onTertiaryFixed: Color(0xff002117),
      tertiaryFixedDim: Color(0xff7cd8b6),
      onTertiaryFixedVariant: Color(0xff00513d),
      surfaceDim: Color(0xff12140f),
      surfaceBright: Color(0xff383a33),
      surfaceContainerLowest: Color(0xff0d0f0a),
      surfaceContainerLow: Color(0xff1a1c17),
      surfaceContainer: Color(0xff1e201b),
      surfaceContainerHigh: Color(0xff292b25),
      surfaceContainerHighest: Color(0xff34352f),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc3e894),
      surfaceTint: Color(0xffaed280),
      onPrimary: Color(0xff172b00),
      primaryContainer: Color(0xff98bb6c),
      onPrimaryContainer: Color(0xff172a00),
      secondary: Color(0xffd0e3b8),
      onSecondary: Color(0xff1c2a0d),
      secondaryContainer: Color(0xff859670),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xff92eecb),
      onTertiary: Color(0xff002c1f),
      tertiaryContainer: Color(0xff65c1a0),
      onTertiaryContainer: Color(0xff002b1f),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff12140f),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdadecd),
      outline: Color(0xffafb4a4),
      outlineVariant: Color(0xff8e9283),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e3da),
      inversePrimary: Color(0xff33500c),
      primaryFixed: Color(0xffc9ef9a),
      onPrimaryFixed: Color(0xff091400),
      primaryFixedDim: Color(0xffaed280),
      onPrimaryFixedVariant: Color(0xff233d00),
      secondaryFixed: Color(0xffd7e9be),
      onSecondaryFixed: Color(0xff081400),
      secondaryFixedDim: Color(0xffbbcda3),
      onSecondaryFixedVariant: Color(0xff2c3a1c),
      tertiaryFixed: Color(0xff98f5d1),
      onTertiaryFixed: Color(0xff00150d),
      tertiaryFixedDim: Color(0xff7cd8b6),
      onTertiaryFixedVariant: Color(0xff003e2e),
      surfaceDim: Color(0xff12140f),
      surfaceBright: Color(0xff43453e),
      surfaceContainerLowest: Color(0xff060804),
      surfaceContainerLow: Color(0xff1c1e19),
      surfaceContainer: Color(0xff272923),
      surfaceContainerHigh: Color(0xff31332d),
      surfaceContainerHighest: Color(0xff3c3e38),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd7fca6),
      surfaceTint: Color(0xffaed280),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffaace7d),
      onPrimaryContainer: Color(0xff050e00),
      secondary: Color(0xffe4f6ca),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffb7c99f),
      onSecondaryContainer: Color(0xff050e00),
      tertiary: Color(0xffb7ffe1),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff78d4b2),
      onTertiaryContainer: Color(0xff000e08),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff12140f),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffeef2e0),
      outlineVariant: Color(0xffc0c4b4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e3da),
      inversePrimary: Color(0xff33500c),
      primaryFixed: Color(0xffc9ef9a),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffaed280),
      onPrimaryFixedVariant: Color(0xff091400),
      secondaryFixed: Color(0xffd7e9be),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffbbcda3),
      onSecondaryFixedVariant: Color(0xff081400),
      tertiaryFixed: Color(0xff98f5d1),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff7cd8b6),
      onTertiaryFixedVariant: Color(0xff00150d),
      surfaceDim: Color(0xff12140f),
      surfaceBright: Color(0xff4f514a),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1e201b),
      surfaceContainer: Color(0xff2f312b),
      surfaceContainerHigh: Color(0xff3a3c36),
      surfaceContainerHighest: Color(0xff464741),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
