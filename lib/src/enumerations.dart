/// Provides enumerations for the app.
import 'widgets/home_page.dart';
import 'widgets/volunteer_view.dart';

/// The states for [HomePage].
enum HomePageStates {
  /// The shifts view.
  shifts,

  /// The volunteers view.
  volunteers,

  /// The news view.
  news,
}

/// States for [VolunteerView].
enum VolunteerViewStates {
  /// Volunteer details.
  details,

  /// List of volunteer roles.
  roles,

  /// More.
  more,
}
