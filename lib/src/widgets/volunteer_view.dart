import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../json/directory_volunteer.dart';
import '../util.dart';
import 'cancellable_widget.dart';
import 'volunteer_roles_view.dart';

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
  /// Build a widget.
  @override
  Widget build(BuildContext context) {
    var title = widget.volunteer.name;
    if (widget.volunteer.isSupportPerson) {
      title += ' (Support Volunteer)';
    }
    final children = [
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
      ListTile(
        title: const Text('Roles'),
        subtitle: Text(widget.volunteer.roles.length.toString()),
        onTap: () =>
            Navigator.of(context).push<VolunteerRolesView>(MaterialPageRoute(
          builder: (context) => VolunteerRolesView(volunteer: widget.volunteer),
        )),
      )
    ];
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
    return CancellableWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView(children: children),
      ),
    );
  }
}
