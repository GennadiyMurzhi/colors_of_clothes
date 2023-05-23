import 'package:flutter/material.dart';

class ScrollbarDisappearing extends StatelessWidget {
  final bool isNeeded;
  final Widget child;

  const ScrollbarDisappearing({
    super.key,
    required this.isNeeded,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all<Color?>(
          isNeeded ? Theme.of(context).colorScheme.onSecondaryContainer : Colors.transparent,
        ),
      ),
      child: Scrollbar(
        trackVisibility: isNeeded,
        child: child,
      ),
    );
  }
}
