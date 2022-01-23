/// Provides the [ShiftVolunteersView] class.
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../intents.dart';
import '../json/loaded_volunteer.dart';
import '../json/preferences.dart';
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
      {required this.shift, required this.preferences, Key? key})
      : super(key: key);

  /// The shift to show.
  final Shift shift;

  /// The preferences to work with.
  final Preferences preferences;

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
    final ignored = widget.preferences.rotaHidden(widget.shift.rota);
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.keyH, control: true):
            HideUnhideShiftIntent(),
      },
      child: Actions(
        actions: {
          HideUnhideShiftIntent: CallbackAction(
            onInvoke: (intent) => hideUnhideShift(),
          )
        },
        child: CancellableWidget(
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.shift.rota.name),
              actions: [
                ElevatedButton(
                  child: Text(ignored ? 'Unhide Shift' : 'Hide Shift'),
                  onPressed: hideUnhideShift,
                )
              ],
            ),
            body: volunteers.isEmpty
                ? const Focus(
                    child: Center(
                      child: Text('This shift is empty.'),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      final volunteer = volunteers[index];
                      return ListTile(
                        autofocus: index == 0,
                        title: Text(volunteer.name),
                        subtitle: Image.network(
                          volunteer.imageUrl,
                          headers: getHeaders(
                            apiKey: widget.preferences.apiKey!,
                          ),
                        ),
                        onTap: () {
                          final http = Dio(
                            BaseOptions(
                              headers: getHeaders(
                                apiKey: widget.preferences.apiKey!,
                              ),
                            ),
                          );
                          final future = http.get<JsonType>(
                            'https://www.3r.org.uk/directory/${volunteer.id}?format=json',
                          );
                          Navigator.of(context).push(MaterialPageRoute<void>(
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
                                    volunteer: volunteer,
                                    apiKey: widget.preferences.apiKey!,
                                  );
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
        ),
      ),
    );
  }

  /// Hide or unhide this shift.
  Future<void> hideUnhideShift() async {
    if (widget.preferences.ignoredRotas
        .where((element) => element.id == widget.shift.rota.id)
        .isNotEmpty) {
      widget.preferences.ignoredRotas.removeWhere(
        (element) => element.id == widget.shift.rota.id,
      );
    } else {
      widget.preferences.ignoredRotas.add(widget.shift.rota);
    }
    setState(() {});
    final preferences = await SharedPreferences.getInstance();
    widget.preferences.save(preferences);
  }
}
