/// Provides the [Rota] class.
import 'package:json_annotation/json_annotation.dart';

part 'rota.g.dart';

/// A rota in a shift.
@JsonSerializable()
class Rota {
  /// Create an instance.
  const Rota({required this.id, required this.name});

  /// Create an instance from a JSON object.
  factory Rota.fromJson(Map<String, dynamic> json) => _$RotaFromJson(json);

  /// The id of the rota.
  final int id;

  /// The name of the rota.
  final String name;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$RotaToJson(this);
}
