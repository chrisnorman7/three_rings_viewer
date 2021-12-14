import 'package:flutter/material.dart';

import '../json/directory_volunteer.dart';
import '../util.dart';
import 'volunteer_view.dart';

/// A widget to show a list of volunteers.
class VolunteersView extends StatefulWidget {
  /// Create an instance.
  const VolunteersView(
      {required this.volunteers, required this.apiKey, Key? key})
      : super(key: key);

  /// The volunteers to show.
  final List<DirectoryVolunteer> volunteers;

  /// The API key to use while getting volunteer images.
  final String apiKey;

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
            subtitle: Image.network(
              volunteer.imageUrl,
              headers: getHeaders(apiKey: widget.apiKey),
            ),
            onTap: () =>
                Navigator.of(context).push(MaterialPageRoute<VolunteerView>(
              builder: (context) => VolunteerView(volunteer: volunteer),
            )),
          );
        },
        itemCount: widget.volunteers.length,
      );
}
