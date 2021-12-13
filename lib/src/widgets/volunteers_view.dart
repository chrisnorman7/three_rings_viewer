import 'package:flutter/material.dart';

import '../json/directory_volunteer.dart';

/// A widget to show a list of volunteers.
class VolunteersView extends StatefulWidget {
  /// Create an instance.
  const VolunteersView({required this.volunteers, Key? key}) : super(key: key);

  /// The volunteers to show.
  final List<DirectoryVolunteer> volunteers;

  /// Create state for this widget.
  @override
  _VolunteersViewState createState() => _VolunteersViewState();
}

/// State for [VolunteersView].
class _VolunteersViewState extends State<VolunteersView> {
  /// Build a widget.
  @override
  Widget build(BuildContext context) => ListView.builder(
        itemBuilder: (context, index) {
          final volunteer = widget.volunteers[index];
          return ListTile(
            title: Text(volunteer.name),
            subtitle: Image.network(volunteer.imageUrl),
          );
        },
        itemCount: widget.volunteers.length,
      );
}
