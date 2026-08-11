// import flutter material
import 'package:flutter/material.dart';

// Widget Grid Responsive Dashboard
class ResponsiveDashboardGrid extends StatelessWidget {
  // daftar widget
  final List<Widget> children;

  const ResponsiveDashboardGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;

        // desktop
        if (constraints.maxWidth >= 1200) {
          crossAxisCount = 4;
        }
        // tablet landscape
        else if (constraints.maxWidth >= 800) {
          crossAxisCount = 3;
        }
        // tablet portrait / hp besar
        else if (constraints.maxWidth >= 600) {
          crossAxisCount = 2;
        }
        // hp
        else {
          crossAxisCount = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: children.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,

            // tinggi card tetap supaya tidak overflow
            mainAxisExtent: 170,
          ),
          itemBuilder: (context, index) {
            return children[index];
          },
        );
      },
    );
  }
}
