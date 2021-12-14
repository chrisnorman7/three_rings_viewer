/// Provides the [VolunteerRolesView] class.
import 'package:flutter/material.dart';

import '../json/directory_volunteer.dart';
import 'cancellable_widget.dart';

/// A widget to show a list of volunteer roles.
class VolunteerRolesView extends StatefulWidget {
  /// Create an instance.
  const VolunteerRolesView({required this.volunteer, Key? key})
      : super(key: key);

  /// The volunteer whose rolls should be shown.
  final DirectoryVolunteer volunteer;

  /// Create state for this widget.
  @override
  _VolunteerRolesViewState createState() => _VolunteerRolesViewState();
}

/// State for [VolunteerRolesView].
class _VolunteerRolesViewState extends State<VolunteerRolesView> {
  /// Build a widget.
  @override
  Widget build(BuildContext context) => CancellableWidget(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Roles for ${widget.volunteer.name}'),
          ),
          body: ListView.builder(
            itemBuilder: (context, index) => Focus(
              child: ListTile(
                title: Text(widget.volunteer.roles[index].name),
              ),
            ),
            itemCount: widget.volunteer.roles.length,
          ),
        ),
      );
}
