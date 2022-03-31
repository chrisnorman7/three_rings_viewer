/// Provides the [OrientedScaffold] and [OrientedScaffoldTab] classes.
import 'package:flutter/material.dart';

/// A tab in either a [BottomNavigationBar], or a [NavigationRail].
class OrientedScaffoldTab {
  /// Create an instance.
  const OrientedScaffoldTab({required this.icon, required this.label});

  /// The icon to use.
  final Widget icon;

  /// The label to use.
  final String label;
}

/// A scaffold which shows a [BottomNavigationBar] in portrait orientation, and
/// a [NavigationRail] in landscape.
class OrientedScaffold extends StatefulWidget {
  /// Create an instance.
  const OrientedScaffold({
    required this.appBar,
    required this.child,
    required this.tabs,
    required this.selectedIndex,
    required this.onNavigate,
    final Key? key,
  }) : super(key: key);

  /// The app bar to use.
  final AppBar appBar;

  /// The child widget to show.
  final Widget child;

  /// The list of tabs to use as navigation.
  final List<OrientedScaffoldTab> tabs;

  /// The currently-selected index.
  final int selectedIndex;

  /// The function to be called when a new tab is navigated to.
  final void Function(int index) onNavigate;

  /// Create state for this widget.
  @override
  OrientedScaffoldState createState() => OrientedScaffoldState();
}

/// State for [OrientedScaffold].
class OrientedScaffoldState extends State<OrientedScaffold> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) => OrientationBuilder(
        builder: (final context, final orientation) => Scaffold(
          appBar: widget.appBar,
          body: orientation == Orientation.portrait
              ? widget.child
              : Row(
                  children: [
                    Expanded(child: widget.child),
                    const VerticalDivider(
                      width: 1,
                      thickness: 1,
                    ),
                    NavigationRail(
                      destinations: widget.tabs
                          .map(
                            (final e) => NavigationRailDestination(
                              icon: e.icon,
                              label: Text(e.label),
                            ),
                          )
                          .toList(),
                      selectedIndex: widget.selectedIndex,
                      onDestinationSelected: widget.onNavigate,
                    )
                  ],
                ),
          bottomNavigationBar: orientation == Orientation.portrait
              ? BottomNavigationBar(
                  items: widget.tabs
                      .map(
                        (final e) => BottomNavigationBarItem(
                          icon: e.icon,
                          label: e.label,
                        ),
                      )
                      .toList(),
                  currentIndex: widget.selectedIndex,
                  onTap: widget.onNavigate,
                )
              : null,
        ),
      );
}
