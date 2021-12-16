/// Provides the [ShiftsView] class.
import 'package:flutter/material.dart';

import '../json/preferences.dart';
import '../json/shift.dart';
import '../util.dart';
import 'shift_volunteers_view.dart';

/// A widget that shows a list of [Shift] instances.
class ShiftsView extends StatefulWidget {
  /// Create an instance.
  const ShiftsView({required this.shifts, required this.preferences, Key? key})
      : super(key: key);

  /// The shifts to show.
  final List<Shift> shifts;

  /// The preferences to pass to [ShiftVolunteersView].
  final Preferences preferences;

  /// Create state for this widget.
  @override
  _ShiftsViewState createState() => _ShiftsViewState();
}

/// State for [ShiftsView].
class _ShiftsViewState extends State<ShiftsView> {
  /// Build a widget.
  @override
  Widget build(BuildContext context) => ListView.builder(
      itemBuilder: (context, index) {
        final shift = widget.shifts[index];
        return ListTile(
          title: Text(shift.rota.name),
          subtitle: Text(shift.allDay
              ? 'All day'
              : '${timestamp(shift.start)} - '
                  '${timestamp(shift.end)}'),
          onTap: () =>
              Navigator.of(context).push<ShiftVolunteersView>(MaterialPageRoute(
            builder: (context) => ShiftVolunteersView(
              shift: shift,
              preferences: widget.preferences,
            ),
          )),
        );
      },
      itemCount: widget.shifts.length);
}
