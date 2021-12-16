import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../json/loaded_volunteer.dart';
import '../json/shift.dart';
import '../util.dart';
import 'cancellable_widget.dart';
import 'get_url_widget.dart';
import 'home_page.dart';
import 'volunteer_view.dart';

/// A widget that shows the volunteers on shift.
class ShiftVolunteersView extends StatefulWidget {
  /// Create an instance.
  const ShiftVolunteersView(
      {required this.shift, required this.apiKey, Key? key})
      : super(key: key);

  /// The shift to show.
  final Shift shift;

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
  Widget build(BuildContext context) {
    final volunteers = [
      for (final volunteerShift in widget.shift.volunteerShifts)
        volunteerShift.volunteer
    ];
    return CancellableWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.shift.title),
        ),
        body: volunteers.isEmpty
            ? const Focus(
                child: Center(
                child: Text('This shift is empty.'),
              ))
            : ListView.builder(
                itemBuilder: (context, index) {
                  final volunteer = volunteers[index];
                  return ListTile(
                    title: Text(volunteer.name),
                    subtitle: Image.network(
                      volunteer.imageUrl,
                      headers: getHeaders(apiKey: widget.apiKey),
                    ),
                    onTap: () {
                      final http = Dio(BaseOptions(
                          headers: getHeaders(apiKey: widget.apiKey)));
                      final future = http.get<JsonType>(
                          'https://www.3r.org.uk/directory/${volunteer.id}?format=json');
                      Navigator.of(context)
                          .push(MaterialPageRoute<GetUrlWidget>(
                        builder: (context) => GetUrlWidget(
                          future: future,
                          onLoad: (json) {
                            if (json == null) {
                              return Scaffold(
                                appBar: AppBar(
                                  title: const Text('Error'),
                                ),
                                body: const Center(
                                  child: Text('Failed to load volunteer.'),
                                ),
                              );
                            } else {
                              final volunteer =
                                  LoadedVolunteer.fromJson(json).volunteer;
                              return VolunteerView(
                                  volunteer: volunteer, apiKey: widget.apiKey);
                            }
                          },
                        ),
                      ));
                    },
                  );
                },
                itemCount: volunteers.length,
              ),
      ),
    );
  }
}
