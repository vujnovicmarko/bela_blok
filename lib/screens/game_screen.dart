import 'package:bela_blok/database/database_helper.dart';
import 'package:bela_blok/models/game.dart';
import 'package:bela_blok/models/round.dart';
import 'package:bela_blok/widgets/add_round_dialog.dart';
import 'package:bela_blok/widgets/empty_screen_placeholder.dart';
import 'package:bela_blok/widgets/round_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class GameScreen extends StatefulWidget {
  final Game game;

  const GameScreen({super.key, required this.game});

  @override
  State<StatefulWidget> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Round> _rounds = [];
  bool _isLoading = false;
  bool _isFabVisible = true;

  @override
  void initState() {
    super.initState();
    loadRounds();
  }

  Future<void> loadRounds() async {
    setState(() => _isLoading = true);

    final rounds = await DatabaseHelper.instance.getRoundsForGame(widget.game);

    if (!mounted) return;

    rounds.sort(
      (r1, r2) => (r1.roundNumber ?? 0).compareTo(r2.roundNumber ?? 0),
    );

    setState(() {
      _rounds = rounds;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        offset: _isFabVisible ? Offset.zero : const Offset(0, 2),
        child: FloatingActionButton(
          onPressed: _openAddRoundDialog,
          child: const Icon(Icons.add),
        ),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.reverse &&
              _isFabVisible) {
            setState(() {
              _isFabVisible = false;
            });
          } else if (notification.direction == ScrollDirection.forward &&
              !_isFabVisible) {
            setState(() {
              _isFabVisible = true;
            });
          }
          return true;
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_rounds.isEmpty) {
      return EmptyScreenPlaceholder(
        icon: Icons.sports_esports_rounded,
        title: "Nema odigranih rundi",
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
            const TextSpan(text: " za upis runde"),
          ],
        ),
        onRefresh: loadRounds,
      );
    }

    return RefreshIndicator(
      onRefresh: loadRounds,
      child: ListView.builder(
        itemCount: _rounds.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final round = _rounds[index];
          return RoundCard(round: round, loadData: loadRounds);
        },
      ),
    );
  }

  void _openAddRoundDialog() async {
    final bool? isAdded = await showAddRoundDialog(context, widget.game);

    if (isAdded == true && mounted) {
      await loadRounds();
    }
  }
}
