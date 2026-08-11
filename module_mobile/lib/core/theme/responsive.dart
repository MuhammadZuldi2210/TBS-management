import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;

  Responsive(this.context);

  Size get size => MediaQuery.sizeOf(context);

  double get width => size.width;
  double get height => size.height;

  // Lebar card
  double get cardWidth => width > 500 ? 420 : width * 0.9;

  // Logo
  double get logoSize => (width * 0.28).clamp(90.0, 120.0);

  // Judul
  double get titleSize => (width * 0.07).clamp(24.0, 30.0);

  // Subtitle
  double get subtitleSize => (width * 0.038).clamp(13.0, 16.0);

  // Padding
  double get horizontalPadding => width * 0.06;

  // Radius
  double get radius => 18;

  // Spacing
  double get smallSpace => 10;

  double get mediumSpace => 18;

  double get largeSpace => 28;
}
