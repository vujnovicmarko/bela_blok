import 'package:flutter/material.dart';

void showSettingsMenu(
  BuildContext context, {
  required VoidCallback onThemeToggle,
}) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;

      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              leading: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
              title: const Text('Promijeni temu'),
              onTap: onThemeToggle,
            ),
            //TODO: dodati jos postavki, poput brisanja podataka
          ],
        ),
      );
    },
  );
}
