import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ViewportOffset;

class PageViewWithCacheExtent extends StatelessWidget {
  const PageViewWithCacheExtent({
    Key? key,
    required this.controller,
    required this.childDelegate,
    this.onPageChanged,
    this.cachedPages = 0,
    this.physics,
  })  : assert(controller != null),
        assert(childDelegate != null),
        super(key: key);

  final PageController controller;
  final ValueChanged<int>? onPageChanged;
  final SliverChildDelegate childDelegate;
  final int cachedPages;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification.depth == 0 &&
            notification is ScrollUpdateNotification) {
          final PageMetrics metrics = notification.metrics as PageMetrics;
          onPageChanged?.call(metrics.page!.round());
        }
        return false;
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Scrollable(
            axisDirection: AxisDirection.down,
            controller: controller,
            physics: const PageScrollPhysics().applyTo(physics),
            viewportBuilder: (BuildContext context, ViewportOffset position) {
              final cacheExtent = constraints.maxWidth *
                  controller.viewportFraction *
                  cachedPages;
              return Viewport(
                axisDirection: AxisDirection.down,
                offset: position,
                cacheExtent: cacheExtent,
                slivers: <Widget>[
                  SliverFillViewport(
                    viewportFraction: controller.viewportFraction,
                    delegate: childDelegate,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
