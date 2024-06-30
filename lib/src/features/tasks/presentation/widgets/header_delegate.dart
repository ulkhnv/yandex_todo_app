import 'dart:math';

import 'package:flutter/material.dart';

import '/src/core/utils/utils.dart';

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double shift = min(1, shrinkOffset / (maxExtent - minExtent));
    return Material(
      elevation: shift < 0.6 ? 0.1 : 4 * shift,
      child: Container(
        color: context.colorScheme.background,
        child: Stack(
          children: [
            Positioned(
              left: 60 - 44 * shift,
              top: 94 - 54 * shift,
              child: Text(
               context.localizations.taskTitle,
                style: context.textTheme.titleLarge!.copyWith(
                  fontSize: 38 - 14 * shift,
                ),
              ),
            ),
            Positioned(
              left: 60 - 44 * shift,
              top: 140 - 70 * shift,
              child: Opacity(
                opacity: shift < 0.6 ? 1 - shift : 0,
                child: Text(
                  context.localizations.taskSubtitle(0),
                  style: context.textTheme.bodyMedium!
                      .copyWith(color: context.colorScheme.tertiary),
                ),
              ),
            ),
            Positioned(
              right: 16,
              top: 125 - 93 * shift,
              child: IconButton(
                icon: Icon(
                  Icons.visibility,
                  color: context.customColors.blue,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 160.0;

  @override
  double get minExtent => 88.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
