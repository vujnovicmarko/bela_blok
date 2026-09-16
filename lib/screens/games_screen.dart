import 'package:bela_blok/screens/base_screen.dart';
import 'package:bela_blok/widgets/empty_screen_placeholder.dart';
import 'package:bela_blok/widgets/start_game_dialog.dart';
import 'package:flutter/material.dart';

class GamesScreen extends BaseScreen {
  const GamesScreen({super.key});

  @override
  String getTitle(BuildContext context) => "Partije";

  @override
  Widget? getFloatingActionButton(BuildContext context) {
    //TODO: dodat dodavanje nove igre u bazu podatkaa, prikazat alert dialog
    return FloatingActionButton(
      onPressed: () => showStartGameDialog(context),
      child: const Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Dovrsit layout screena, za sada je samo palceholder
    return EmptyScreenPlaceholder(
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
    );
  }
}
