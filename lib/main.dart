import 'package:bela_blok/screens/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:bela_blok/theme/theme.dart';
import 'package:bela_blok/theme/util.dart';

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

  void _toggleTheme() {
    setState(() {
      final currentBrightness = _themeMode == ThemeMode.system
          ? View.of(context).platformDispatcher.platformBrightness
          : (_themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light);

      _themeMode = currentBrightness == Brightness.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Inter", "Inter Tight");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bela Blok',
      themeMode: _themeMode,
      theme: theme.light(),
      darkTheme: theme.dark(),
      home: MainNavigation(onThemeToggle: _toggleTheme),
    );
  }
}
