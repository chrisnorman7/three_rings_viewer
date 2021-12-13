/// Provides the [ShiftVolunteersView] class.
import 'package:flutter/material.dart';

import '../json/shift_volunteer.dart';

/// A widget that shows the volunteers on shift.
class ShiftVolunteersView extends StatefulWidget {
  /// Create an instance.
  const ShiftVolunteersView(
      {required this.title, required this.volunteers, Key? key})
      : super(key: key);

  /// The title of the shift.
  final String title;

  /// The volunteers that are on this shift.
  final List<ShiftVolunteer> volunteers;

  /// Create state for this widget.
  @override
  _ShiftVolunteersViewState createState() => _ShiftVolunteersViewState();
}

/// State for [ShiftVolunteersView].
class _ShiftVolunteersViewState extends State<ShiftVolunteersView> {
  /// Build a widget.
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            final volunteer = widget.volunteers[index];
            return ListTile(
              title: Text(volunteer.name),
              subtitle: Image.network(volunteer.imageUrl),
            );
          },
        ),
      );
}
