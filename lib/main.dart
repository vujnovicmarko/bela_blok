import 'package:bela_blok/screens/main_navigation.dart';
import 'package:bela_blok/services/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:bela_blok/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeMode = await AppPreferences.getThemeMode();

  runApp(BelaBlok(themeMode: themeMode));
}

class BelaBlok extends StatefulWidget {
  final ThemeMode themeMode;

  const BelaBlok({super.key, required this.themeMode});

  @override
  State<BelaBlok> createState() => _BelaBlokState();
}

class _BelaBlokState extends State<BelaBlok> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.themeMode;
  }

  Future<void> _toggleTheme() async {
    final currentBrightness = _themeMode == ThemeMode.system
        ? View.of(context).platformDispatcher.platformBrightness
        : (_themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light);

    final newThemeMode = currentBrightness == Brightness.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    setState(() {
      _themeMode = newThemeMode;
    });

    await AppPreferences.setThemeMode(newThemeMode);
  }

  @override
  Widget build(BuildContext context) {
    MaterialTheme theme = MaterialTheme(ThemeData.light().textTheme);

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
