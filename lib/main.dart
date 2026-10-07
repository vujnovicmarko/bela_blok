import 'package:bela_blok/screens/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:bela_blok/theme/theme.dart';
import 'package:bela_blok/theme/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _themePrefKey = "theme_mode";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final savedThemeMode = prefs.getString(_themePrefKey);

  final initialThemeMode = _parseThemeMode(savedThemeMode);

  runApp(BelaBlok(initialThemeMode: initialThemeMode));
}

ThemeMode _parseThemeMode(String? themeMode) {
  if (themeMode == "light") {
    return ThemeMode.light;
  } else if (themeMode == "dark") {
    return ThemeMode.dark;
  } else {
    return ThemeMode.system;
  }
}

class BelaBlok extends StatefulWidget {
  final ThemeMode initialThemeMode;

  const BelaBlok({super.key, required this.initialThemeMode});

  @override
  State<BelaBlok> createState() => _BelaBlokState();
}

class _BelaBlokState extends State<BelaBlok> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
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

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePrefKey, newThemeMode.name);
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
