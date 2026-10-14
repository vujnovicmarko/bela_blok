import 'package:bela_blok/database/database_helper.dart';
import 'package:bela_blok/models/game.dart';
import 'package:bela_blok/models/player.dart';
import 'package:bela_blok/services/app_preferences.dart';
import 'package:bela_blok/widgets/add_player_dialog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

Future<Game?> showStartGameDialog(BuildContext context) async {
  return await showDialog<Game>(
    context: context,
    builder: (context) => const StartGameDialog(),
  );
}

class StartGameDialog extends StatefulWidget {
  const StartGameDialog({super.key});

  @override
  State<StatefulWidget> createState() => _StartGameDialogState();
}

class _StartGameDialogState extends State<StartGameDialog> {
  final _formKey = GlobalKey<FormState>();
  final _targetController = TextEditingController(text: "1001");

  List<Player> _allPlayers = [];

  int? _player1Id;
  int? _player2Id;
  int? _player3Id;
  int? _player4Id;

  String _playingDirection = AppPreferences.defaultPlayingDirection;

  bool _isLoadingPlayers = true;
  bool _isLoading = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _targetController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final players = await DatabaseHelper.instance.getPlayers();
    final validPlayerIds = players.map((player) => player.id).toSet();

    final player1Id = await AppPreferences.getPlayer1Id();
    final player2Id = await AppPreferences.getPlayer2Id();
    final player3Id = await AppPreferences.getPlayer3Id();
    final player4Id = await AppPreferences.getPlayer4Id();

    final target = await AppPreferences.getTarget();

    final playingDirection = await AppPreferences.getPlayingDirection();

    if (!mounted) return;

    _targetController.text = target.toString();

