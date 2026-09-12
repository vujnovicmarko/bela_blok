import 'package:bela_blok/screens/main_navigation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BelaBlok());
}

class BelaBlok extends StatefulWidget {
  const BelaBlok({super.key});

  @override
  State<BelaBlok> createState() => _BelaBlokState();
}

class _BelaBlokState extends State<BelaBlok> {
  var _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();

    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    _themeMode = brightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = (_themeMode == ThemeMode.dark)
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bela Blok',
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF98BB6c),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF98BB6c),
        brightness: Brightness.dark,
      ),
      //TODO: proslijedit _toggleTheme
      home: const MainNavigation(),
    );
  }
}
