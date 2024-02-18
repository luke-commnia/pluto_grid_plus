import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

void main() {
  late FocusNode focusNode;

  late PlutoKeyManagerEvent? keyManagerEvent;

  KeyEventResult callback(FocusNode node, KeyEvent event) {
    keyManagerEvent = PlutoKeyManagerEvent(
      focusNode: node,
      event: event,
    );

    return KeyEventResult.handled;
  }

  setUp(() {
    focusNode = FocusNode();
  });

  tearDown(() {
    keyManagerEvent = null;
  });

  Future<void> buildWidget({
    required WidgetTester tester,
    required KeyEventResult Function(FocusNode, KeyEvent) callback,
  }) async {
    await tester.pumpWidget(MaterialApp(
      home: FocusScope(
        autofocus: true,
        onKeyEvent: callback,
        child: Focus(
          focusNode: focusNode,
          child: const SizedBox(width: 100, height: 100),
        ),
      ),
    ));

    focusNode.requestFocus();
  }

  testWidgets(
    '아무 키나 입력하면 isKeyDownEvent 가 true 여야 한다.',
    (tester) async {
      await buildWidget(tester: tester, callback: callback);

      const key = LogicalKeyboardKey.keyE;
      await tester.sendKeyDownEvent(key);
      expect(keyManagerEvent!.isKeyDownEvent, true);
      await tester.sendKeyUpEvent(key);
      expect(keyManagerEvent!.isKeyDownEvent, false);
    },
  );

  testWidgets(
    'Home 키를 입력하면 isHome 이 true 여야 한다.',
    (tester) async {
      late PlutoKeyManagerEvent keyManagerEvent;

      KeyEventResult callback(FocusNode node, KeyEvent event) {
        keyManagerEvent = PlutoKeyManagerEvent(
          focusNode: node,
          event: event,
        );

        return KeyEventResult.handled;
      }

      await buildWidget(tester: tester, callback: callback);

      const key = LogicalKeyboardKey.home;
      await tester.sendKeyDownEvent(key);
      expect(keyManagerEvent.isHome, true);
      await tester.sendKeyUpEvent(key);
    },
  );

  testWidgets(
    'End 키를 입력하면 isEnd 가 true 여야 한다.',
    (tester) async {
      await buildWidget(tester: tester, callback: callback);

      const key = LogicalKeyboardKey.end;
      await tester.sendKeyDownEvent(key);
      expect(keyManagerEvent!.isEnd, true);
      await tester.sendKeyUpEvent(key);
    },
  );

  testWidgets(
    'F4 키를 입력하면 isF4 가 true 여야 한다.',
    (tester) async {
      await buildWidget(tester: tester, callback: callback);

      const key = LogicalKeyboardKey.f4;
      await tester.sendKeyDownEvent(key);
      expect(keyManagerEvent!.isF4, true);
      await tester.sendKeyUpEvent(key);
    },
  );

  testWidgets(
    'Backspace 키를 입력하면 isBackspace 가 true 여야 한다.',
    (tester) async {
      await buildWidget(tester: tester, callback: callback);

      const key = LogicalKeyboardKey.backspace;
      await tester.sendKeyDownEvent(key);
      expect(keyManagerEvent!.isBackspace, true);
      await tester.sendKeyUpEvent(key);
    },
  );

  testWidgets(
    'Shift 키를 입력하면 isShift 가 true 여야 한다.',
    (tester) async {
      await buildWidget(tester: tester, callback: callback);

      const key = LogicalKeyboardKey.shift;
      await tester.sendKeyDownEvent(key);
      expect(keyManagerEvent!.isShift, true);
      await tester.sendKeyUpEvent(key);
    },
  );

  testWidgets(
    'Control 키를 입력하면 isControl 가 true 여야 한다.',
    (tester) async {
      await buildWidget(tester: tester, callback: callback);

      const key = LogicalKeyboardKey.control;
      await tester.sendKeyDownEvent(key);
      expect(keyManagerEvent!.isControl, true);
      await tester.sendKeyUpEvent(key);
    },
  );

  // While key combos still work in the real world, these 3 tests are failing due to what I suspect is an
  // incomplete deprecation/migration from focusNode `onKey` to `onKeyEvent`.
  // Flutter 3.19 does not trigger our event for `sendKeyUpEvent` only, and I prefer not
  // to switch these tests to `sendKeyDownEvent` as that may cause unexpected behavior
  // such as pasting multiple times due to repeating key presses. It might also be fine.

  // https://github.com/flutter/flutter/issues/136419
  testWidgets(
    'Control + C 키를 입력하면 isCtrlC 가 true 여야 한다.',
    (tester) async {
      await buildWidget(tester: tester, callback: callback);

      const key = LogicalKeyboardKey.control;
      const key2 = LogicalKeyboardKey.keyC;
      await tester.sendKeyDownEvent(key);
      await tester.sendKeyUpEvent(
          key2); // sendKeyUpEvent is not sending a keyManagerEvent

      expect(keyManagerEvent?.isCtrlC, true);
      await tester.sendKeyUpEvent(key);
    },
  );

  testWidgets(
    'Control + V 키를 입력하면 isCtrlV 가 true 여야 한다.',
    (tester) async {
      await buildWidget(tester: tester, callback: callback);

      const key = LogicalKeyboardKey.control;
      await tester.sendKeyDownEvent(key);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyV);
      expect(keyManagerEvent!.isCtrlV, true);
      await tester.sendKeyUpEvent(key);
    },
  );

  testWidgets(
    'Control + A 키를 입력하면 isCtrlA 가 true 여야 한다.',
    (tester) async {
      await buildWidget(tester: tester, callback: callback);

      const key = LogicalKeyboardKey.control;
      await tester.sendKeyDownEvent(key);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyA);
      expect(keyManagerEvent!.isCtrlA, true);
      await tester.sendKeyUpEvent(key);
    },
  );
}
