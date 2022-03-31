/// Provides the [Account] class.
import 'package:json_annotation/json_annotation.dart';

import 'directory_volunteer.dart';

part 'account.g.dart';

/// An account for a [DirectoryVolunteer].
@JsonSerializable()
class Account {
  /// Create an instance.
  const Account({required this.id, required this.username});

  /// Create an instance from a JSON object.
  factory Account.fromJson(final Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  /// The ID of this account.
  final int id;

  /// The username of this account.
  final String username;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
