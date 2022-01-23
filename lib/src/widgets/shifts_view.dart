/// Provides the [ShiftsView] class.
import 'package:flutter/material.dart';

import '../enumerations.dart';
import '../json/preferences.dart';
import '../json/shift.dart';
import '../json/shift_list.dart';
import '../util.dart';
import 'shift_volunteers_view.dart';

/// A widget that shows a list of [Shift] instances.
class ShiftsView extends StatefulWidget {
  /// Create an instance.
  const ShiftsView(
      {required this.shiftList,
      required this.preferences,
      required this.shiftView,
      Key? key})
      : super(key: key);

  /// The shifts to show.
  final ShiftList shiftList;

  /// The preferences to pass to [ShiftVolunteersView].
  final Preferences preferences;

  /// Which view to use.
  final ShiftViews shiftView;

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
            autofocus: index == 0,
            title: Text(shift.rota.name),
            subtitle: Text(
              shift.allDay
                  ? 'All day'
                  : '${timestamp(shift.start)} - '
                      '${timestamp(shift.end)}',
            ),
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute<void>(
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

  /// Compare the names of shift [a], and shift [b].
  int compareShiftNames(Shift a, Shift b) {
    if (a.start.isAtSameMomentAs(b.start) && a.end.isAtSameMomentAs(b.end)) {
      if (b.rota.name.toLowerCase().startsWith('leader')) {
        return 1;
      } else if (a.rota.name.toLowerCase().startsWith('leader')) {
        return -1;
      }
      return b.rota.name.toLowerCase().compareTo(a.rota.name.toLowerCase());
    }
    return a.start.compareTo(b.start);
  }

  /// Returns `true` if [dateTime] happens on the same day as [origin].
  bool isOnSameDayAs({required DateTime dateTime, required DateTime origin}) =>
      dateTime.year == origin.year &&
      dateTime.month == origin.month &&
      dateTime.day == origin.day;

  /// Get a list of relevant shifts.
  List<Shift> getShifts() {
    final now = DateTime.now();
    if (widget.shiftView == ShiftViews.relevant) {
      final possibleShifts = widget.shiftList.shifts
          .where((element) =>
              element.allDay == false &&
              widget.preferences.rotaUnhidden(element.rota) == true)
          .toList()
        ..sort(compareShiftNames);
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
      shifts.addAll(possibleShifts.where((element) =>
          element.start.isBefore(now) && element.end.isAfter(now)));
      if (nextStartTime != null) {
        shifts.addAll(possibleShifts.where(
            (element) => element.start.isAtSameMomentAs(nextStartTime!)));
      }
      return shifts;
    }
    return [
      ...widget.shiftList.shifts.where((element) =>
          element.allDay == true &&
          widget.preferences.rotaUnhidden(element.rota) &&
          isOnSameDayAs(dateTime: element.start, origin: now)),
      ...widget.shiftList.shifts.where((element) =>
          element.allDay == false &&
          widget.preferences.rotaUnhidden(element.rota) &&
          isOnSameDayAs(dateTime: element.start, origin: now))
    ]..sort(compareShiftNames);
  }
}
