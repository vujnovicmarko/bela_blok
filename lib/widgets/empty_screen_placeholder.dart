import 'package:flutter/material.dart';

class EmptyScreenPlaceholder extends StatelessWidget {
  final IconData icon;
  final String title;
  final InlineSpan subtitle;
  final RefreshCallback? onRefresh;

  const EmptyScreenPlaceholder({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final outlineColor = colorScheme.outline;
    final titleStyle = textTheme.bodyLarge?.copyWith(color: outlineColor);
    final subtitleStyle = textTheme.bodyMedium?.copyWith(color: outlineColor);

    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: constraints.maxHeight,
              child: Align(
                alignment: Alignment.topCenter,
                child: IconTheme(
                  data: IconThemeData(color: outlineColor, size: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Spacer(flex: 1),
                      Icon(icon, fill: 1, size: 80),
                      Text(
                        title,
                        style: titleStyle,
                        textAlign: TextAlign.center,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: subtitleStyle,
                          children: [subtitle],
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
