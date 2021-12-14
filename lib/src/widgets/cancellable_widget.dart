/// Provides the [CancellableWidget] class.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../intents.dart';

/// A widget that can be cancelled.
class CancellableWidget extends StatelessWidget {
  /// Create an instance.
  const CancellableWidget({required this.child, Key? key}) : super(key: key);

  /// The child for this widget.
  final Widget child;
  @override
  Widget build(BuildContext context) => Shortcuts(
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.escape): CancelIntent()
          },
          child: Actions(actions: {
            CancelIntent: CallbackAction(
              onInvoke: (intent) => Navigator.pop(context),
            )
          }, child: child));
}
