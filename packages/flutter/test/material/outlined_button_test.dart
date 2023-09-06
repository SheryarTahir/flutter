// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leak_tracker_flutter_testing/leak_tracker_flutter_testing.dart';
import '../widgets/semantics_tester.dart';

void main() {
  testWidgetsWithLeakTracking('OutlinedButton, OutlinedButton.icon defaults', (WidgetTester tester) async {
    const ColorScheme colorScheme = ColorScheme.light();
    final ThemeData theme = ThemeData.from(colorScheme: colorScheme);
    final bool material3 = theme.useMaterial3;

    // Enabled OutlinedButton
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Center(
          child: OutlinedButton(
            onPressed: () { },
            child: const Text('button'),
          ),
        ),
      ),
    );

    final Finder buttonMaterial = find.descendant(
      of: find.byType(OutlinedButton),
      matching: find.byType(Material),
    );

    Material material = tester.widget<Material>(buttonMaterial);
    expect(material.animationDuration, const Duration(milliseconds: 200));
    expect(material.borderOnForeground, true);
    expect(material.borderRadius, null);
    expect(material.clipBehavior, Clip.none);
    expect(material.color, Colors.transparent);
    expect(material.elevation, 0.0);
    expect(material.shadowColor, material3 ? Colors.transparent : const Color(0xff000000));

    expect(material.shape, material3
      ? StadiumBorder(side: BorderSide(color: colorScheme.outline))
      : RoundedRectangleBorder(
          side: BorderSide(color: colorScheme.onSurface.withOpacity(0.12)),
          borderRadius: const BorderRadius.all(Radius.circular(4))
        ));

    expect(material.textStyle!.color, colorScheme.primary);
    expect(material.textStyle!.fontFamily, 'Roboto');
    expect(material.textStyle!.fontSize, 14);
    expect(material.textStyle!.fontWeight, FontWeight.w500);
    expect(material.type, MaterialType.button);

    final Align align = tester.firstWidget<Align>(find.ancestor(of: find.text('button'), matching: find.byType(Align)));
    expect(align.alignment, Alignment.center);

    final Offset center = tester.getCenter(find.byType(OutlinedButton));
    final TestGesture gesture = await tester.startGesture(center);
    await tester.pump(); // start the splash animation
    await tester.pump(const Duration(milliseconds: 100)); // splash is underway

    // Material 3 uses the InkSparkle which uses a shader, so we can't capture
    // the effect with paint methods.
    if (!material3) {
      final RenderObject inkFeatures = tester.allRenderObjects.firstWhere((RenderObject object) => object.runtimeType.toString() == '_RenderInkFeatures');
      expect(inkFeatures, paints..circle(color: colorScheme.primary.withOpacity(0.12)));
    }

    await gesture.up();
    await tester.pumpAndSettle();
    // No change vs enabled and not pressed.
    material = tester.widget<Material>(buttonMaterial);
    expect(material.animationDuration, const Duration(milliseconds: 200));
    expect(material.borderOnForeground, true);
    expect(material.borderRadius, null);
    expect(material.clipBehavior, Clip.none);
    expect(material.color, Colors.transparent);
    expect(material.elevation, 0.0);
    expect(material.shadowColor, material3 ? Colors.transparent : const Color(0xff000000));

    expect(material.shape, material3
      ? StadiumBorder(side: BorderSide(color: colorScheme.outline))
      : RoundedRectangleBorder(
          side: BorderSide(color: colorScheme.onSurface.withOpacity(0.12)),
          borderRadius: const BorderRadius.all(Radius.circular(4))
        ));

    expect(material.textStyle!.color, colorScheme.primary);
    expect(material.textStyle!.fontFamily, 'Roboto');
    expect(material.textStyle!.fontSize, 14);
    expect(material.textStyle!.fontWeight, FontWeight.w500);
    expect(material.type, MaterialType.button);

    // Enabled OutlinedButton.icon
    final Key iconButtonKey = UniqueKey();
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Center(
          child: OutlinedButton.icon(
            key: iconButtonKey,
            onPressed: () { },
            icon: const Icon(Icons.add),
            label: const Text('label'),
          ),
        ),
      ),
    );

    final Finder iconButtonMaterial = find.descendant(
      of: find.byKey(iconButtonKey),
      matching: find.byType(Material),
    );

    material = tester.widget<Material>(iconButtonMaterial);
    expect(material.animationDuration, const Duration(milliseconds: 200));
    expect(material.borderOnForeground, true);
    expect(material.borderRadius, null);
    expect(material.clipBehavior, Clip.none);
    expect(material.color, Colors.transparent);
    expect(material.elevation, 0.0);
    expect(material.shadowColor, material3 ? Colors.transparent : const Color(0xff000000));

    expect(material.shape, material3
        ? StadiumBorder(side: BorderSide(color: colorScheme.outline))
        : RoundedRectangleBorder(
            side: BorderSide(color: colorScheme.onSurface.withOpacity(0.12)),
            borderRadius: const BorderRadius.all(Radius.circular(4))
        ));

    expect(material.textStyle!.color, colorScheme.primary);
    expect(material.textStyle!.fontFamily, 'Roboto');
    expect(material.textStyle!.fontSize, 14);
    expect(material.textStyle!.fontWeight, FontWeight.w500);
    expect(material.type, MaterialType.button);

    // Disabled OutlinedButton
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: const Center(
          child: OutlinedButton(
            onPressed: null,
            child: Text('button'),
          ),
        ),
      ),
    );

    material = tester.widget<Material>(buttonMaterial);
    expect(material.animationDuration, const Duration(milliseconds: 200));
    expect(material.borderOnForeground, true);
    expect(material.borderRadius, null);
    expect(material.clipBehavior, Clip.none);
    expect(material.color, Colors.transparent);
    expect(material.elevation, 0.0);
    expect(material.shadowColor, material3 ? Colors.transparent : const Color(0xff000000));

    expect(material.shape, material3
        ? StadiumBorder(side: BorderSide(color: colorScheme.onSurface.withOpacity(0.12)))
        : RoundedRectangleBorder(
        side: BorderSide(color: colorScheme.onSurface.withOpacity(0.12)),
        borderRadius: const BorderRadius.all(Radius.circular(4))
    ));

    expect(material.textStyle!.color, colorScheme.onSurface.withOpacity(0.38));
    expect(material.textStyle!.fontFamily, 'Roboto');
    expect(material.textStyle!.fontSize, 14);
    expect(material.textStyle!.fontWeight, FontWeight.w500);
    expect(material.type, MaterialType.button);
  });

  testWidgetsWithLeakTracking('OutlinedButton default overlayColor resolves pressed state', (WidgetTester tester) async {
    final FocusNode focusNode = FocusNode();
    final ThemeData theme = ThemeData(useMaterial3: true);

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Scaffold(
          body: Center(
            child: Builder(
              builder: (BuildContext context) {
                return OutlinedButton(
                  onPressed: () {},
                  focusNode: focusNode,
                  child: const Text('OutlinedButton'),
                );
              },
            ),
          ),
        ),
      ),
    );

    RenderObject overlayColor() {
      return tester.allRenderObjects.firstWhere((RenderObject object) => object.runtimeType.toString() == '_RenderInkFeatures');
    }

    // Hovered.
    final Offset center = tester.getCenter(find.byType(OutlinedButton));
    final TestGesture gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await gesture.addPointer();
    await gesture.moveTo(center);
    await tester.pumpAndSettle();
    expect(overlayColor(), paints..rect(color: theme.colorScheme.primary.withOpacity(0.08)));

    // Highlighted (pressed).
    await gesture.down(center);
    await tester.pumpAndSettle();
    expect(overlayColor(), paints..rect()..rect(color: theme.colorScheme.primary.withOpacity(0.12)));
    // Remove pressed and hovered states
    await gesture.up();
    await tester.pumpAndSettle();
    await gesture.moveTo(const Offset(0, 50));
    await tester.pumpAndSettle();

    // Focused.
    focusNode.requestFocus();
    await tester.pumpAndSettle();
    expect(overlayColor(), paints..rect(color: theme.colorScheme.primary.withOpacity(0.12)));

    focusNode.dispose();
  });

  testWidgetsWithLeakTracking('Does OutlinedButton work with hover', (WidgetTester tester) async {
    const Color hoverColor = Color(0xff001122);

    Color? getOverlayColor(Set<MaterialState> states) {
      return states.contains(MaterialState.hovered) ? hoverColor : null;
    }

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: OutlinedButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(getOverlayColor),
          ),
          onPressed: () { },
          child: const Text('button'),
        ),
      ),
    );

    final TestGesture gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    await gesture.moveTo(tester.getCenter(find.byType(OutlinedButton)));
    await tester.pumpAndSettle();
    final RenderObject inkFeatures = tester.allRenderObjects.firstWhere((RenderObject object) => object.runtimeType.toString() == '_RenderInkFeatures');
    expect(inkFeatures, paints..rect(color: hoverColor));
  });

  testWidgetsWithLeakTracking('Does OutlinedButton work with focus', (WidgetTester tester) async {
    const Color focusColor = Color(0xff001122);

    Color? getOverlayColor(Set<MaterialState> states) {
      return states.contains(MaterialState.focused) ? focusColor : null;
    }

    final FocusNode focusNode = FocusNode(debugLabel: 'OutlinedButton Node');
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: OutlinedButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(getOverlayColor),
          ),
          focusNode: focusNode,
          onPressed: () { },
          child: const Text('button'),
        ),
      ),
    );

    FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTraditional;
    focusNode.requestFocus();
    await tester.pumpAndSettle();

    final RenderObject inkFeatures = tester.allRenderObjects.firstWhere((RenderObject object) => object.runtimeType.toString() == '_RenderInkFeatures');
    expect(inkFeatures, paints..rect(color: focusColor));

    focusNode.dispose();
  });

  testWidgetsWithLeakTracking('Does OutlinedButton work with autofocus', (WidgetTester tester) async {
    const Color focusColor = Color(0xff001122);

    Color? getOverlayColor(Set<MaterialState> states) {
      return states.contains(MaterialState.focused) ? focusColor : null;
    }

    final FocusNode focusNode = FocusNode(debugLabel: 'OutlinedButton Node');
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: OutlinedButton(
          autofocus: true,
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(getOverlayColor),
          ),
          focusNode: focusNode,
          onPressed: () { },
          child: const Text('button'),
        ),
      ),
    );

    FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTraditional;
    await tester.pumpAndSettle();

    final RenderObject inkFeatures = tester.allRenderObjects.firstWhere((RenderObject object) => object.runtimeType.toString() == '_RenderInkFeatures');
    expect(inkFeatures, paints..rect(color: focusColor));

    focusNode.dispose();
  });

  testWidgets('Default OutlinedButton meets a11y contrast guidelines', (WidgetTester tester) async {
    final FocusNode focusNode = FocusNode();

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.from(colorScheme: const ColorScheme.light()),
        home: Scaffold(
          body: Center(
            child: OutlinedButton(
              onPressed: () {},
              focusNode: focusNode,
              child: const Text('OutlinedButton'),
            ),
          ),
        ),
      ),
    );

    // Default, not disabled.
    await expectLater(tester, meetsGuideline(textContrastGuideline));

    // Hovered.
    final Offset center = tester.getCenter(find.byType(OutlinedButton));
    final TestGesture gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await gesture.addPointer();
    await gesture.moveTo(center);
    await tester.pumpAndSettle();
    await expectLater(tester, meetsGuideline(textContrastGuideline));

    // Highlighted (pressed).
    await gesture.down(center);
    await tester.pump(); // Start the splash and highlight animations.
    await tester.pump(const Duration(milliseconds: 800)); // Wait for splash and highlight to be well under way.
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await gesture.up();
    await tester.pumpAndSettle();

    // Focused.
    focusNode.requestFocus();
    await tester.pumpAndSettle();
    await expectLater(tester, meetsGuideline(textContrastGuideline));

    focusNode.dispose();
  },
    skip: isBrowser, // https://github.com/flutter/flutter/issues/44115
  );

  testWidgets('OutlinedButton with colored theme meets a11y contrast guidelines', (WidgetTester tester) async {
    final FocusNode focusNode = FocusNode();

    Color getTextColor(Set<MaterialState> states) {
      final Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue[900]!;
      }
      return Colors.blue[800]!;
    }

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.from(colorScheme: ColorScheme.fromSwatch()),
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: OutlinedButtonTheme(
              data: OutlinedButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(getTextColor),
                ),
              ),
              child: Builder(
                builder: (BuildContext context) {
                  return OutlinedButton(
                    onPressed: () {},
                    focusNode: focusNode,
                    child: const Text('OutlinedButton'),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    // Default, not disabled.
    await expectLater(tester, meetsGuideline(textContrastGuideline));

    // Focused.
    focusNode.requestFocus();
    await tester.pumpAndSettle();
    await expectLater(tester, meetsGuideline(textContrastGuideline));

    // Hovered.
    final Offset center = tester.getCenter(find.byType(OutlinedButton));
    final TestGesture gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await gesture.addPointer();
    await gesture.moveTo(center);
    await tester.pumpAndSettle();
    await expectLater(tester, meetsGuideline(textContrastGuideline));

    // Highlighted (pressed).
    await gesture.down(center);
    await tester.pump(); // Start the splash and highlight animations.
    await tester.pump(const Duration(milliseconds: 800)); // Wait for splash and highlight to be well under way.
    await expectLater(tester, meetsGuideline(textContrastGuideline));

    focusNode.dispose();
  },
    skip: isBrowser, // https://github.com/flutter/flutter/issues/44115
  );

  testWidgetsWithLeakTracking('OutlinedButton uses stateful color for text color in different states', (WidgetTester tester) async {
    final FocusNode focusNode = FocusNode();

    const Color pressedColor = Color(0x00000001);
    const Color hoverColor = Color(0x00000002);
    const Color focusedColor = Color(0x00000003);
    const Color defaultColor = Color(0x00000004);

    Color getTextColor(Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return pressedColor;
      }
      if (states.contains(MaterialState.hovered)) {
        return hoverColor;
      }
      if (states.contains(MaterialState.focused)) {
        return focusedColor;
      }
      return defaultColor;
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: OutlinedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith<Color>(getTextColor),
              ),
              onPressed: () {},
              focusNode: focusNode,
              child: const Text('OutlinedButton'),
            ),
          ),
        ),
      ),
    );

    Color textColor() {
      return tester.renderObject<RenderParagraph>(find.text('OutlinedButton')).text.style!.color!;
    }

    // Default, not disabled.
    expect(textColor(), equals(defaultColor));

    // Focused.
    focusNode.requestFocus();
    await tester.pumpAndSettle();
    expect(textColor(), focusedColor);

    // Hovered.
    final Offset center = tester.getCenter(find.byType(OutlinedButton));
    final TestGesture gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await gesture.addPointer();
    await gesture.moveTo(center);
    await tester.pumpAndSettle();
    expect(textColor(), hoverColor);

    // Highlighted (pressed).
    await gesture.down(center);
    await tester.pump(); // Start the splash and highlight animations.
    await tester.pump(const Duration(milliseconds: 800)); // Wait for splash and highlight to be well under way.
    expect(textColor(), pressedColor);

    focusNode.dispose();
  });

  testWidgetsWithLeakTracking('OutlinedButton uses stateful color for icon color in different states', (WidgetTester tester) async {
    final FocusNode focusNode = FocusNode();
    final Key buttonKey = UniqueKey();

    const Color pressedColor = Color(0x00000001);
    const Color hoverColor = Color(0x00000002);
    const Color focusedColor = Color(0x00000003);
    const Color defaultColor = Color(0x00000004);

    Color getIconColor(Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return pressedColor;
      }
      if (states.contains(MaterialState.hovered)) {
        return hoverColor;
      }
      if (states.contains(MaterialState.focused)) {
        return focusedColor;
      }
      return defaultColor;
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: OutlinedButton.icon(
              key: buttonKey,
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith<Color>(getIconColor),
              ),
              icon: const Icon(Icons.add),
              label: const Text('OutlinedButton'),
              onPressed: () {},
              focusNode: focusNode,
            ),
          ),
        ),
      ),
    );

    Color iconColor() => _iconStyle(tester, Icons.add).color!;
    // Default, not disabled.
    expect(iconColor(), equals(defaultColor));

    // Focused.
    focusNode.requestFocus();
    await tester.pumpAndSettle();
    expect(iconColor(), focusedColor);

    // Hovered.
    final Offset center = tester.getCenter(find.byKey(buttonKey));
    final TestGesture gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await gesture.addPointer();
    await gesture.moveTo(center);
    await tester.pumpAndSettle();
    expect(iconColor(), hoverColor);

    // Highlighted (pressed).
    await gesture.down(center);
    await tester.pump(); // Start the splash and highlight animations.
    await tester.pump(const Duration(milliseconds: 800)); // Wait for splash and highlight to be well under way.
    expect(iconColor(), pressedColor);

    focusNode.dispose();
  });

  testWidgetsWithLeakTracking('OutlinedButton uses stateful color for border color in different states', (WidgetTester tester) async {
    final FocusNode focusNode = FocusNode();

    const Color pressedColor = Color(0x00000001);
    const Color hoverColor = Color(0x00000002);
    const Color focusedColor = Color(0x00000003);
    const Color defaultColor = Color(0x00000004);

    BorderSide getBorderSide(Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return const BorderSide(color: pressedColor);
      }
      if (states.contains(MaterialState.hovered)) {
        return const BorderSide(color: hoverColor);
      }
      if (states.contains(MaterialState.focused)) {
        return const BorderSide(color: focusedColor);
      }
      return const BorderSide(color: defaultColor);
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: OutlinedButton(
              style: ButtonStyle(
                side: MaterialStateProperty.resolveWith<BorderSide>(getBorderSide),
                // Test assumes a rounded rect for the shape
                shape: ButtonStyleButton.allOrNull(
                  const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)))
                ),
              ),
              onPressed: () {},
              focusNode: focusNode,
              child: const Text('OutlinedButton'),
            ),
          ),
        ),
      ),
    );

    final Finder outlinedButton = find.byType(OutlinedButton);

    // Default, not disabled.
    expect(outlinedButton, paints..drrect(color: defaultColor));

    // Focused.
    focusNode.requestFocus();
    await tester.pumpAndSettle();
    expect(outlinedButton, paints..drrect(color: focusedColor));

    // Hovered.
    final Offset center = tester.getCenter(find.byType(OutlinedButton));
    final TestGesture gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await gesture.addPointer();
    await gesture.moveTo(center);
    await tester.pumpAndSettle();
    expect(outlinedButton, paints..drrect(color: hoverColor));

    // Highlighted (pressed).
    await gesture.down(center);
    await tester.pumpAndSettle();
    expect(outlinedButton, paints..drrect(color: pressedColor));

    focusNode.dispose();
  });

  testWidgetsWithLeakTracking('OutlinedButton onPressed and onLongPress callbacks are correctly called when non-null', (WidgetTester tester) async {

    bool wasPressed;
    Finder outlinedButton;

    Widget buildFrame({ VoidCallback? onPressed, VoidCallback? onLongPress }) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: OutlinedButton(
          onPressed: onPressed,
          onLongPress: onLongPress,
          child: const Text('button'),
        ),
      );
    }

    // onPressed not null, onLongPress null.
    wasPressed = false;
    await tester.pumpWidget(
      buildFrame(onPressed: () { wasPressed = true; }),
    );
    outlinedButton = find.byType(OutlinedButton);
    expect(tester.widget<OutlinedButton>(outlinedButton).enabled, true);
    await tester.tap(outlinedButton);
    expect(wasPressed, true);

    // onPressed null, onLongPress not null.
    wasPressed = false;
    await tester.pumpWidget(
      buildFrame(onLongPress: () { wasPressed = true; }),
    );
    outlinedButton = find.byType(OutlinedButton);
    expect(tester.widget<OutlinedButton>(outlinedButton).enabled, true);
    await tester.longPress(outlinedButton);
    expect(wasPressed, true);

    // onPressed null, onLongPress null.
    await tester.pumpWidget(
      buildFrame(),
    );
    outlinedButton = find.byType(OutlinedButton);
    expect(tester.widget<OutlinedButton>(outlinedButton).enabled, false);
  });

  testWidgetsWithLeakTracking("OutlinedButton response doesn't hover when disabled", (WidgetTester tester) async {
    FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTouch;
    final FocusNode focusNode = FocusNode(debugLabel: 'OutlinedButton Focus');
    final GlobalKey childKey = GlobalKey();
    bool hovering = false;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 100,
          height: 100,
          child: OutlinedButton(
            autofocus: true,
            onPressed: () {},
            onLongPress: () {},
            onHover: (bool value) { hovering = value; },
            focusNode: focusNode,
            child: SizedBox(key: childKey),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(focusNode.hasPrimaryFocus, isTrue);
    final TestGesture gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    await gesture.moveTo(tester.getCenter(find.byKey(childKey)));
    await tester.pumpAndSettle();
    expect(hovering, isTrue);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 100,
          height: 100,
          child: OutlinedButton(
            focusNode: focusNode,
            onHover: (bool value) { hovering = value; },
            onPressed: null,
            child: SizedBox(key: childKey),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(focusNode.hasPrimaryFocus, isFalse);

    focusNode.dispose();
  });

  testWidgetsWithLeakTracking('disabled and hovered OutlinedButton responds to mouse-exit', (WidgetTester tester) async {
    int onHoverCount = 0;
    late bool hover;

    Widget buildFrame({ required bool enabled }) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: OutlinedButton(
              onPressed: enabled ? () { } : null,
              onHover: (bool value) {
                onHoverCount += 1;
                hover = value;
              },
              child: const Text('OutlinedButton'),
            ),
          ),
        ),
      );
    }

    await tester.pumpWidget(buildFrame(enabled: true));
    final TestGesture gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();

    await gesture.moveTo(tester.getCenter(find.byType(OutlinedButton)));
    await tester.pumpAndSettle();
    expect(onHoverCount, 1);
    expect(hover, true);

    await tester.pumpWidget(buildFrame(enabled: false));
    await tester.pumpAndSettle();
    await gesture.moveTo(Offset.zero);
    // Even though the OutlinedButton has been disabled, the mouse-exit still
    // causes onHover(false) to be called.
    expect(onHoverCount, 2);
    expect(hover, false);

    await gesture.moveTo(tester.getCenter(find.byType(OutlinedButton)));
    await tester.pumpAndSettle();
    // We no longer see hover events because the OutlinedButton is disabled
    // and it's no longer in the "hovering" state.
    expect(onHoverCount, 2);
    expect(hover, false);

    await tester.pumpWidget(buildFrame(enabled: true));
    await tester.pumpAndSettle();
    // The OutlinedButton was enabled while it contained the mouse, however
    // we do not call onHover() because it may call setState().
    expect(onHoverCount, 2);
    expect(hover, false);

    await gesture.moveTo(tester.getCenter(find.byType(OutlinedButton)) - const Offset(1, 1));
    await tester.pumpAndSettle();
    // Moving the mouse a little within the OutlinedButton doesn't change anything.
    expect(onHoverCount, 2);
    expect(hover, false);
  });

  testWidgetsWithLeakTracking('Can set OutlinedButton focus and Can set unFocus.', (WidgetTester tester) async {
    final FocusNode node = FocusNode(debugLabel: 'OutlinedButton Focus');
    bool gotFocus = false;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: OutlinedButton(
          focusNode: node,
          onFocusChange: (bool focused) => gotFocus = focused,
          onPressed: () {  },
          child: const SizedBox(),
        ),
      ),
    );

    node.requestFocus();

    await tester.pump();

    expect(gotFocus, isTrue);
    expect(node.hasFocus, isTrue);

    node.unfocus();
    await tester.pump();

    expect(gotFocus, isFalse);
    expect(node.hasFocus, isFalse);

    node.dispose();
  });

  testWidgetsWithLeakTracking('When OutlinedButton disable, Can not set OutlinedButton focus.', (WidgetTester tester) async {
    final FocusNode node = FocusNode(debugLabel: 'OutlinedButton Focus');
    bool gotFocus = false;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: OutlinedButton(
          focusNode: node,
          onFocusChange: (bool focused) => gotFocus = focused,
          onPressed: null,
          child: const SizedBox(),
        ),
      ),
    );

    node.requestFocus();

    await tester.pump();

    expect(gotFocus, isFalse);
    expect(node.hasFocus, isFalse);

    node.dispose();
  });

  testWidgetsWithLeakTracking("Outline button doesn't crash if disabled during a gesture", (WidgetTester tester) async {
    Widget buildFrame(VoidCallback? onPressed) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Theme(
          data: ThemeData(),
          child: Center(
            child: OutlinedButton(onPressed: onPressed, child: const Text('button')),
          ),
        ),
      );
    }

    await tester.pumpWidget(buildFrame(() {}));
    await tester.press(find.byType(OutlinedButton));
    await tester.pumpAndSettle();
    await tester.pumpWidget(buildFrame(null));
    await tester.pumpAndSettle();
  });

  testWidgetsWithLeakTracking('OutlinedButton shape and border component overrides', (WidgetTester tester) async {
    const Color fillColor = Color(0xFF00FF00);
    const BorderSide disabledBorderSide = BorderSide(color: Color(0xFFFF0000), width: 3);
    const BorderSide enabledBorderSide = BorderSide(color: Color(0xFFFF00FF), width: 4);
    const BorderSide pressedBorderSide = BorderSide(color: Color(0xFF0000FF), width: 5);

    Widget buildFrame({ VoidCallback? onPressed }) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Theme(
          data: ThemeData(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, textTheme: Typography.englishLike2014),
          child: Container(
            alignment: Alignment.topLeft,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: const RoundedRectangleBorder(), // default border radius is 0
                backgroundColor: fillColor,
                minimumSize: const Size(64, 36),
              ).copyWith(
                side: MaterialStateProperty.resolveWith<BorderSide>((Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return disabledBorderSide;
                  }
                  if (states.contains(MaterialState.pressed)) {
                    return pressedBorderSide;
                  }
                  return enabledBorderSide;
                }),
              ),
              clipBehavior: Clip.antiAlias,
              onPressed: onPressed,
              child: const Text('button'),
            ),
          ),
        ),
      );
    }
    final Finder outlinedButton = find.byType(OutlinedButton);

    BorderSide getBorderSide() {
      final OutlinedBorder border = tester.widget<Material>(
        find.descendant(of: outlinedButton, matching: find.byType(Material)),
      ).shape! as OutlinedBorder;
      return border.side;
    }

    // Pump a button with a null onPressed callback to make it disabled.
    await tester.pumpWidget(
      buildFrame(),
    );

    // Expect that the button is disabled and painted with the disabled border color.
    expect(tester.widget<OutlinedButton>(outlinedButton).enabled, false);
    expect(getBorderSide(), disabledBorderSide);

    // Pump a new button with a no-op onPressed callback to make it enabled.
    await tester.pumpWidget(
      buildFrame(onPressed: () {}),
    );

    // Wait for the border color to change from disabled to enabled.
    await tester.pumpAndSettle();
    expect(getBorderSide(), enabledBorderSide);

    final Offset center = tester.getCenter(outlinedButton);
    final TestGesture gesture = await tester.startGesture(center);
    await tester.pump(); // start gesture

    // Wait for the border's color to change to pressed
    await tester.pump(const Duration(milliseconds: 200));
    expect(getBorderSide(), pressedBorderSide);

    // Tap gesture completes, button returns to its initial configuration.
    await gesture.up();
    await tester.pumpAndSettle();
    expect(getBorderSide(), enabledBorderSide);
  });

  testWidgetsWithLeakTracking('OutlinedButton has no clip by default', (WidgetTester tester) async {
    final GlobalKey buttonKey = GlobalKey();
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: OutlinedButton(
            key: buttonKey,
            onPressed: () {},
            child: const Text('ABC'),
          ),
        ),
      ),
    );

    expect(
        tester.renderObject(find.byKey(buttonKey)),
        paintsExactlyCountTimes(#clipPath, 0),
    );
  });


  testWidgetsWithLeakTracking('OutlinedButton contributes semantics', (WidgetTester tester) async {
    final SemanticsTester semantics = SemanticsTester(tester);
    await tester.pumpWidget(
      Theme(
        data: ThemeData(useMaterial3: false),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: OutlinedButton(
              style: const ButtonStyle(
                // Specifying minimumSize to mimic the original minimumSize for
                // RaisedButton so that the corresponding button size matches
                // the original version of this test.
                minimumSize: MaterialStatePropertyAll<Size>(Size(88, 36)),
              ),
              onPressed: () {},
              child: const Text('ABC'),
            ),
          ),
        ),
      ),
    );

    expect(semantics, hasSemantics(
      TestSemantics.root(
        children: <TestSemantics>[
          TestSemantics.rootChild(
            actions: <SemanticsAction>[
              SemanticsAction.tap,
            ],
            label: 'ABC',
            rect: const Rect.fromLTRB(0.0, 0.0, 88.0, 48.0),
            transform: Matrix4.translationValues(356.0, 276.0, 0.0),
            flags: <SemanticsFlag>[
              SemanticsFlag.hasEnabledState,
              SemanticsFlag.isButton,
              SemanticsFlag.isEnabled,
              SemanticsFlag.isFocusable,
            ],
          ),
        ],
      ),
      ignoreId: true,
    ));

    semantics.dispose();
  });

  testWidgetsWithLeakTracking('OutlinedButton scales textScaleFactor', (WidgetTester tester) async {
    await tester.pumpWidget(
      Theme(
        data: ThemeData(useMaterial3: false),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(),
            child: Center(
              child: OutlinedButton(
                style: const ButtonStyle(
                  // Specifying minimumSize to mimic the original minimumSize for
                  // RaisedButton so that the corresponding button size matches
                  // the original version of this test.
                  minimumSize: MaterialStatePropertyAll<Size>(Size(88, 36)),
                ),
                onPressed: () {},
                child: const Text('ABC'),
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(OutlinedButton)), equals(const Size(88.0, 48.0)));
    expect(tester.getSize(find.byType(Text)), equals(const Size(42.0, 14.0)));

    // textScaleFactor expands text, but not button.
    await tester.pumpWidget(
      Theme(
        // Force Material 2 typography.
        data: ThemeData(useMaterial3: false),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(textScaleFactor: 1.25),
            child: Center(
              child: OutlinedButton(
                style: const ButtonStyle(
                  // Specifying minimumSize to mimic the original minimumSize for
                  // RaisedButton so that the corresponding button size matches
                  // the original version of this test.
                  minimumSize: MaterialStatePropertyAll<Size>(Size(88, 36)),
                ),
                onPressed: () {},
                child: const Text('ABC'),
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(OutlinedButton)), equals(const Size(88.0, 48.0)));
    expect(tester.getSize(find.byType(Text)), const Size(52.5, 18.0));

    // Set text scale large enough to expand text and button.
    await tester.pumpWidget(
      Theme(
        data: ThemeData(useMaterial3: false),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(textScaleFactor: 3.0),
            child: Center(
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('ABC'),
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(OutlinedButton)), const Size(134.0, 48.0));
    expect(tester.getSize(find.byType(Text)), const Size(126.0, 42.0));
  }, skip: kIsWeb && !isCanvasKit); // https://github.com/flutter/flutter/issues/122066

  testWidgetsWithLeakTracking('OutlinedButton onPressed and onLongPress callbacks are distinctly recognized', (WidgetTester tester) async {
    bool didPressButton = false;
    bool didLongPressButton = false;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: OutlinedButton(
          onPressed: () {
            didPressButton = true;
          },
          onLongPress: () {
            didLongPressButton = true;
          },
          child: const Text('button'),
        ),
      ),
    );

    final Finder outlinedButton = find.byType(OutlinedButton);
    expect(tester.widget<OutlinedButton>(outlinedButton).enabled, true);

    expect(didPressButton, isFalse);
    await tester.tap(outlinedButton);
    expect(didPressButton, isTrue);

    expect(didLongPressButton, isFalse);
    await tester.longPress(outlinedButton);
    expect(didLongPressButton, isTrue);
  });

  testWidgetsWithLeakTracking('OutlinedButton responds to density changes.', (WidgetTester tester) async {
    const Key key = Key('test');
    const Key childKey = Key('test child');

    Future<void> buildTest(VisualDensity visualDensity, {bool useText = false}) async {
      return tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: false),
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: OutlinedButton(
                style: ButtonStyle(
                  visualDensity: visualDensity,
                  minimumSize: ButtonStyleButton.allOrNull(const Size(64, 36)),
                ),
                key: key,
                onPressed: () {},
                child: useText
                  ? const Text('Text', key: childKey)
                  : Container(key: childKey, width: 100, height: 100, color: const Color(0xffff0000)),
              ),
            ),
          ),
        ),
      );
    }

    await buildTest(VisualDensity.standard);
    final RenderBox box = tester.renderObject(find.byKey(key));
    Rect childRect = tester.getRect(find.byKey(childKey));
    await tester.pumpAndSettle();
    expect(box.size, equals(const Size(132, 100)));
    expect(childRect, equals(const Rect.fromLTRB(350, 250, 450, 350)));

    await buildTest(const VisualDensity(horizontal: 3.0, vertical: 3.0));
    await tester.pumpAndSettle();
    childRect = tester.getRect(find.byKey(childKey));
    expect(box.size, equals(const Size(156, 124)));
    expect(childRect, equals(const Rect.fromLTRB(350, 250, 450, 350)));

    await buildTest(const VisualDensity(horizontal: -3.0, vertical: -3.0));
    await tester.pumpAndSettle();
    childRect = tester.getRect(find.byKey(childKey));
    expect(box.size, equals(const Size(132, 100)));
    expect(childRect, equals(const Rect.fromLTRB(350, 250, 450, 350)));

    await buildTest(VisualDensity.standard, useText: true);
    await tester.pumpAndSettle();
    childRect = tester.getRect(find.byKey(childKey));
    expect(box.size, equals(const Size(88, 48)));
    expect(childRect, equals(const Rect.fromLTRB(372.0, 293.0, 428.0, 307.0)));

    await buildTest(const VisualDensity(horizontal: 3.0, vertical: 3.0), useText: true);
    await tester.pumpAndSettle();
    childRect = tester.getRect(find.byKey(childKey));
    expect(box.size, equals(const Size(112, 60)));
    expect(childRect, equals(const Rect.fromLTRB(372.0, 293.0, 428.0, 307.0)));

    await buildTest(const VisualDensity(horizontal: -3.0, vertical: -3.0), useText: true);
    await tester.pumpAndSettle();
    childRect = tester.getRect(find.byKey(childKey));
    expect(box.size, equals(const Size(88, 36)));
    expect(childRect, equals(const Rect.fromLTRB(372.0, 293.0, 428.0, 307.0)));
  });

  group('Default OutlinedButton padding for textScaleFactor, textDirection', () {
    const ValueKey<String> buttonKey = ValueKey<String>('button');
    const ValueKey<String> labelKey = ValueKey<String>('label');
    const ValueKey<String> iconKey = ValueKey<String>('icon');

    const List<double> textScaleFactorOptions = <double>[0.5, 1.0, 1.25, 1.5, 2.0, 2.5, 3.0, 4.0];
    const List<TextDirection> textDirectionOptions = <TextDirection>[TextDirection.ltr, TextDirection.rtl];
    const List<Widget?> iconOptions = <Widget?>[null, Icon(Icons.add, size: 18, key: iconKey)];

    // Expected values for each textScaleFactor.
    final Map<double, double> paddingVertical = <double, double>{
      0.5: 0,
      1: 0,
      1.25: 0,
      1.5: 0,
      2: 0,
      2.5: 0,
      3: 0,
      4: 0,
    };
    final Map<double, double> paddingWithIconGap = <double, double>{
      0.5: 8,
      1: 8,
      1.25: 7,
      1.5: 6,
      2: 4,
      2.5: 4,
      3: 4,
      4: 4,
    };
    final Map<double, double> paddingHorizontal = <double, double>{
      0.5: 16,
      1: 16,
      1.25: 14,
      1.5: 12,
      2: 8,
      2.5: 6,
      3: 4,
      4: 4,
    };

    Rect globalBounds(RenderBox renderBox) {
      final Offset topLeft = renderBox.localToGlobal(Offset.zero);
      return topLeft & renderBox.size;
    }

    /// Computes the padding between two [Rect]s, one inside the other.
    EdgeInsets paddingBetween({ required Rect parent, required Rect child }) {
      assert (parent.intersect(child) == child);
      return EdgeInsets.fromLTRB(
        child.left - parent.left,
        child.top - parent.top,
        parent.right - child.right,
        parent.bottom - child.bottom,
      );
    }

    for (final double textScaleFactor in textScaleFactorOptions) {
      for (final TextDirection textDirection in textDirectionOptions) {
        for (final Widget? icon in iconOptions) {
          final String testName = <String>[
            'OutlinedButton, text scale $textScaleFactor',
            if (icon != null)
              'with icon',
            if (textDirection == TextDirection.rtl)
              'RTL',
          ].join(', ');
          testWidgetsWithLeakTracking(testName, (WidgetTester tester) async {
            await tester.pumpWidget(
              MaterialApp(
                theme: ThemeData(
                  useMaterial3: false,
                  outlinedButtonTheme: OutlinedButtonThemeData(
                    style: OutlinedButton.styleFrom(minimumSize: const Size(64, 36)),
                  ),
                ),
                home: Builder(
                  builder: (BuildContext context) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaleFactor: textScaleFactor,
                      ),
                      child: Directionality(
                        textDirection: textDirection,
                        child: Scaffold(
                          body: Center(
                            child: icon == null
                              ? OutlinedButton(
                                  key: buttonKey,
                                  onPressed: () {},
                                  child: const Text('button', key: labelKey),
                                )
                              : OutlinedButton.icon(
                                  key: buttonKey,
                                  onPressed: () {},
                                  icon: icon,
                                  label: const Text('button', key: labelKey),
                                ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );

            final Element paddingElement = tester.element(
              find.descendant(
                of: find.byKey(buttonKey),
                matching: find.byType(Padding),
              ),
            );
            expect(Directionality.of(paddingElement), textDirection);
            final Padding paddingWidget = paddingElement.widget as Padding;

            // Compute expected padding, and check.

            final double expectedPaddingTop = paddingVertical[textScaleFactor]!;
            final double expectedPaddingBottom = paddingVertical[textScaleFactor]!;
            final double expectedPaddingStart = paddingHorizontal[textScaleFactor]!;
            final double expectedPaddingEnd = expectedPaddingStart;

            final EdgeInsets expectedPadding = EdgeInsetsDirectional.fromSTEB(
              expectedPaddingStart,
              expectedPaddingTop,
              expectedPaddingEnd,
              expectedPaddingBottom,
            ).resolve(textDirection);

            expect(paddingWidget.padding.resolve(textDirection), expectedPadding);

            // Measure padding in terms of the difference between the button and its label child
            // and check that.

            final RenderBox labelRenderBox = tester.renderObject<RenderBox>(find.byKey(labelKey));
            final Rect labelBounds = globalBounds(labelRenderBox);
            final RenderBox? iconRenderBox = icon == null ? null : tester.renderObject<RenderBox>(find.byKey(iconKey));
            final Rect? iconBounds = icon == null ? null : globalBounds(iconRenderBox!);
            final Rect childBounds = icon == null ? labelBounds : labelBounds.expandToInclude(iconBounds!);

            // We measure the `InkResponse` descendant of the button
            // element, because the button has a larger `RenderBox`
            // which accommodates the minimum tap target with a height
            // of 48.
            final RenderBox buttonRenderBox = tester.renderObject<RenderBox>(
              find.descendant(
                of: find.byKey(buttonKey),
                matching: find.byWidgetPredicate(
                  (Widget widget) => widget is InkResponse,
                ),
              ),
            );
            final Rect buttonBounds = globalBounds(buttonRenderBox);
            final EdgeInsets visuallyMeasuredPadding = paddingBetween(
              parent: buttonBounds,
              child: childBounds,
            );

            // Since there is a requirement of a minimum width of 64
            // and a minimum height of 36 on material buttons, the visual
            // padding of smaller buttons may not match their settings.
            // Therefore, we only test buttons that are large enough.
            if (buttonBounds.width > 64) {
              expect(
                visuallyMeasuredPadding.left,
                expectedPadding.left,
              );
              expect(
                visuallyMeasuredPadding.right,
                expectedPadding.right,
              );
            }

            if (buttonBounds.height > 36) {
              expect(
                visuallyMeasuredPadding.top,
                expectedPadding.top,
              );
              expect(
                visuallyMeasuredPadding.bottom,
                expectedPadding.bottom,
              );
            }

            // Check the gap between the icon and the label
            if (icon != null) {
              final double gapWidth = textDirection == TextDirection.ltr
                ? labelBounds.left - iconBounds!.right
                : iconBounds!.left - labelBounds.right;
              expect(gapWidth, paddingWithIconGap[textScaleFactor]);
            }

            // Check the text's height - should be consistent with the textScaleFactor.
            final RenderBox textRenderObject = tester.renderObject<RenderBox>(
              find.descendant(
                of: find.byKey(labelKey),
                matching: find.byElementPredicate(
                  (Element element) => element.widget is RichText,
                ),
              ),
            );
            final double textHeight = textRenderObject.paintBounds.size.height;
            final double expectedTextHeight = 14 * textScaleFactor;
            expect(textHeight, moreOrLessEquals(expectedTextHeight, epsilon: 0.5));
          });
        }
      }
    }
  });

  testWidgetsWithLeakTracking('Override OutlinedButton default padding', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: false),
        home: Builder(
          builder: (BuildContext context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 2,
              ),
              child: Scaffold(
                body: Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(22)),
                    onPressed: () {},
                    child: const Text('OutlinedButton'),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    final Padding paddingWidget = tester.widget<Padding>(
      find.descendant(
        of: find.byType(OutlinedButton),
        matching: find.byType(Padding),
      ),
    );
    expect(paddingWidget.padding, const EdgeInsets.all(22));
  });

  testWidgetsWithLeakTracking('M3 OutlinedButton has correct padding', (WidgetTester tester) async {
    final Key key = UniqueKey();
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.from(colorScheme: const ColorScheme.light(), useMaterial3: true),
        home: Scaffold(
                body: Center(
                  child: OutlinedButton(
                    key: key,
                    onPressed: () {},
                    child: const Text('OutlinedButton'),
                  ),
                ),
              ),
            ),
          );

    final Padding paddingWidget = tester.widget<Padding>(
      find.descendant(
        of: find.byKey(key),
        matching: find.byType(Padding),
      ),
    );
    expect(paddingWidget.padding, const EdgeInsets.symmetric(horizontal: 24));
  });

  testWidgetsWithLeakTracking('M3 OutlinedButton.icon has correct padding', (WidgetTester tester) async {
    final Key key = UniqueKey();
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.from(colorScheme: const ColorScheme.light(), useMaterial3: true),
        home: Scaffold(
                body: Center(
                  child: OutlinedButton.icon(
                    key: key,
                    icon: const Icon(Icons.favorite),
                    onPressed: () {},
                    label: const Text('OutlinedButton'),
                  ),
                ),
              ),
            ),
          );

    final Padding paddingWidget = tester.widget<Padding>(
      find.descendant(
        of: find.byKey(key),
        matching: find.byType(Padding),
      ),
    );
   expect(paddingWidget.padding, const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 24.0, 0.0));
  });

  testWidgetsWithLeakTracking('Fixed size OutlinedButtons', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              OutlinedButton(
                style: OutlinedButton.styleFrom(fixedSize: const Size(100, 100)),
                onPressed: () {},
                child: const Text('100x100'),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(fixedSize: const Size.fromWidth(200)),
                onPressed: () {},
                child: const Text('200xh'),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(fixedSize: const Size.fromHeight(200)),
                onPressed: () {},
                child: const Text('wx200'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.getSize(find.widgetWithText(OutlinedButton, '100x100')), const Size(100, 100));
    expect(tester.getSize(find.widgetWithText(OutlinedButton, '200xh')).width, 200);
    expect(tester.getSize(find.widgetWithText(OutlinedButton, 'wx200')).height, 200);
  });

  testWidgetsWithLeakTracking('OutlinedButton with NoSplash splashFactory paints nothing', (WidgetTester tester) async {
    Widget buildFrame({ InteractiveInkFeatureFactory? splashFactory }) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                splashFactory: splashFactory,
              ),
              onPressed: () { },
              child: const Text('test'),
            ),
          ),
        ),
      );
    }

    // NoSplash.splashFactory, no splash circles drawn
    await tester.pumpWidget(buildFrame(splashFactory: NoSplash.splashFactory));
    {
      final TestGesture gesture = await tester.startGesture(tester.getCenter(find.text('test')));
      final MaterialInkController material = Material.of(tester.element(find.text('test')));
      await tester.pump(const Duration(milliseconds: 200));
      expect(material, paintsExactlyCountTimes(#drawCircle, 0));
      await gesture.up();
      await tester.pumpAndSettle();
    }

    // InkRipple.splashFactory, one splash circle drawn.
    await tester.pumpWidget(buildFrame(splashFactory: InkRipple.splashFactory));
    {
      final TestGesture gesture = await tester.startGesture(tester.getCenter(find.text('test')));
      final MaterialInkController material = Material.of(tester.element(find.text('test')));
      await tester.pump(const Duration(milliseconds: 200));
      expect(material, paintsExactlyCountTimes(#drawCircle, 1));
      await gesture.up();
      await tester.pumpAndSettle();
    }
  });

  testWidgetsWithLeakTracking('OutlinedButton uses InkSparkle only for Android non-web when useMaterial3 is true', (WidgetTester tester) async {
    final ThemeData theme = ThemeData(useMaterial3: true);

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Center(
          child: OutlinedButton(
            onPressed: () { },
            child: const Text('button'),
          ),
        ),
      ),
    );

    final InkWell buttonInkWell = tester.widget<InkWell>(find.descendant(
      of: find.byType(OutlinedButton),
      matching: find.byType(InkWell),
    ));

    if (debugDefaultTargetPlatformOverride! == TargetPlatform.android && !kIsWeb) {
      expect(buttonInkWell.splashFactory, equals(InkSparkle.splashFactory));
    } else {
      expect(buttonInkWell.splashFactory, equals(InkRipple.splashFactory));
    }
  }, variant: TargetPlatformVariant.all());

  testWidgetsWithLeakTracking('OutlinedButton uses InkRipple when useMaterial3 is false', (WidgetTester tester) async {
    final ThemeData theme = ThemeData(useMaterial3: false);

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Center(
          child: OutlinedButton(
            onPressed: () { },
            child: const Text('button'),
          ),
        ),
      ),
    );

    final InkWell buttonInkWell = tester.widget<InkWell>(find.descendant(
      of: find.byType(OutlinedButton),
      matching: find.byType(InkWell),
    ));
    expect(buttonInkWell.splashFactory, equals(InkRipple.splashFactory));
  }, variant: TargetPlatformVariant.all());

  testWidgetsWithLeakTracking('OutlinedButton.icon does not overflow', (WidgetTester tester) async {
    // Regression test for https://github.com/flutter/flutter/issues/77815
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text( // Much wider than 200
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut a euismod nibh. Morbi laoreet purus.',
              ),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), null);
  });

  testWidgetsWithLeakTracking('OutlinedButton.icon icon,label layout', (WidgetTester tester) async {
    final Key buttonKey = UniqueKey();
    final Key iconKey = UniqueKey();
    final Key labelKey = UniqueKey();
    final ButtonStyle style = OutlinedButton.styleFrom(
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.standard, // dx=0, dy=0
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            child: OutlinedButton.icon(
              key: buttonKey,
              style: style,
              onPressed: () {},
              icon: SizedBox(key: iconKey, width: 50, height: 100),
              label: SizedBox(key: labelKey, width: 50, height: 100),
            ),
          ),
        ),
      ),
    );

    // The button's label and icon are separated by a gap of 8:
    // 46 [icon 50] 8 [label 50] 46
    // The overall button width is 200. So:
    // icon.x = 46
    // label.x = 46 + 50 + 8 = 104

    expect(tester.getRect(find.byKey(buttonKey)), const Rect.fromLTRB(0.0, 0.0, 200.0, 100.0));
    expect(tester.getRect(find.byKey(iconKey)), const Rect.fromLTRB(46.0, 0.0, 96.0, 100.0));
    expect(tester.getRect(find.byKey(labelKey)), const Rect.fromLTRB(104.0, 0.0, 154.0, 100.0));
  });

  testWidgetsWithLeakTracking('OutlinedButton maximumSize', (WidgetTester tester) async {
    final Key key0 = UniqueKey();
    final Key key1 = UniqueKey();

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: false),
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                OutlinedButton(
                  key: key0,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(24, 36),
                    maximumSize: const Size.fromWidth(64),
                  ),
                  onPressed: () { },
                  child: const Text('A B C D E F G H I J K L M N O P'),
                ),
                OutlinedButton.icon(
                  key: key1,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(24, 36),
                    maximumSize: const Size.fromWidth(104),
                  ),
                  onPressed: () {},
                  icon: Container(color: Colors.red, width: 32, height: 32),
                  label: const Text('A B C D E F G H I J K L M N O P'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(key0)), const Size(64.0, 224.0));
    expect(tester.getSize(find.byKey(key1)), const Size(104.0, 224.0));
  });

  testWidgetsWithLeakTracking('Fixed size OutlinedButton, same as minimumSize == maximumSize', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              OutlinedButton(
                style: OutlinedButton.styleFrom(fixedSize: const Size(200, 200)),
                onPressed: () { },
                child: const Text('200x200'),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(200, 200),
                  maximumSize: const Size(200, 200),
                ),
                onPressed: () { },
                child: const Text('200,200'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.getSize(find.widgetWithText(OutlinedButton, '200x200')), const Size(200, 200));
    expect(tester.getSize(find.widgetWithText(OutlinedButton, '200,200')), const Size(200, 200));
  });

  testWidgetsWithLeakTracking('OutlinedButton changes mouse cursor when hovered', (WidgetTester tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MouseRegion(
          cursor: SystemMouseCursors.forbidden,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              enabledMouseCursor: SystemMouseCursors.text,
              disabledMouseCursor: SystemMouseCursors.grab,
            ),
            onPressed: () {},
            child: const Text('button'),
          ),
        ),
      ),
    );

    final TestGesture gesture = await tester.createGesture(kind: PointerDeviceKind.mouse, pointer: 1);
    await gesture.addPointer(location: Offset.zero);

    await tester.pump();

    expect(RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1), SystemMouseCursors.text);

    // Test cursor when disabled
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MouseRegion(
          cursor: SystemMouseCursors.forbidden,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              enabledMouseCursor: SystemMouseCursors.text,
              disabledMouseCursor: SystemMouseCursors.grab,
            ),
            onPressed: null,
            child: const Text('button'),
          ),
        ),
      ),
    );

    expect(RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1), SystemMouseCursors.grab);

    // Test default cursor
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MouseRegion(
          cursor: SystemMouseCursors.forbidden,
          child: OutlinedButton(
            onPressed: () {},
            child: const Text('button'),
          ),
        ),
      ),
    );

    expect(RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1), SystemMouseCursors.click);

    // Test default cursor when disabled
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: MouseRegion(
          cursor: SystemMouseCursors.forbidden,
          child: OutlinedButton(
            onPressed: null,
            child: Text('button'),
          ),
        ),
      ),
    );

    expect(RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1), SystemMouseCursors.basic);
  });

  testWidgets('OutlinedButton in SelectionArea changes mouse cursor when hovered', (WidgetTester tester) async {
    // Regression test for https://github.com/flutter/flutter/issues/104595.
    await tester.pumpWidget(MaterialApp(
      home: SelectionArea(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.click,
            disabledMouseCursor: SystemMouseCursors.grab,
          ),
          onPressed: () {},
          child: const Text('button'),
        ),
      ),
    ));

    final TestGesture gesture = await tester.createGesture(kind: PointerDeviceKind.mouse, pointer: 1);
    await gesture.addPointer(location: tester.getCenter(find.byType(Text)));

    await tester.pump();

    expect(RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1), SystemMouseCursors.click);
  });

  testWidgetsWithLeakTracking('OutlinedButton.styleFrom can be used to set foreground and background colors', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.purple,
            ),
            onPressed: () {},
            child: const Text('button'),
          ),
        ),
      ),
    );

    final Material material = tester.widget<Material>(find.descendant(
      of: find.byType(OutlinedButton),
      matching: find.byType(Material),
    ));
    expect(material.color, Colors.purple);
    expect(material.textStyle!.color, Colors.white);
  });

  Future<void> testStatesController(Widget? icon, WidgetTester tester) async {
    int count = 0;
    void valueChanged() {
      count += 1;
    }
    final MaterialStatesController controller = MaterialStatesController();
    addTearDown(controller.dispose);
    controller.addListener(valueChanged);

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: icon == null
            ? OutlinedButton(
                statesController: controller,
                onPressed: () { },
                child: const Text('button'),
              )
            : OutlinedButton.icon(
                statesController: controller,
                onPressed: () { },
                icon: icon,
                label: const Text('button'),
              ),
        ),
      ),
    );

    expect(controller.value, <MaterialState>{});
    expect(count, 0);

    final Offset center = tester.getCenter(find.byType(Text));
    final TestGesture gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await gesture.addPointer();
    await gesture.moveTo(center);
    await tester.pumpAndSettle();

    expect(controller.value, <MaterialState>{MaterialState.hovered});
    expect(count, 1);

    await gesture.moveTo(Offset.zero);
    await tester.pumpAndSettle();

    expect(controller.value, <MaterialState>{});
    expect(count, 2);

    await gesture.moveTo(center);
    await tester.pumpAndSettle();

    expect(controller.value, <MaterialState>{MaterialState.hovered});
    expect(count, 3);

    await gesture.down(center);
    await tester.pumpAndSettle();

    expect(controller.value, <MaterialState>{MaterialState.hovered, MaterialState.pressed});
    expect(count, 4);

    await gesture.up();
    await tester.pumpAndSettle();

    expect(controller.value, <MaterialState>{MaterialState.hovered});
    expect(count, 5);

    await gesture.moveTo(Offset.zero);
    await tester.pumpAndSettle();

    expect(controller.value, <MaterialState>{});
    expect(count, 6);

    await gesture.down(center);
    await tester.pumpAndSettle();
    expect(controller.value, <MaterialState>{MaterialState.hovered, MaterialState.pressed});
    expect(count, 8); // adds hovered and pressed - two changes

    // If the button is rebuilt disabled, then the pressed state is
    // removed.
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
        child: icon == null
          ? OutlinedButton(
              statesController: controller,
              onPressed: null,
              child: const Text('button'),
            )
          : OutlinedButton.icon(
              statesController: controller,
              onPressed: null,
              icon: icon,
              label: const Text('button'),
            ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(controller.value, <MaterialState>{MaterialState.hovered, MaterialState.disabled});
    expect(count, 10); // removes pressed and adds disabled - two changes
    await gesture.moveTo(Offset.zero);
    await tester.pumpAndSettle();
    expect(controller.value, <MaterialState>{MaterialState.disabled});
    expect(count, 11);
    await gesture.removePointer();
  }

  testWidgetsWithLeakTracking('OutlinedButton statesController', (WidgetTester tester) async {
    testStatesController(null, tester);
  });

  testWidgetsWithLeakTracking('OutlinedButton.icon statesController', (WidgetTester tester) async {
    testStatesController(const Icon(Icons.add), tester);
  });

  testWidgetsWithLeakTracking('Disabled OutlinedButton statesController', (WidgetTester tester) async {
    int count = 0;
    void valueChanged() {
      count += 1;
    }
    final MaterialStatesController controller = MaterialStatesController();
    addTearDown(controller.dispose);
    controller.addListener(valueChanged);

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: OutlinedButton(
            statesController: controller,
            onPressed: null,
            child: const Text('button'),
          ),
        ),
      ),
    );
    expect(controller.value, <MaterialState>{MaterialState.disabled});
    expect(count, 1);
  });

  testWidgetsWithLeakTracking("OutlinedButton.styleFrom doesn't throw exception on passing only one cursor", (WidgetTester tester) async {
    // This is a regression test for https://github.com/flutter/flutter/issues/118071.
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.text,
          ),
          onPressed: () {},
          child: const Text('button'),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}

TextStyle _iconStyle(WidgetTester tester, IconData icon) {
  final RichText iconRichText = tester.widget<RichText>(
    find.descendant(of: find.byIcon(icon), matching: find.byType(RichText)),
  );
  return iconRichText.text.style!;
}
