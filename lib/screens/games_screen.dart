import 'package:bela_blok/widgets/empty_screen_placeholder.dart';
import 'package:bela_blok/widgets/settings_menu.dart';
import 'package:bela_blok/widgets/start_game_dialog.dart';
import 'package:flutter/material.dart';

class GamesScreen extends StatelessWidget {
  final VoidCallback onThemeToggle;

  const GamesScreen({super.key, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    //TODO: Dovrsit layout screena, za sada je samo palceholder
    return Scaffold(
      appBar: AppBar(
        title: Text("Partije"),
        actions: [
          IconButton(
            onPressed: () =>
                showSettingsMenu(context, onThemeToggle: onThemeToggle),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showStartGameDialog(context),
        child: const Icon(Icons.add),
      ),
      body: EmptyScreenPlaceholder(
        icon: Icons.sports_esports,
        title: "Nema odigranih partija",
        subtitle: TextSpan(
          children: [
            const TextSpan(text: "Pritisni "),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(Icons.add),
              ),
            ),
            const TextSpan(text: " za početak partije"),
          ],
        ),
      ),
    );
  }
}