    setState(() {
      _allPlayers = players;
      _player1Id = validPlayerIds.contains(player1Id) ? player1Id : null;
      _player2Id = validPlayerIds.contains(player2Id) ? player2Id : null;
      _player3Id = validPlayerIds.contains(player3Id) ? player3Id : null;
      _player4Id = validPlayerIds.contains(player4Id) ? player4Id : null;
      _playingDirection = playingDirection;
      _isLoadingPlayers = false;
    });
  }

  List<Player> _getAvailablePlayers(int? selectedPlayerId) {
    List<int> excludeIds = [
      _player1Id,
      _player2Id,
      _player3Id,
      _player4Id,
    ].where((id) => id != null && id != selectedPlayerId).cast<int>().toList();

    return _allPlayers
        .where((player) => !excludeIds.contains(player.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Započni partiju"),
      content: _buildContent(context),
      actions: [
        TextButton(
          onPressed: _isLoadingPlayers || _isLoading
              ? null
              : () => Navigator.pop(context, null),
          child: const Text("Odustani"),
        ),
        FilledButton(
          onPressed: _isLoadingPlayers || _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(),
                )
              : const Text("Započni"),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLoadingPlayers) {
      return const SizedBox(
        width: 100,
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardTable(context),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 28),
              child: SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.onSecondary,
                    backgroundColor: colorScheme.secondary,
                  ),
                  onPressed: () => _openAddPlayerDialog(),
                  icon: const Icon(Symbols.person_add_rounded, fill: 1),
                  label: const Text("Dodaj igrača"),
                ),
              ),
            ),
            const Divider(height: 48),
            Row(
              children: [
                Expanded(child: _buildTargetField()),
                const SizedBox(width: 16),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTable(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCounterClockwise = _playingDirection == "counter-clockwise";

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildPlayerDropdown(
                label: "Igrač 3",
                selectedPlayerId: _player3Id,
                onChanged: (id) {
                  setState(() => _player3Id = id);
                  AppPreferences.setPlayer3Id(id);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPlayerDropdown(
                label: isCounterClockwise ? "Igrač 2" : "Igrač 4",
                selectedPlayerId: isCounterClockwise ? _player2Id : _player4Id,
                onChanged: (id) {
                  if (isCounterClockwise) {
                    setState(() => _player2Id = id);
                    AppPreferences.setPlayer2Id(id);
                  } else {
                    setState(() => _player4Id = id);
                    AppPreferences.setPlayer4Id(id);
                  }
                },
              ),
            ),
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
            Expanded(
              child: _buildPlayerDropdown(
                label: isCounterClockwise ? "Igrač 4" : "Igrač 2",
                selectedPlayerId: isCounterClockwise ? _player4Id : _player2Id,
                onChanged: (id) {
                  if (isCounterClockwise) {
                    setState(() => _player4Id = id);
                    AppPreferences.setPlayer4Id(id);
                  } else {
                    setState(() => _player2Id = id);
                    AppPreferences.setPlayer2Id(id);
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPlayerDropdown(
                label: "Igrač 1",
                selectedPlayerId: _player1Id,
                onChanged: (id) {
                  setState(() => _player1Id = id);
                  AppPreferences.setPlayer1Id(id);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayerDropdown({
    required String label,
    required int? selectedPlayerId,
    required ValueChanged<int?> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final availablePlayers = _getAvailablePlayers(selectedPlayerId);

    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 12),
      child: DropdownButtonFormField<int?>(
        initialValue: selectedPlayerId,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          errorMaxLines: 2,
        ),
        items: [
          DropdownMenuItem<int?>(
            value: null,
            child: Text(
              "Nije odabran",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: colorScheme.outline),
            ),
          ),
          ...availablePlayers.map((player) {
            return DropdownMenuItem<int?>(
              value: player.id,
              child: Text(player.name, overflow: TextOverflow.ellipsis),
            );
          }),
        ],
        validator: (value) {
          if (value == null) {
            return "$label nije odabran";
          }
          return null;
        },
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTargetField() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 12),
      child: TextFormField(
        controller: _targetController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Igra se do",
          border: const OutlineInputBorder(),
          errorText: _errorMessage,
        ),
        onChanged: (target) async {
          final parsedTarget = int.tryParse(target.trim());

          if (parsedTarget != null && parsedTarget > 0) {
            await AppPreferences.setTarget(parsedTarget);
          }
        },
        validator: (target) {
          if (target == null || target.trim().isEmpty) {
            return "Unesite broj bodova";
          }

          final parsedTarget = int.tryParse(target);

          if (parsedTarget == null || parsedTarget <= 0) {
            return "Broj bodova mora biti pozitivan";
          }

          return null;
        },
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final target = int.parse(_targetController.text.trim());

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final player1 = _allPlayers.firstWhere(
        (player) => player.id == _player1Id,
      );
      final player2 = _allPlayers.firstWhere(
        (player) => player.id == _player2Id,
      );
      final player3 = _allPlayers.firstWhere(
        (player) => player.id == _player3Id,
      );
      final player4 = _allPlayers.firstWhere(
        (player) => player.id == _player4Id,
      );

      final startingDealer = await AppPreferences.getStartingDealer();
      Player currentDealer;

      if (startingDealer == "random") {
        final players = [player1, player2, player3, player4];
        players.shuffle();
        currentDealer = players.first;
      } else {
        currentDealer = player1;
      }

      final game = Game(
        player1: player1,
        player2: player2,
        player3: player3,
        player4: player4,
        target: target,
        currentDealer: currentDealer,
        updatedAt: DateTime.now().toIso8601String(),
      );

      final createdGameId = await DatabaseHelper.instance.insertGame(game);
      final createdGame = game.copyWith(id: createdGameId);

      if (!mounted) {
        return;
      }

      Navigator.pop(context, createdGame);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = "Greška pri spremanju u bazu";
        _isLoading = false;
      });
    }
  }

  void _openAddPlayerDialog() async {
    final oldPlayerIds = _allPlayers.map((player) => player.id).toSet();

    await showAddPlayerDialog(context);

    await _loadData();

    final newPlayer = _allPlayers
        .where((player) => !oldPlayerIds.contains(player.id))
        .firstOrNull;

    if (newPlayer != null) {
      if (_player1Id == null) {
        setState(() => _player1Id = newPlayer.id);
        AppPreferences.setPlayer1Id(newPlayer.id);
      } else if (_player2Id == null) {
        setState(() => _player2Id = newPlayer.id);
        AppPreferences.setPlayer2Id(newPlayer.id);
      } else if (_player3Id == null) {
        setState(() => _player3Id = newPlayer.id);
        AppPreferences.setPlayer3Id(newPlayer.id);
      } else if (_player4Id == null) {
        setState(() => _player4Id = newPlayer.id);
        AppPreferences.setPlayer4Id(newPlayer.id);
      }
    }
  }
}
