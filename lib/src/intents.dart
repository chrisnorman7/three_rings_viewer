/// Provides various intents used by the program.
import 'package:flutter/material.dart';

/// Cancel something.
class CancelIntent extends Intent {
  /// Create an instance.
  const CancelIntent();
}

/// Navigate to the shifts tab.
class ShiftsTabIntent extends Intent {
  /// Create an instance.
  const ShiftsTabIntent();
}

/// Navigate to the volunteers tab.
class VolunteersTabIntent extends Intent {
  /// Create an instance.
  const VolunteersTabIntent();
}

/// Navigate to the news tab.
class NewsTabIntent extends Intent {
  /// Create an instance.
  const NewsTabIntent();
}

/// Navigate to the events tab.
class EventsTabIntent extends Intent {
  /// Create an instance.
  const EventsTabIntent();
}

/// Hide or unhide a shift.
class HideUnhideShiftIntent extends Intent {
  /// Create an instance.
  const HideUnhideShiftIntent();
}
