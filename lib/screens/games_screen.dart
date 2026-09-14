import 'package:bela_blok/screens/base_screen.dart';
import 'package:flutter/material.dart';

class GamesScreen extends BaseScreen {
  const GamesScreen({super.key});

  @override
  Text getTitle(BuildContext context) => const Text("Partije");

  @override
  Widget? getFloatingActionButton(BuildContext context) {
    //TODO: dodat dodavanje nvoe igre u bazu podatkaa, prikazat alert dialog
    return FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add));
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Dovrsit layout screena
    return Center(child: Text("Partije"));
  }
}
