/// Provides the [CancellableWidget] class.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../intents.dart';

/// A widget that can be cancelled.
class CancellableWidget extends StatelessWidget {
  /// Create an instance.
  const CancellableWidget({required this.child, final Key? key})
      : super(key: key);

  /// The child for this widget.
  final Widget child;
  @override
  Widget build(final BuildContext context) => Shortcuts(
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.escape): CancelIntent()
        },
        child: Actions(
          actions: {
            CancelIntent: CallbackAction(
              onInvoke: (final intent) => Navigator.pop(context),
            )
          },
          child: child,
        ),
      );
}
