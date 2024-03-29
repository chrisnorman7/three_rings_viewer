import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../enumerations.dart';
import '../intents.dart';
import '../json/event_list.dart';
import '../json/news_list.dart';
import '../json/preferences.dart';
import '../json/rota.dart';
import '../json/shift_list.dart';
import '../json/volunteer_list.dart';
import '../util.dart';
import 'api_key_form.dart';
import 'events_view.dart';
import 'get_text.dart';
import 'get_url_widget.dart';
import 'news_view.dart';
import 'oriented_scaffold.dart';
import 'shifts_view.dart';
import 'volunteers_view.dart';

/// The type of all JSON.
typedef JsonType = Map<String, dynamic>;

/// The home page widget.
class HomePage extends StatefulWidget {
  /// Create an instance.
  const HomePage({final Key? key}) : super(key: key);

  /// The route name.
  static const routeName = '/';

  /// Create state for this widget.
  @override
  HomePageState createState() => HomePageState();
}

/// State for [HomePage].
class HomePageState extends State<HomePage> {
  /// The future that will load the app preferences.
  late final Future<SharedPreferences> _sharedPreferencesFuture;

  /// The page which should be shown.
  late HomePageStates _state;

  /// The loaded shift list.
  ShiftList? _shiftList;

  /// The last time shifts were downloaded.
  DateTime? _shiftsDownloaded;

  /// Decides which shifts to show.
  late ShiftViews _shiftView;

  /// The loaded volunteers list.
  VolunteerList? _volunteerList;

  /// The last time volunteers were downloaded.
  DateTime? _volunteersDownloaded;

  /// The loaded news list.
  NewsList? _newsList;

  /// The last time the news was downloaded.
  DateTime? _newsDownloaded;

  /// The last event list.
  EventList? _eventList;

  /// When the news was last downloaded.
  DateTime? _eventsDownloaded;

