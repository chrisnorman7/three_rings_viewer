/// Provides the [ShiftsView] class.
import 'package:flutter/material.dart';

import '../json/preferences.dart';
import '../json/shift.dart';
import '../json/shift_list.dart';
import '../util.dart';
import 'shift_volunteers_view.dart';

/// A widget that shows a list of [Shift] instances.
class ShiftsView extends StatefulWidget {
  /// Create an instance.
  const ShiftsView(
      {required this.shiftList, required this.preferences, Key? key})
      : super(key: key);

  /// The shifts to show.
  final ShiftList shiftList;

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
  Widget build(BuildContext context) {
    final shifts = getShifts();
    return ListView.builder(
        itemBuilder: (context, index) {
          final shift = shifts[index];
          return ListTile(
            title: Text(shift.rota.name),
            subtitle: Text(shift.allDay
                ? 'All day'
                : '${timestamp(shift.start)} - '
                    '${timestamp(shift.end)}'),
            onTap: () async {
              await Navigator.of(context)
                  .push<ShiftVolunteersView>(MaterialPageRoute(
                builder: (context) => ShiftVolunteersView(
                  shift: shift,
                  preferences: widget.preferences,
                ),
              ));
              setState(() {});
            },
          );
        },
        itemCount: shifts.length);
  }

  /// Get a list of relevant shifts.
  List<Shift> getShifts() {
    final possibleShifts = widget.shiftList.shifts
        .where((element) =>
            element.allDay == false &&
            widget.preferences.rotaUnhidden(element.rota) == true)
        .toList()
      ..sort((a, b) {
        final result = a.start.compareTo(b.start);
        if (result == 0) {
          if (a.rota.name.startsWith('Leader')) {
            return -1;
          }
          return b.rota.name.compareTo(a.rota.name);
        }
        return result;
      });
    final now = DateTime.now();
    final shifts = widget.shiftList.shifts
        .where((element) =>
            element.allDay == true &&
            element.start.year == now.year &&
            element.start.month == now.month &&
            element.start.day == now.day &&
            widget.preferences.rotaUnhidden(element.rota))
        .toList();
    DateTime? previousStartTime;
    DateTime? nextStartTime;
    for (final shift in possibleShifts) {
      if ((previousStartTime == null ||
              shift.start.isAfter(previousStartTime)) &&
          shift.end.isBefore(now)) {
        previousStartTime = shift.start;
      } else if ((nextStartTime == null ||
              shift.start.isBefore(nextStartTime)) &&
          shift.start.isAfter(now)) {
        nextStartTime = shift.start;
      }
    }
    if (previousStartTime != null) {
      shifts.addAll(possibleShifts.where((element) =>
          element.start.isAtSameMomentAs(previousStartTime!) &&
          element.end.isBefore(now)));
    }
    shifts.addAll(possibleShifts.where(
        (element) => element.start.isBefore(now) && element.end.isAfter(now)));
    if (nextStartTime != null) {
      shifts.addAll(possibleShifts
          .where((element) => element.start.isAtSameMomentAs(nextStartTime!)));
    }
    return shifts;
  }
}
