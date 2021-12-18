/// Provides the [NavigationTab] class.
import 'package:flutter/material.dart';

/// A tab in either a [BottomNavigationBar], or a [NavigationRail].
class NavigationTab {
  /// Create an instance.
  const NavigationTab({required this.icon, required this.label});

  /// The icon to use.
  final Widget icon;

  /// The label to use.
  final String label;
}