  /// Start [_sharedPreferencesFuture] running.
  @override
  void initState() {
    super.initState();
    _shiftView = ShiftViews.relevant;
    _state = HomePageStates.shifts;
    _sharedPreferencesFuture = SharedPreferences.getInstance();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => FutureBuilder<SharedPreferences>(
        builder: (final context, final snapshot) {
          if (snapshot.hasData) {
            final preferences =
                Preferences.fromSharedPreferences(snapshot.requireData);
            return getHomePage(
              preferences: preferences,
              sharedPreferences: snapshot.requireData,
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Focus(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: snapshot.error.toString()),
                      const TextSpan(text: '\n'),
                      TextSpan(text: snapshot.stackTrace.toString())
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Loading'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
        future: _sharedPreferencesFuture,
      );

  /// Get the main home page.
  Widget getHomePage({
    required final Preferences preferences,
    required final SharedPreferences sharedPreferences,
  }) {
    final Widget child;
    final String title;
    final apiKey = preferences.apiKey;
    if (apiKey == null) {
      title = 'API Key Required';
      child = const Center(
        child: Card(child: Text('You must first add your API key.')),
      );
    } else {
      final options = BaseOptions(headers: getHeaders(apiKey: apiKey));
      final http = Dio(options);
      final now = DateTime.now();
      switch (_state) {
        case HomePageStates.shifts:
          title = 'Shifts';
          final shiftList = _shiftList;
          final shiftsDownloaded = _shiftsDownloaded;
          if (shiftList == null ||
              shiftsDownloaded == null ||
              now.difference(shiftsDownloaded) >= httpGetInterval) {
            Map<String, String> queryParams;
            switch (_shiftView) {
              case ShiftViews.relevant:
                final yesterday = now.subtract(const Duration(days: 1));
                final tomorrow = now.add(const Duration(days: 1));
                var stuff = [
                  yesterday.year,
                  padNumber(yesterday.month),
                  padNumber(yesterday.day)
                ];
                final startDate = stuff.join('-');
                stuff = [
                  tomorrow.year,
                  padNumber(tomorrow.month),
                  padNumber(tomorrow.day)
                ];
                final endDate = stuff.join('-');
                queryParams = {'start_date': startDate, 'end_date': endDate};
                break;
              case ShiftViews.today:
                final tomorrow = now.add(const Duration(days: 1));
                var stuff = [
                  now.year,
                  now.month.toString().padLeft(2, '0'),
                  now.day.toString().padLeft(2, '0')
                ];
                final startDate = stuff.join('-');
                stuff = [
                  tomorrow.year,
                  tomorrow.month.toString().padLeft(2, '0'),
                  tomorrow.day.toString().padLeft(2, '0')
                ];
                final endDate = stuff.join('-');
                queryParams = {
                  'start_date': startDate,
                  'end_date': endDate,
                };
                break;
            }
            final future = http.get<JsonType>(
              '$baseUrl/shift.json',
              queryParameters: queryParams,
            );
            child = GetUrlWidget(
              future: future,
              onLoad: (final json) {
                if (json == null) {
                  return const CenterText(text: 'No shifts to show.');
                }
                final shiftList = ShiftList.fromJson(json);
                _shiftList = shiftList;
                _shiftsDownloaded = now;
                return ShiftsView(
                  shiftList: shiftList,
                  preferences: preferences,
                  shiftView: _shiftView,
                );
              },
            );
          } else {
            child = ShiftsView(
              shiftList: shiftList,
              preferences: preferences,
              shiftView: _shiftView,
            );
          }
          break;
        case HomePageStates.volunteers:
          title = 'Volunteers';
          final volunteers = _volunteerList?.volunteers;
          final volunteersDownloaded = _volunteersDownloaded;
          if (volunteers == null ||
              volunteersDownloaded == null ||
              now.difference(volunteersDownloaded) >= httpGetInterval) {
            final future = http.get<JsonType>('$baseUrl/directory.json');
            child = GetUrlWidget(
              future: future,
              onLoad: (final json) {
                if (json == null) {
                  return const CenterText(text: 'No volunteers to show.');
                }
                _volunteersDownloaded = now;
                final volunteerList = VolunteerList.fromJson(json);
                _volunteerList = volunteerList;
                return VolunteersView(
                  volunteers: volunteerList.volunteers ?? [],
                  apiKey: apiKey,
                );
              },
            );
          } else {
            child = VolunteersView(volunteers: volunteers, apiKey: apiKey);
          }
          break;
        case HomePageStates.news:
          title = 'News';
          final newsList = _newsList;
          final newsDownloaded = _newsDownloaded;
          if (newsList == null ||
              newsDownloaded == null ||
              now.difference(newsDownloaded) >= httpGetInterval) {
            final future = http.get<JsonType>('$baseUrl/news.json');
            child = GetUrlWidget(
              future: future,
              onLoad: (final json) {
                if (json == null) {
                  return const CenterText(text: 'No news items to show.');
                }
                final newsList = NewsList.fromJson(json);
                _newsList = newsList;
                _newsDownloaded = now;
                return NewsView(
                  newsList: newsList,
                  apiKey: apiKey,
                );
              },
            );
          } else {
            child = NewsView(
              newsList: newsList,
              apiKey: apiKey,
            );
          }
          break;
        case HomePageStates.events:
          title = 'Events';
          final events = _eventList;
          final eventsDownloaded = _eventsDownloaded;
          if (events == null ||
              eventsDownloaded == null ||
              now.difference(eventsDownloaded) >= httpGetInterval) {
            final future = http.get<JsonType>('$baseUrl/events.json');
            child = GetUrlWidget(
              future: future,
              onLoad: (final json) {
                if (json == null) {
                  return const CenterText(text: 'No events to show.');
                }
                _eventsDownloaded = now;
                final eventList = EventList.fromJson(json);
                _eventList = eventList;
                return EventsView(eventList: eventList);
              },
            );
          } else {
            child = EventsView(eventList: events);
          }
          break;
      }
    }
    final tabCallback = CallbackAction(
      onInvoke: (final intent) {
        if (intent is ShiftsTabIntent) {
          setState(() {
            _state = HomePageStates.shifts;
          });
        } else if (intent is VolunteersTabIntent) {
          setState(() {
            _state = HomePageStates.volunteers;
          });
        } else if (intent is NewsTabIntent) {
          setState(() {
            _state = HomePageStates.news;
          });
        } else if (intent is EventsTabIntent) {
          setState(() {
            _state = HomePageStates.events;
          });
        } else {
          throw UnimplementedError('Unsupported intent: $intent.');
        }
        return null;
      },
    );
    final actions = <Widget>[];
    if (_state == HomePageStates.shifts) {
      if (preferences.ignoredRotas.isNotEmpty) {
        actions.add(
          PopupMenuButton<Rota>(
            itemBuilder: (final context) => [
              for (final rota in preferences.ignoredRotas)
                PopupMenuItem(
                  value: rota,
                  child: Text(rota.name),
                ),
            ],
            child: const Text('Unhide Shifts'),
            onSelected: (final value) => setState(() {
              preferences.ignoredRotas
                  .removeWhere((final element) => element.id == value.id);
              preferences.save(sharedPreferences);
            }),
          ),
        );
      }
      actions.add(
        ElevatedButton(
          onPressed: () => setState(() {
            _shiftList = null;
            _shiftsDownloaded = null;
            _shiftView = (_shiftView == ShiftViews.relevant)
                ? ShiftViews.today
                : ShiftViews.relevant;
          }),
          child: Text(
            _shiftView == ShiftViews.relevant ? 'All Day' : 'Relevant',
          ),
        ),
      );
    }
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.digit1, control: true):
            ShiftsTabIntent(),
        SingleActivator(LogicalKeyboardKey.digit2, control: true):
            VolunteersTabIntent(),
        SingleActivator(LogicalKeyboardKey.digit3, control: true):
            NewsTabIntent(),
        SingleActivator(LogicalKeyboardKey.digit4, control: true):
            EventsTabIntent()
      },
      child: Actions(
        actions: {
          ShiftsTabIntent: tabCallback,
          VolunteersTabIntent: tabCallback,
          NewsTabIntent: tabCallback,
          EventsTabIntent: tabCallback,
        },
        child: OrientedScaffold(
          appBar: AppBar(
            leading: ElevatedButton(
              onPressed: () => Navigator.of(context).pushReplacementNamed(
                ApiKeyForm.routeName,
                arguments: preferences,
              ),
              child: Icon(
                Icons.settings,
                semanticLabel: '${apiKey == null ? "Enter" : "Change"} API key',
              ),
            ),
            title: Text(title),
            actions: actions,
          ),
          tabs: const [
            OrientedScaffoldTab(
              icon: Icon(Icons.calendar_today_rounded),
              label: 'Shifts',
            ),
            OrientedScaffoldTab(
              icon: Icon(Icons.people_rounded),
              label: 'Volunteers',
            ),
            OrientedScaffoldTab(icon: Icon(Icons.info_rounded), label: 'News'),
            OrientedScaffoldTab(
              icon: Icon(Icons.schedule_rounded),
              label: 'Events',
            ),
          ],
          onNavigate: (final value) => setState(
            () => _state = HomePageStates.values
                .firstWhere((final element) => element.index == value),
          ),
          selectedIndex: _state.index,
          child: child,
        ),
      ),
    );
  }
}
