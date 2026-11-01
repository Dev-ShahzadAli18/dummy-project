import 'package:flutter/material.dart';

enum ResponsiveSize { mobile, tablet, desktop }

class ResponsiveBreakpoints {
  const ResponsiveBreakpoints({
    this.tablet = 600,
    this.desktop = 1024,
    this.tabletInclusive = true,
    this.desktopInclusive = true,
  }) : assert(tablet >= 0),
       assert(desktop > tablet);

  final double tablet;
  final double desktop;
  final bool tabletInclusive;
  final bool desktopInclusive;

  ResponsiveSize sizeFor(double width) {
    if (_reaches(width, desktop, desktopInclusive)) {
      return ResponsiveSize.desktop;
    }
    if (_reaches(width, tablet, tabletInclusive)) {
      return ResponsiveSize.tablet;
    }
    return ResponsiveSize.mobile;
  }

  bool _reaches(double width, double breakpoint, bool inclusive) {
    return inclusive ? width >= breakpoint : width > breakpoint;
  }
}

typedef ResponsiveLayoutBuilder =
    Widget Function(
      BuildContext context,
      ResponsiveSize size,
      BoxConstraints constraints,
    );

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.breakpoints = const ResponsiveBreakpoints(),
  }) : builder = null;

  const ResponsiveLayout.builder({
    super.key,
    required ResponsiveLayoutBuilder this.builder,
    this.breakpoints = const ResponsiveBreakpoints(),
  }) : mobile = null,
       tablet = null,
       desktop = null;

  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final ResponsiveLayoutBuilder? builder;
  final ResponsiveBreakpoints breakpoints;

  static ResponsiveSize sizeOf(
    BuildContext context, {
    ResponsiveBreakpoints breakpoints = const ResponsiveBreakpoints(),
  }) {
    return breakpoints.sizeFor(MediaQuery.sizeOf(context).width);
  }

  static double widthOf(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = breakpoints.sizeFor(constraints.maxWidth);
        final layoutBuilder = builder;

        if (layoutBuilder != null) {
          return layoutBuilder(context, size, constraints);
        }

        return switch (size) {
          ResponsiveSize.mobile => mobile!,
          ResponsiveSize.tablet => tablet ?? mobile!,
          ResponsiveSize.desktop => desktop ?? tablet ?? mobile!,
        };
      },
    );
  }
}

class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    super.key,
    required this.child,
    this.maxWidth = double.infinity,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
