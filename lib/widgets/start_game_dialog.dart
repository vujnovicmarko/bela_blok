import 'package:bela_blok/database/database_helper.dart';
import 'package:bela_blok/models/game.dart';
import 'package:bela_blok/models/player.dart';
import 'package:bela_blok/widgets/add_player_dialog.dart';
import 'package:flutter/material.dart';

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

  bool _isLoadingPlayers = true;
  bool _isLoading = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  @override
  void dispose() {
    _targetController.dispose();
    super.dispose();
  }

  Future<void> _loadPlayers() async {
    final players = await DatabaseHelper.instance.getPlayers();

    setState(() {
      _allPlayers = players;
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
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Tim 1", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildPlayerDropdown(
              label: "Igrač 1",
              selectedPlayerId: _player1Id,
              onChanged: (selectedPlayerId) => setState(() {
                _player1Id = selectedPlayerId;
              }),
            ),
            const SizedBox(height: 8),
            _buildPlayerDropdown(
              label: "Igrač 3",
              selectedPlayerId: _player3Id,
              onChanged: (selectedPlayerId) => setState(() {
                _player3Id = selectedPlayerId;
              }),
            ),
            const SizedBox(height: 32),
            const Text("Tim 2", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildPlayerDropdown(
              label: "Igrač 2",
              selectedPlayerId: _player2Id,
              onChanged: (selectedPlayerId) => setState(() {
                _player2Id = selectedPlayerId;
              }),
            ),
            const SizedBox(height: 8),
            _buildPlayerDropdown(
              label: "Igrač 4",
              selectedPlayerId: _player4Id,
              onChanged: (selectedPlayerId) => setState(() {
                _player4Id = selectedPlayerId;
              }),
            ),
            const SizedBox(height: 32),
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.onSecondary,
                backgroundColor: colorScheme.secondary,
              ),
              onPressed: () => _openAddPlayerDialog(),
              icon: const Icon(Icons.person_add_rounded),
              label: const Text("Dodaj igrača"),
            ),
            const Divider(height: 64),
            _buildTargetField(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerDropdown({
    required String label,
    required int? selectedPlayerId,
    required ValueChanged<int?> onChanged,
  }) {
    final availablePlayers = _getAvailablePlayers(selectedPlayerId);

    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 12),
      child: DropdownButtonFormField<int>(
        initialValue: selectedPlayerId,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: availablePlayers.map((player) {
          return DropdownMenuItem<int>(
            value: player.id,
            child: Text(player.name, overflow: TextOverflow.ellipsis),
          );
        }).toList(),
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

      final game = Game(
        player1: player1,
        player2: player2,
        player3: player3,
        player4: player4,
        target: target,
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

    await _loadPlayers();

    final newPlayer = _allPlayers
        .where((player) => !oldPlayerIds.contains(player.id))
        .firstOrNull;

    if (newPlayer != null) {
      setState(() {
        if (_player1Id == null) {
          _player1Id = newPlayer.id;
        } else if (_player3Id == null) {
          _player3Id = newPlayer.id;
        } else if (_player2Id == null) {
          _player2Id = newPlayer.id;
        } else if (_player4Id == null) {
          _player4Id = newPlayer.id;
        }
      });
    }
  }
}
