import 'package:bela_blok/models/game.dart';
import 'package:bela_blok/models/player.dart';
import 'package:bela_blok/services/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

Future<Player?> showChangeDealerDialog(BuildContext context, Game game) async {
  return await showDialog<Player>(
    context: context,
    builder: (context) => ChangeDealerDialog(game: game),
  );
}

class ChangeDealerDialog extends StatefulWidget {
  final Game game;

  const ChangeDealerDialog({super.key, required this.game});

  @override
  State<StatefulWidget> createState() => _ChangeDealerDialogState();
}

class _ChangeDealerDialogState extends State<ChangeDealerDialog> {
  Player? _currentDealer;
  bool _isCounterClockwise = false;
  bool _isPreferencesLoading = true;

  @override
  void initState() {
    super.initState();
    _currentDealer = widget.game.currentDealer;
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final direction = await AppPreferences.getPlayingDirection();

    if (!mounted) return;

    setState(() {
      _isCounterClockwise = direction == "counter-clockwise";
      _isPreferencesLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Tko miješa?"),
      content: _isPreferencesLoading
          ? const SizedBox(
              width: 100,
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : _buildContent(),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text("Odustani"),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _currentDealer),
          child: const Text("Spremi"),
        ),
      ],
    );
  }

  Widget _buildContent() {
    final colorScheme = Theme.of(context).colorScheme;

    final topLeftPlayer = widget.game.player3;
    final topRightPlayer = _isCounterClockwise
        ? widget.game.player2
        : widget.game.player4;
    final bottomLeftPlayer = _isCounterClockwise
        ? widget.game.player4
        : widget.game.player2;
    final bottomRightPlayer = widget.game.player1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(child: _buildPlayerButton(topLeftPlayer)),
            const SizedBox(width: 16),
            Expanded(child: _buildPlayerButton(topRightPlayer)),
          ],
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 28),
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outline, width: 2),
            ),
            child: Center(
              child: Icon(
                Symbols.playing_cards_rounded,
                fill: 1,
                size: 32,
                color: colorScheme.outline,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _buildPlayerButton(bottomLeftPlayer)),
            const SizedBox(width: 16),
            Expanded(child: _buildPlayerButton(bottomRightPlayer)),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayerButton(Player player) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _currentDealer?.id == player.id;

    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 12),
      child: SizedBox(
        height: 60,
        width: 150,
        child: TextButton.icon(
          style: TextButton.styleFrom(
            backgroundColor: isSelected
                ? colorScheme.secondary
                : colorScheme.surfaceContainerHighest,
            foregroundColor: isSelected
                ? colorScheme.onSecondary
                : colorScheme.onSurfaceVariant,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            setState(() {
              _currentDealer = player;
            });
          },
          label: Text(
            player.name,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          icon: isSelected ? const Icon(Symbols.check_rounded) : null,
        ),
      ),
    );
  }
}
