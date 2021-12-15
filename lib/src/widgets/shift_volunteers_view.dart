import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../json/loaded_volunteer.dart';
import '../json/shift_volunteer.dart';
import '../util.dart';
import 'cancellable_widget.dart';
import 'home_page.dart';
import 'volunteer_view.dart';

/// A widget that shows the volunteers on shift.
class ShiftVolunteersView extends StatefulWidget {
  /// Create an instance.
  const ShiftVolunteersView(
      {required this.title,
      required this.volunteers,
      required this.apiKey,
      Key? key})
      : super(key: key);

  /// The title of the shift.
  final String title;

  /// The volunteers that are on this shift.
  final List<ShiftVolunteer> volunteers;

  /// The API key to be used when getting images.
  final String apiKey;

  /// Create state for this widget.
  @override
  _ShiftVolunteersViewState createState() => _ShiftVolunteersViewState();
}

/// State for [ShiftVolunteersView].
class _ShiftVolunteersViewState extends State<ShiftVolunteersView> {
  /// Build a widget.
  @override
  Widget build(BuildContext context) => CancellableWidget(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: ListView.builder(
            itemBuilder: (context, index) {
              final volunteer = widget.volunteers[index];
              return ListTile(
                title: Text(volunteer.name),
                subtitle: Image.network(
                  volunteer.imageUrl,
                  headers: getHeaders(apiKey: widget.apiKey),
                ),
                onTap: () async {
                  final http = Dio(
                      BaseOptions(headers: getHeaders(apiKey: widget.apiKey)));
                  final response = await http.get<JsonType>(
                      'https://www.3r.org.uk/directory/${volunteer.id}?format=json');
                  final json = response.data!;
                  final loadedVolunteer = LoadedVolunteer.fromJson(json);
                  Navigator.of(context).push(MaterialPageRoute<VolunteerView>(
                    builder: (context) => VolunteerView(
                        volunteer: loadedVolunteer.volunteer,
                        apiKey: widget.apiKey),
                  ));
                },
              );
            },
            itemCount: widget.volunteers.length,
          ),
        ),
      );
}
