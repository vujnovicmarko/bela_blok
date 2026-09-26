import 'package:bela_blok/database/database_helper.dart';
import 'package:bela_blok/models/player.dart';
import 'package:flutter/material.dart';

Future<void> showStartGameDialog(BuildContext context) async {
  await showDialog(
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
  Player? _player1;
  Player? _player2;
  Player? _player3;
  Player? _player4;

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
    _allPlayers = await DatabaseHelper.instance.getPlayers();

    setState(() {
      _isLoadingPlayers = false;
    });
  }

  List<Player> _getAvailablePlayers(Player? selectedPlayer) {
    List<int> excludeIds =
        [_player1?.id, _player2?.id, _player3?.id, _player4?.id]
            .where((id) => id != null && id != selectedPlayer?.id)
            .cast<int>()
            .toList();

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
              : () => Navigator.pop(context),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Tim 1", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildPlayerDropdown(
              label: "Igrač 1",
              selectedPlayer: _player1,
              onChanged: (selectedPlayer) => setState(() {
                _player1 = selectedPlayer;
              }),
            ),
            const SizedBox(height: 8),
            _buildPlayerDropdown(
              label: "Igrač 3",
              selectedPlayer: _player3,
              onChanged: (selectedPlayer) => setState(() {
                _player3 = selectedPlayer;
              }),
            ),
            const SizedBox(height: 32),
            const Text("Tim 2", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildPlayerDropdown(
              label: "Igrač 2",
              selectedPlayer: _player2,
              onChanged: (selectedPlayer) => setState(() {
                _player2 = selectedPlayer;
              }),
            ),
            const SizedBox(height: 8),
            _buildPlayerDropdown(
              label: "Igrač 4",
              selectedPlayer: _player4,
              onChanged: (selectedPlayer) => setState(() {
                _player4 = selectedPlayer;
              }),
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
    required Player? selectedPlayer,
    required ValueChanged<Player?> onChanged,
  }) {
    final availablePlayers = _getAvailablePlayers(selectedPlayer);

    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 12),
      child: DropdownButtonFormField(
        initialValue: selectedPlayer,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: availablePlayers.map((player) {
          return DropdownMenuItem(
            value: player,
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
      await DatabaseHelper.instance.insertGame(
        _player1!,
        _player2!,
        _player3!,
        _player4!,
        target,
      );

      if (!mounted) {
        return;
      }

      Navigator.pop(context);
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
}
