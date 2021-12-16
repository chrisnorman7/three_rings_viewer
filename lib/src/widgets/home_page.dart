import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../enumerations.dart';
import '../intents.dart';
import '../json/preferences.dart';
import '../json/rota.dart';
import '../json/shift.dart';
import '../json/shift_list.dart';
import '../json/volunteer_list.dart';
import '../util.dart';
import 'api_key_form.dart';
import 'get_url_widget.dart';
import 'shifts_view.dart';
import 'volunteers_view.dart';

/// The type of all JSON.
typedef JsonType = Map<String, dynamic>;

/// The home page widget.
class HomePage extends StatefulWidget {
  /// Create an instance.
  const HomePage({Key? key}) : super(key: key);

  /// The route name.
  static const routeName = '/';

  /// Create state for this widget.
  @override
  _HomePageState createState() => _HomePageState();
}

/// State for [HomePage].
class _HomePageState extends State<HomePage> {
  /// The future that will load the app preferences.
  late final Future<SharedPreferences> _sharedPreferencesFuture;

  /// The page which should be shown.
  late HomePageStates _states;

  /// The loaded shift list.
  ShiftList? _shiftList;

  /// The last time shifts were downloaded.
  DateTime? _shiftsDownloaded;

  /// The loaded volunteers list.
  VolunteerList? _volunteerList;

  /// The last time volunteers were downloaded.
  DateTime? _volunteersDownloaded;

  /// Start [_sharedPreferencesFuture] running.
  @override
  void initState() {
    super.initState();
    _states = HomePageStates.shifts;
    _sharedPreferencesFuture = SharedPreferences.getInstance();
  }

  /// Build a widget.
  @override
  Widget build(BuildContext context) => FutureBuilder<SharedPreferences>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final preferences =
                Preferences.fromSharedPreferences(snapshot.requireData);
            return getHomePage(preferences);
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

  /// Get a list of relevant shifts.
  List<Shift> getShifts(
      {required ShiftList shiftList, required Preferences preferences}) {
    final possibleShifts = shiftList.shifts
        .where((element) =>
            element.allDay == false &&
            preferences.ignoredRotas.contains(element.rota) == false)
        .toList()
      ..sort((a, b) {
        final result = a.start.compareTo(b.start);
        if (result == 0) {
          if (a.rota.name.startsWith('Leader')) {
            return -1;
          }
          return b.rota.name.compareTo(a.rota.name);
        }
        return result;
      });
    final now = DateTime.now();
    final shifts = shiftList.shifts
        .where((element) =>
            element.allDay == true &&
            element.start.year == now.year &&
            element.start.month == now.month &&
            element.start.day == now.day &&
            preferences.ignoredRotas.contains(element.rota) == false)
        .toList();
    DateTime? previousStartTime;
    DateTime? nextStartTime;
    for (final shift in possibleShifts) {
      if ((previousStartTime == null ||
              shift.start.isAfter(previousStartTime)) &&
          shift.end.isBefore(now)) {
        previousStartTime = shift.start;
      } else if ((nextStartTime == null ||
              shift.start.isBefore(nextStartTime)) &&
          shift.start.isAfter(now)) {
        nextStartTime = shift.start;
      }
    }
    if (previousStartTime != null) {
      shifts.addAll(possibleShifts.where((element) =>
          element.start.isAtSameMomentAs(previousStartTime!) &&
          element.end.isBefore(now)));
    }
    shifts.addAll(possibleShifts.where(
        (element) => element.start.isBefore(now) && element.end.isAfter(now)));
    if (nextStartTime != null) {
      shifts.addAll(possibleShifts
          .where((element) => element.start.isAtSameMomentAs(nextStartTime!)));
    }
    return shifts;
  }

