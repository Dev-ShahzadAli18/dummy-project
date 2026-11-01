import 'package:dummy_project/widgets/responsive_layout.dart';
import 'package:dummy_project/widgets/cart_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('selects mobile, tablet, and desktop layouts by width', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Future<void> expectLayout(double width, String expected) async {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveLayout(
            mobile: const Text('mobile'),
            tablet: const Text('tablet'),
            desktop: const Text('desktop'),
          ),
        ),
      );

      expect(find.text(expected), findsOneWidget);
    }

    await expectLayout(400, 'mobile');
    await expectLayout(800, 'tablet');
    await expectLayout(1200, 'desktop');
  });

  testWidgets('builder receives the current responsive size', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final (width, expected) in [
      (400.0, 'mobile'),
      (800.0, 'tablet'),
      (1200.0, 'desktop'),
    ]) {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveLayout.builder(
            builder: (context, size, constraints) => Text(size.name),
          ),
        ),
      );

      expect(find.text(expected), findsOneWidget);
    }
  });

  testWidgets('tablet layout is optional', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    tester.view.physicalSize = const Size(800, 800);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(
      const MaterialApp(
        home: ResponsiveLayout(
          mobile: Text('mobile'),
          desktop: Text('desktop'),
        ),
      ),
    );

    expect(find.text('mobile'), findsOneWidget);
  });

  test('supports strict and inclusive breakpoint boundaries', () {
    const strict = ResponsiveBreakpoints(
      tablet: 600,
      desktop: 1100,
      tabletInclusive: false,
      desktopInclusive: false,
    );

    expect(strict.sizeFor(600), ResponsiveSize.mobile);
    expect(strict.sizeFor(600.1), ResponsiveSize.tablet);
    expect(strict.sizeFor(1100), ResponsiveSize.tablet);
    expect(strict.sizeFor(1100.1), ResponsiveSize.desktop);
    expect(const ResponsiveBreakpoints().sizeFor(600), ResponsiveSize.tablet);
  });

  testWidgets('ResponsiveContent centers content inside its width cap', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(
      MaterialApp(
        home: ResponsiveContent(
          maxWidth: 600,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const SizedBox(
            key: ValueKey('content'),
            width: double.infinity,
            height: 50,
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(const ValueKey('content'))).width, 560);
    expect(tester.getTopLeft(find.byKey(const ValueKey('content'))).dx, 320);
  });

  testWidgets('productImage displays the configured empty image icon', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 72,
          height: 64,
          child: productImage(
            imageUrl: '',
            width: 72,
            height: 64,
            emptyIcon: Icons.shopping_bag_outlined,
            placeholderColor: Colors.grey,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });
}
