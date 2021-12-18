import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../enumerations.dart';
import '../json/directory_volunteer.dart';
import '../json/volunteer_list.dart';
import '../util.dart';
import 'cancellable_widget.dart';
import 'get_url_widget.dart';
import 'home_page.dart';
import 'oriented_scaffold.dart';
import 'volunteers_view.dart';

/// A widget to show volunteer details.
class VolunteerView extends StatefulWidget {
  /// Create an instance.
  const VolunteerView({required this.volunteer, required this.apiKey, Key? key})
      : super(key: key);

  /// The volunteer to use.
  final DirectoryVolunteer volunteer;

  /// The API key to use.
  final String apiKey;

  /// Create state for this widget.
  @override
  _VolunteerViewState createState() => _VolunteerViewState();
}

/// State for [VolunteerView].
class _VolunteerViewState extends State<VolunteerView> {
  /// The state of this page.
  late VolunteerViewStates _state;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _state = VolunteerViewStates.details;
  }

  /// Build a widget.
  @override
  Widget build(BuildContext context) {
    var title = widget.volunteer.name;
    if (widget.volunteer.isSupportPerson) {
      title += ' (Support Volunteer)';
    }
    final Widget child;
    switch (_state) {
      case VolunteerViewStates.details:
        final children = <Widget>[];
        for (final property in widget.volunteer.volunteerProperties) {
          for (final datum in property.values) {
            final propertyValue = datum.value;
            if (propertyValue == null) {
              continue;
            }
            final propertyName = datum.orgName;
            final clickable = propertyName.startsWith('Email') ||
                propertyName.startsWith('Telephone');
            final title = Text(propertyName);
            final value = Text(propertyValue);
            if (clickable) {
              children.add(ListTile(
                title: title,
                subtitle: value,
                onTap: () async {
                  final String url;
                  if (propertyName.startsWith('Email')) {
                    url = 'mailto:$propertyValue';
                  } else {
                    // Must be a telephone number.
                    final html = const HtmlEscape().convert(propertyValue);
                    url = 'tel:$html';
                  }
                  try {
                    if (await launch(url) == false) {
                      throw MissingPluginException('Failed to open $url.');
                    }
                  } on MissingPluginException catch (e) {
                    showDialog<AlertDialog>(
                      context: context,
                      builder: (context) => AlertDialog(
                        actions: [
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.done_rounded,
                                semanticLabel: 'OK',
                              ))
                        ],
                        content: SingleChildScrollView(
                          child: Text(e.message ?? 'Unknown error.'),
                        ),
                        title: const Text('URL Error'),
                      ),
                    );
                  }
                },
              ));
            } else {
              children.add(Focus(
                  child: ListTile(
                title: title,
                subtitle: value,
              )));
            }
          }
        }
        child = ListView.builder(
          itemBuilder: (context, index) => children[index],
          itemCount: children.length,
        );
        break;
      case VolunteerViewStates.roles:
        child = ListView.builder(
          itemBuilder: (context, index) {
            final role = widget.volunteer.roles[index];
            return ListTile(
              title: Text(role.name),
              onTap: () {
                final url = '$baseUrl/directory/view_by_role/${role.id}.json';
                final http = Dio(
                    BaseOptions(headers: getHeaders(apiKey: widget.apiKey)));
                final future = http.get<JsonType>(url);
                Navigator.of(context).push(MaterialPageRoute<GetUrlWidget>(
                  builder: (context) => GetUrlWidget(
                      future: future,
                      onLoad: (json) {
                        final title = '${role.name} Volunteers';
                        final appBar = AppBar(
                          title: Text(title),
                        );
                        if (json == null) {
                          return CancellableWidget(
                            child: Scaffold(
                              appBar: appBar,
                              body: const Center(
                                  child: Text('No volunteers to show.')),
                            ),
                          );
                        }
                        final volunteerList = VolunteerList.fromJson(json);
                        final volunteers = volunteerList.volunteers;
                        return CancellableWidget(
                          child: Scaffold(
                            appBar: appBar,
                            body: volunteers == null
                                ? const Center(
                                    child: Text('No volunteers to show.'),
                                  )
                                : VolunteersView(
                                    volunteers: volunteers,
                                    apiKey: widget.apiKey),
                          ),
                        );
                      }),
                ));
              },
            );
          },
          itemCount: widget.volunteer.roles.length,
        );
        break;
      case VolunteerViewStates.more:
        child = ListView(
          children: [
            Focus(
              child: ListTile(
                title: const Text('Member Since'),
                subtitle: Text(prettyDate(widget.volunteer.createdAt)),
              ),
            ),
            Focus(
              child: ListTile(
                title: const Text('Added By'),
                subtitle: Text(widget.volunteer.creator.name),
              ),
            ),
            Focus(
                child: ListTile(
              title: const Text('Updated At'),
              subtitle: Text(prettyDate(widget.volunteer.updatedAt)),
            )),
            Focus(
                child: ListTile(
              title: const Text('Updated By'),
              subtitle: Text(widget.volunteer.updater.name),
            )),
          ],
        );
        break;
    }
    return CancellableWidget(
      child: OrientedScaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        child: child,
        tabs: const [
          OrientedScaffoldTab(
              icon: Icon(Icons.details_rounded), label: 'Details'),
          OrientedScaffoldTab(
              icon: Icon(Icons.access_alarms_rounded), label: 'Roles'),
          OrientedScaffoldTab(icon: Icon(Icons.more_rounded), label: 'More')
        ],
        selectedIndex: _state.index,
        onNavigate: (value) => setState(
          () => _state = VolunteerViewStates.values
              .firstWhere((element) => element.index == value),
        ),
      ),
    );
  }
}