  /// Get the main home page.
  Widget getHomePage(Preferences preferences) {
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
      switch (_states) {
        case HomePageStates.shifts:
          title = 'Shifts';
          final shiftList = _shiftList;
          final shiftsDownloaded = _shiftsDownloaded;
          final today = DateTime.now();
          if (shiftList == null ||
              shiftsDownloaded == null ||
              today.difference(shiftsDownloaded) >= httpGetInterval) {
            final yesterday = today.subtract(const Duration(days: 1));
            final tomorrow = today.add(const Duration(days: 1));
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
            final future = http.get<JsonType>(
              '$baseUrl/shift.json',
              queryParameters: <String, dynamic>{
                'start_date': startDate,
                'end_date': endDate
              },
            );
            child = GetUrlWidget(
              future: future,
              onLoad: (json) {
                if (json == null) {
                  return const Center(child: Text('No shifts to show.'));
                }
                final shiftList = ShiftList.fromJson(json);
                _shiftList = shiftList;
                _shiftsDownloaded = today;
                return ShiftsView(
                  shifts:
                      getShifts(preferences: preferences, shiftList: shiftList),
                  preferences: preferences,
                );
              },
            );
          } else {
            child = ShiftsView(
              shifts: getShifts(preferences: preferences, shiftList: shiftList),
              preferences: preferences,
            );
          }
          break;
        case HomePageStates.volunteers:
          title = 'Volunteers';
          final volunteers = _volunteerList?.volunteers;
          final volunteersDownloaded = _volunteersDownloaded;
          final now = DateTime.now();
          if (volunteers == null ||
              volunteersDownloaded == null ||
              now.difference(volunteersDownloaded) >= httpGetInterval) {
            final future = http.get<JsonType>('$baseUrl/directory.json');
            child = GetUrlWidget(
              future: future,
              onLoad: (json) {
                if (json == null) {
                  return const Center(
                    child: Text('No volunteers to show.'),
                  );
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
          child = const Focus(child: Text('News'));
          break;
      }
    }
    final tabCallback = CallbackAction(
      onInvoke: (intent) {
        if (intent is ShiftsTabIntent) {
          setState(() {
            _states = HomePageStates.shifts;
          });
        } else if (intent is VolunteersTabIntent) {
          setState(() {
            _states = HomePageStates.volunteers;
          });
        } else if (intent is NewsTabIntent) {
          setState(() {
            _states = HomePageStates.news;
          });
        } else {
          throw UnimplementedError('Unsupported intent: $intent.');
        }
      },
    );
    final actions = <Widget>[
      ElevatedButton(
        onPressed: () => Navigator.of(context)
            .pushReplacementNamed(ApiKeyForm.routeName, arguments: preferences),
        child: Icon(
          Icons.settings,
          semanticLabel: '${apiKey == null ? "Enter" : "Change"} API key',
        ),
      )
    ];
    if (_states == HomePageStates.shifts &&
        preferences.ignoredRotas.isNotEmpty) {
      actions.insert(
          0,
          PopupMenuButton<Rota>(
            itemBuilder: (context) => [
              for (final rota in preferences.ignoredRotas)
                PopupMenuItem(
                  child: Text(rota.name),
                  value: rota,
                ),
            ],
            child: const Text('Unhide Shifts'),
            onSelected: (value) => preferences.ignoredRotas.remove(value),
          ));
    }
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.digit1, control: true):
            ShiftsTabIntent(),
        SingleActivator(LogicalKeyboardKey.digit2, control: true):
            VolunteersTabIntent(),
        SingleActivator(LogicalKeyboardKey.digit3, control: true):
            NewsTabIntent()
      },
      child: Actions(
        actions: {
          ShiftsTabIntent: tabCallback,
          VolunteersTabIntent: tabCallback,
          NewsTabIntent: tabCallback
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: actions,
          ),
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_rounded), label: 'Shifts'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.people_rounded), label: 'Volunteers'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.info_rounded), label: 'News')
            ],
            currentIndex: _states.index,
            onTap: preferences.apiKey == null
                ? null
                : (value) => setState(() {
                      _states = HomePageStates.values
                          .firstWhere((element) => element.index == value);
                    }),
          ),
        ),
      ),
    );
  }
}
