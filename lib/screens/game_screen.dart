import 'package:bela_blok/database/database_helper.dart';
import 'package:bela_blok/models/game.dart';
import 'package:bela_blok/models/round.dart';
import 'package:bela_blok/widgets/round_dialog.dart';
import 'package:bela_blok/widgets/empty_screen_placeholder.dart';
import 'package:bela_blok/widgets/round_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:material_symbols_icons/symbols.dart';

class GameScreen extends StatefulWidget {
  final Game game;

  const GameScreen({super.key, required this.game});

  @override
  State<StatefulWidget> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Round> _rounds = [];
  late Game _game;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _game = widget.game;
    loadRounds();
  }

  Future<void> loadRounds() async {
    setState(() => _isLoading = true);

    final rounds = await DatabaseHelper.instance.getRoundsForGame(_game);
    final game = await DatabaseHelper.instance.getGame(_game.id!);

    if (!mounted) return;

    rounds.sort(
      (r1, r2) => (r1.roundNumber ?? 0).compareTo(r2.roundNumber ?? 0),
    );

    final updatedRounds = rounds.map((round) {
      return round.copyWith(game: game);
    }).toList();

    setState(() {
      _rounds = updatedRounds;
      _game = game ?? _game;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 100,
          title: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "MI",
                      style: textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${_game.team1Points}",
                      style: textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "VI",
                      style: textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${_game.team2Points}",
                      style: textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _game.isFinished
            ? FloatingActionButton(
                onPressed: () => Navigator.pop(context),
                child: const Icon(
                  Symbols.subdirectory_arrow_left_rounded,
                  fill: 1,
                ),
              )
            : FloatingActionButton(
                onPressed: _openAddRoundDialog,
                child: const Icon(Symbols.add_rounded, fill: 1),
              ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _rounds.isEmpty
              ? EmptyScreenPlaceholder(
                  icon: Symbols.playing_cards_rounded,
                  title: "Nema odigranih rundi",
                  subtitle: TextSpan(
                    children: [
                      const TextSpan(text: "Pritisni "),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Icon(Symbols.add_rounded, fill: 1),
                        ),
                      ),
                      const TextSpan(text: " za upis runde"),
                    ],
                  ),
                  onRefresh: loadRounds,
                )
              : RefreshIndicator(
                  onRefresh: loadRounds,
                  child: ListView.builder(
                    itemCount: _rounds.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final round = _rounds[index];
                      return RoundCard(
                        round: round,
                        loadRounds: loadRounds,
                        gameFinished: _game.isFinished,
                      );
                    },
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _game.isFinished ? null : () {},
              icon: const Icon(Symbols.shuffle_rounded, fill: 1, size: 20),
              label: Text(
                "Miješa: ${_game.currentDealer.name}",
                style: TextStyle(fontSize: 16),
              ),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.tertiary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openAddRoundDialog() async {
    final bool? isAdded = await showRoundDialog(context, _game);

    if (isAdded == true && mounted) {
      await loadRounds();

      if (_game.isFinished && mounted) {
        Confetti.launch(
          context,
          options: const ConfettiOptions(
            particleCount: 200,
            spread: 70,
            particleDuration: Duration(seconds: 3),
            y: 0.75,
          ),
        );

        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;

        Confetti.launch(
          context,
          options: const ConfettiOptions(
            particleCount: 200,
            spread: 70,
            particleDuration: Duration(seconds: 3),
            y: 0.75,
            x: 0.25,
          ),
        );
        Confetti.launch(
          context,
          options: const ConfettiOptions(
            particleCount: 200,
            spread: 70,
            particleDuration: Duration(seconds: 3),
            y: 0.75,
            x: 0.75,
          ),
        );
      }
    }
  }
}
