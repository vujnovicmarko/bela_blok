import 'package:bela_blok/widgets/delete_all_data_dialog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

Future<bool?> showSettingsMenu(
  BuildContext context, {
  required void Function() onThemeToggle,
  required void Function() onAllDataDeleted,
}) async {
  void openDeleteAllDataDialog(BuildContext context) async {
    final allDataDeleted = await showDeleteAllDataDialog(context);

    if (allDataDeleted == true) {
      onAllDataDeleted();

      if (!context.mounted) {
        return;
      }

      Navigator.pop(context);
    }
  }

  return await showModalBottomSheet<bool>(
    context: context,
    builder: (context) {
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
                fill: 1,
              ),
              title: const Text("Promijeni temu"),
              onTap: onThemeToggle,
            ),
            ListTile(
              leading: Icon(
                Symbols.delete_sweep_rounded,
                fill: 0,
                color: colorScheme.error,
              ),
              title: Text(
                "Obriši sve podatke",
                style: TextStyle(color: colorScheme.error),
              ),
              onTap: () => openDeleteAllDataDialog(context),
            ),
          ],
        ),
      );
    },
  );
}
