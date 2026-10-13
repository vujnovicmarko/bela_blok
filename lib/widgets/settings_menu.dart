import 'package:bela_blok/services/app_preferences.dart';
import 'package:bela_blok/widgets/delete_all_data_dialog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

Future<bool?> showSettingsMenu(
  BuildContext context, {
  required void Function() onThemeToggle,
  required void Function() onAllDataDeleted,
}) async {
  return await showModalBottomSheet<bool>(
    context: context,
    builder: (context) {
      return SettingsMenu(
        onThemeToggle: onThemeToggle,
        onAllDataDeleted: onAllDataDeleted,
      );
    },
  );
}

class SettingsMenu extends StatefulWidget {
  final void Function() onThemeToggle;
  final void Function() onAllDataDeleted;

  const SettingsMenu({
    super.key,
    required this.onThemeToggle,
    required this.onAllDataDeleted,
  });

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  String _startingDealer = AppPreferences.defaultStartingDealer;
  String _playingDirection = AppPreferences.defaultPlayingDirection;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dealer = await AppPreferences.getStartingDealer();
    final direction = await AppPreferences.getPlayingDirection();

    if (!mounted) return;

    setState(() {
      _startingDealer = dealer;
      _playingDirection = direction;
    });
  }

  Future<void> _toggleStartingDealer() async {
    final newDealer = _startingDealer == "random" ? "first" : "random";

    await AppPreferences.setStartingDealer(newDealer);

    if (!mounted) return;

    setState(() {
      _startingDealer = newDealer;
    });
  }

  Future<void> _togglePlayingDirection() async {
    final newDirection = _playingDirection == "counter-clockwise"
        ? "clockwise"
        : "counter-clockwise";

    await AppPreferences.setPlayingDirection(newDirection);

    if (!mounted) return;

    setState(() {
      _playingDirection = newDirection;
    });
  }

  void _openDeleteAllDataDialog(BuildContext context) async {
    final allDataDeleted = await showDeleteAllDataDialog(context);

    if (allDataDeleted == true) {
      widget.onAllDataDeleted();

      if (!context.mounted) return;

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            leading: Icon(
              isDarkMode
                  ? Symbols.dark_mode_rounded
                  : Symbols.light_mode_rounded,
              fill: isDarkMode ? 1 : 0,
            ),
            title: const Text("Promijeni temu"),
            onTap: widget.onThemeToggle,
          ),
          ListTile(
            leading: Icon(
              _startingDealer == "random"
                  ? Symbols.help_center_rounded
                  : Symbols.looks_one_rounded,
              fill: isDarkMode ? 1 : 0,
            ),
            title: Text(
              "Tko prvi miješa: ${_startingDealer == "random" ? "Nasumično" : "Prvi igrač"}",
            ),
            onTap: _toggleStartingDealer,
          ),
          ListTile(
            leading: Icon(
              _playingDirection == "counter-clockwise"
                  ? Symbols.rotate_left_rounded
                  : Symbols.rotate_right_rounded,
              fill: isDarkMode ? 1 : 0,
            ),
            title: Text(
              "Smjer igranja: ${_playingDirection == "counter-clockwise" ? "Udesno" : "Ulijevo"}",
            ),
            onTap: _togglePlayingDirection,
          ),
          ListTile(
            leading: Icon(
              Symbols.delete_sweep_rounded,
              fill: isDarkMode ? 1 : 0,
              color: colorScheme.error,
            ),
            title: Text(
              "Obriši sve podatke",
              style: TextStyle(color: colorScheme.error),
            ),
            onTap: () => _openDeleteAllDataDialog(context),
          ),
        ],
      ),
    );
  }
}
