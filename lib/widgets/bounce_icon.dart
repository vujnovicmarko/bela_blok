import 'package:flutter/material.dart';

class BounceIcon extends StatefulWidget {
  final IconData icon;
  final double fill;
  final int index;
  final ValueNotifier<int> selectedIndexNotifier;
  final Color? color;

  const BounceIcon({
    super.key,
    required this.icon,
    this.fill = 1,
    required this.index,
    required this.selectedIndexNotifier,
    this.color,
  });

  @override
  State<BounceIcon> createState() => _BounceIconState();
}

class _BounceIconState extends State<BounceIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 125),
      reverseDuration: const Duration(milliseconds: 125),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    widget.selectedIndexNotifier.addListener(_handleIndexChange);
  }

  void _handleIndexChange() {
    if (widget.selectedIndexNotifier.value == widget.index) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    widget.selectedIndexNotifier.removeListener(_handleIndexChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Icon(widget.icon, fill: widget.fill, color: widget.color),
    );
  }
}
