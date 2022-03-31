import 'package:flutter/material.dart';

import '../json/directory_volunteer.dart';
import '../util.dart';
import 'volunteer_view.dart';

/// A widget to show a list of volunteers.
class VolunteersView extends StatefulWidget {
  /// Create an instance.
  const VolunteersView({
    required this.volunteers,
    required this.apiKey,
    final Key? key,
  }) : super(key: key);

  /// The volunteers to show.
  final List<DirectoryVolunteer> volunteers;

  /// The API key to use while getting volunteer images.
  final String apiKey;

  /// Create state for this widget.
  @override
  VolunteersViewState createState() => VolunteersViewState();
}

/// State for [VolunteersView].
class VolunteersViewState extends State<VolunteersView> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) => OrientationBuilder(
        builder: (final context, final orientation) => GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: orientation == Orientation.portrait ? 4 : 5,
          ),
          itemBuilder: (final context, final index) {
            final volunteer = widget.volunteers[index];
            return ListTile(
              autofocus: index == 0,
              title: Image.network(
                getImageUrl(volunteer.id),
                headers: getHeaders(apiKey: widget.apiKey),
              ),
              subtitle: Text(volunteer.name),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (final context) => VolunteerView(
                    volunteer: volunteer,
                    apiKey: widget.apiKey,
                  ),
                ),
              ),
            );
          },
          itemCount: widget.volunteers.length,
        ),
      );
}
