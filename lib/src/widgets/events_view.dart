/// Provides the [EventsView] class.
import 'package:flutter/material.dart';

import '../json/event_list.dart';
import '../util.dart';

/// A widget for rendering and [EventList] instance.
class EventsView extends StatefulWidget {
  /// Create an instance.
  const EventsView({required this.eventList, Key? key}) : super(key: key);

  /// The vent list to render.
  final EventList eventList;

  /// Create state for this widget.
  @override
  _EventsViewState createState() => _EventsViewState();
}

/// State for [EventsView].
class _EventsViewState extends State<EventsView> {
  /// Build a widget.
  @override
  Widget build(BuildContext context) => ListView.builder(
        itemBuilder: (context, index) {
          final event = widget.eventList.events[index];
          final isThreeLine = event.description.isNotEmpty;
          final date = event.date;
          final day = padNumber(date.day);
          final month = padNumber(date.month);
          final year = date.year;
          return ListTile(
            autofocus: index == 0,
            title: Text('$day/$month/$year'),
            subtitle: Text(event.name),
            isThreeLine: isThreeLine,
            trailing: isThreeLine ? Text(event.description) : null,
            onTap: () {},
          );
        },
        itemCount: widget.eventList.events.length,
      );
}
