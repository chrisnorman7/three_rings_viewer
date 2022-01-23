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
  Widget build(BuildContext context) => OrientationBuilder(
        builder: (context, orientation) => GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: orientation == Orientation.portrait ? 4 : 5),
          itemBuilder: (context, index) {
            final volunteer = widget.volunteers[index];
            return IconButton(
              autofocus: index == 0,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<VolunteerView>(
                  builder: (context) => VolunteerView(
                    volunteer: volunteer,
                    apiKey: widget.apiKey,
                  ),
                ),
              ),
              icon: Column(
                children: [
                  Image.network(
                    getImageUrl(volunteer.id),
                    headers: getHeaders(apiKey: widget.apiKey),
                    semanticLabel: volunteer.name,
                  ),
                  Text(volunteer.name)
                ],
              ),
            );
          },
          itemCount: widget.volunteers.length,
        ),
      );
}
