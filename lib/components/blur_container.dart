import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants.dart';

class BlurContainer extends StatelessWidget {
  const BlurContainer({
    super.key,
    required this.child,
    this.height = 40,
    this.width = 40,
    this.fontSize = 18,
  });

  final Widget child;
  final double height, width, fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(defaultBorderRadious / 2),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          height: height,
          width: width,
          color: theme.cardColor,
          child: Center(child: child),
        ),
      ),
    );
  }
}
