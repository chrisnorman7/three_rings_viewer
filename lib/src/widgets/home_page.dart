import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enumerations.dart';
import '../json/preferences.dart';
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
            final Widget child;
            final String title;
            final apiKey = preferences.apiKey;
            if (apiKey == null) {
              title = 'Error';
              child = const Center(
                child: Text('You must first add your API key.'),
              );
            } else {
              final options = BaseOptions(headers: getHeaders(apiKey: apiKey));
              final http = Dio(options);
              switch (_states) {
                case HomePageStates.shifts:
                  title = 'Shifts';
                  final today = DateTime.now();
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
                      'https://www.3r.org.uk/shift.json',
                      queryParameters: <String, dynamic>{
                        'start_date': startDate,
                        'end_date': endDate
                      });
                  child = GetUrlWidget(
                    future: future,
                    onLoad: (json) {
                      if (json == null) {
                        return const Center(child: Text('No shifts to show.'));
                      } else {
                        final shiftList = ShiftList.fromJson(json);
                        return ShiftsView(
                          shifts: shiftList.shifts,
                          apiKey: apiKey,
                        );
                      }
                    },
                  );
                  break;
                case HomePageStates.volunteers:
                  title = 'Volunteers';
                  final future = http
                      .get<JsonType>('https://www.3r.org.uk/directory.json');
                  child = GetUrlWidget(
                    future: future,
                    onLoad: (json) {
                      if (json == null) {
                        return const Center(
                          child: Text('No volunteers to show.'),
                        );
                      } else {
                        final volunteers = VolunteerList.fromJson(json);
                        return VolunteersView(
                          volunteers: volunteers.volunteers ?? [],
                          apiKey: apiKey,
                        );
                      }
                    },
                  );
                  break;
                case HomePageStates.news:
                  title = 'News';
                  child = const Focus(child: Text('News'));
                  break;
              }
            }
            return Scaffold(
              appBar: AppBar(
                title: Text(title),
                leading: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed(
                      ApiKeyForm.routeName,
                      arguments: preferences),
                  child: Icon(
                    Icons.settings,
                    semanticLabel:
                        '${apiKey == null ? "Enter" : "Change"} API key',
                  ),
                ),
              ),
              body: child,
              bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today_rounded),
                      label: 'Shifts'),
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
}
