import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../enumerations.dart';
import '../json/directory_volunteer.dart';
import '../navigation_tab.dart';
import '../util.dart';
import 'cancellable_widget.dart';

/// A widget to show volunteer details.
class VolunteerView extends StatefulWidget {
  /// Create an instance.
  const VolunteerView({required this.volunteer, Key? key}) : super(key: key);

  /// The volunteer to use.
  final DirectoryVolunteer volunteer;

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
    final tabs = [
      const NavigationTab(icon: Icon(Icons.details_rounded), label: 'Details'),
      const NavigationTab(
          icon: Icon(Icons.access_alarms_rounded), label: 'Roles'),
      const NavigationTab(icon: Icon(Icons.more_rounded), label: 'More')
    ];
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
          itemBuilder: (context, index) => Focus(
            child: ListTile(
              title: Text(widget.volunteer.roles[index].name),
            ),
          ),
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
      child: OrientationBuilder(
        builder: (context, orientation) => Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Row(children: [
            Expanded(child: child),
            const VerticalDivider(
              width: 1,
              thickness: 1,
            ),
            NavigationRail(
              destinations: [
                ...tabs.map((e) => NavigationRailDestination(
                    icon: e.icon, label: Text(e.label)))
              ],
              selectedIndex: _state.index,
              onDestinationSelected: (value) => setState(() => _state =
                  VolunteerViewStates.values
                      .firstWhere((element) => element.index == value)),
            )
          ]),
          bottomNavigationBar: orientation == Orientation.portrait
              ? BottomNavigationBar(
                  items: [
                    ...tabs.map((e) =>
                        BottomNavigationBarItem(icon: e.icon, label: e.label))
                  ],
                  currentIndex: _state.index,
                  onTap: (value) => setState(() {
                    _state = VolunteerViewStates.values
                        .firstWhere((element) => element.index == value);
                  }),
                )
              : null,
        ),
      ),
    );
  }
}
