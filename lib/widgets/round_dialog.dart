import 'package:bela_blok/database/database_helper.dart';
import 'package:bela_blok/models/game.dart';
import 'package:bela_blok/models/meld.dart';
import 'package:bela_blok/models/round.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

Future<bool?> showRoundDialog(
  BuildContext context,
  Game game, {
  Round? round,
}) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => RoundDialog(game: game, round: round),
  );
}

class RoundDialog extends StatefulWidget {
  final Game game;
  final Round? round;

  const RoundDialog({super.key, required this.game, this.round});

  @override
  State<StatefulWidget> createState() => _RoundDialogState();
}

class _RoundDialogState extends State<RoundDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _team1Controller = TextEditingController();
  final TextEditingController _team2Controller = TextEditingController();

  int _callingTeam = 1;
  int _stigljaTeam = 0;

  final List<Meld> _team1Melds = [];
  final List<Meld> _team2Melds = [];

  bool _isUpdatingText = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    if (widget.round != null) {
      _callingTeam = widget.round!.callingTeam;
      _stigljaTeam = widget.round!.stigljaTeam;
      _team1Controller.text = widget.round!.team1CardPoints.toString();
      _team2Controller.text = widget.round!.team2CardPoints.toString();
      _team1Melds.addAll(widget.round!.team1Melds);
      _team2Melds.addAll(widget.round!.team2Melds);
    }

    _team1Controller.addListener(_onTeam1Changed);
    _team2Controller.addListener(_onTeam2Changed);
  }

  @override
  void dispose() {
    _team1Controller.dispose();
    _team2Controller.dispose();
    super.dispose();
  }

  void _onTeam1Changed() {
    if (_isUpdatingText || _stigljaTeam != 0) return;
    _isUpdatingText = true;

    final val = int.tryParse(_team1Controller.text.trim());

    if (val != null && val >= 0 && val <= 162) {
      _team2Controller.text = (162 - val).toString();
    }

    _isUpdatingText = false;
  }

  void _onTeam2Changed() {
    if (_isUpdatingText || _stigljaTeam != 0) return;
    _isUpdatingText = true;

    final val = int.tryParse(_team2Controller.text.trim());

    if (val != null && val >= 0 && val <= 162) {
      _team1Controller.text = (162 - val).toString();
    }

    _isUpdatingText = false;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final team1CardPoints = int.parse(_team1Controller.text.trim());
    final team2CardPoints = int.parse(_team2Controller.text.trim());

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final round = Round(
        id: widget.round?.id,
        game: widget.game,
        callingTeam: _callingTeam,
        team1CardPoints: team1CardPoints,
        team2CardPoints: team2CardPoints,
        team1Melds: _team1Melds,
        team2Melds: _team2Melds,
        stigljaTeam: _stigljaTeam,
      );

      if (widget.round != null) {
        await DatabaseHelper.instance.updateRound(round);
      } else {
        await DatabaseHelper.instance.insertRound(round);
      }

      if (!mounted) {
        return;
      }

      Navigator.pop(context, true);
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: const Text("Upiši rundu"),
      content: _buildContent(context),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context, false),
          child: const Text("Odustani"),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(),
                )
              : const Text("Upiši"),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCallingTeamField(context),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCardPointsField(
                    context,
                    "MI Bodovi",
                    _team1Controller,
                  ),
                ),
                const VerticalDivider(width: 32),
                Expanded(
                  child: _buildCardPointsField(
                    context,
                    "VI Bodovi",
                    _team2Controller,
                  ),
                ),
              ],
            ),

            const Divider(height: 32),
            _buildMeldField(context),

            const Divider(height: 32),
            _buildStigljaTeamField(context),

            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCallingTeamField(BuildContext context) {
    return Column(
      children: [
        const Text("Tko je zvao:"),
        const SizedBox(height: 4),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 1, label: Text("MI")),
            ButtonSegment(value: 2, label: Text("VI")),
          ],
          selected: {_callingTeam},
          onSelectionChanged: (val) {
            setState(() => _callingTeam = val.first);
          },
          showSelectedIcon: false,
        ),
      ],
    );
  }

  Widget _buildStigljaTeamField(BuildContext context) {
    return Column(
      children: [
        const Text("Štiglja:"),
        const SizedBox(height: 4),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 0, label: Text("Nema")),
            ButtonSegment(value: 1, label: Text("MI")),
            ButtonSegment(value: 2, label: Text("VI")),
          ],
          selected: {_stigljaTeam},
          onSelectionChanged: (val) {
            setState(() {
              _stigljaTeam = val.first;

              if (_stigljaTeam == 1) {
                _team1Controller.text = "162";
                _team2Controller.text = "0";
              } else if (_stigljaTeam == 2) {
                _team1Controller.text = "0";
                _team2Controller.text = "162";
              }
            });
          },
          showSelectedIcon: false,
        ),
      ],
    );
  }

  Widget _buildCardPointsField(
    BuildContext context,
    String label,
    TextEditingController controller,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(label),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          enabled: _stigljaTeam == 0,
          textAlign: TextAlign.center,
          style: textTheme.headlineLarge,
          decoration: InputDecoration(
            hintText: "0",
            border: OutlineInputBorder(),
          ),
          validator: (points) => _validateCardPoints(points),
        ),
      ],
    );
  }

  Widget _buildMeldField(BuildContext context) {
    return Column(
      children: [
        const Text("Zvanja"),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildMeldSection(
                _team1Melds,
                onAddMeld: (meld) => setState(() => _team1Melds.add(meld)),
                onRemoveMeld: (meld) =>
                    setState(() => _team1Melds.remove(meld)),
                iconOnLeft: true,
              ),
            ),
            Expanded(
              child: _buildMeldSection(
                _team2Melds,
                onAddMeld: (meld) => setState(() => _team2Melds.add(meld)),
                onRemoveMeld: (meld) =>
                    setState(() => _team2Melds.remove(meld)),
                iconOnLeft: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMeldSection(
    List<Meld> teamMelds, {
    required Function(Meld) onAddMeld,
    required Function(Meld) onRemoveMeld,
    bool iconOnLeft = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: Meld.values.map((meld) {
        final count = teamMelds.where((m) => m == meld).length;

        return Row(
          children: [
            iconOnLeft
                ? SizedBox(
                    width: 40,
                    child: count > 0
                        ? IconButton(
                            icon: const Icon(
                              Symbols.delete_rounded,
                              fill: 0,
                              size: 20,
                            ),
                            color: colorScheme.error,
                            onPressed: () => onRemoveMeld(meld),
                          )
                        : null,
                  )
                : SizedBox(
                    width: 40,
                    child: count > 0
                        ? Text(
                            "x$count",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )
                        : null,
                  ),

            const SizedBox(width: 4),

            Expanded(
              child: OutlinedButton(
                onPressed: () => onAddMeld(meld),
                style: OutlinedButton.styleFrom(
                  textStyle: textTheme.labelMedium,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text("${meld.value}"),
              ),
            ),

            const SizedBox(width: 4),

            iconOnLeft
                ? SizedBox(
                    width: 40,
                    child: count > 0
                        ? Text(
                            "x$count",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )
                        : null,
                  )
                : SizedBox(
                    width: 40,
                    child: count > 0
                        ? IconButton(
                            icon: const Icon(
                              Symbols.delete_rounded,
                              fill: 0,
                              size: 20,
                            ),
                            color: colorScheme.error,
                            onPressed: () => onRemoveMeld(meld),
                          )
                        : null,
                  ),
          ],
        );
      }).toList(),
    );
  }

  String? _validateCardPoints(String? points) {
    if (points == null || points.trim().isEmpty) {
      return "Unesite broj bodova";
    }

    final parsedPoints = int.tryParse(points.trim());

    if (parsedPoints == null || parsedPoints < 0 || parsedPoints > 162) {
      return "Broj bodova mora biti između 0 i 162";
    }

    return null;
  }
}
