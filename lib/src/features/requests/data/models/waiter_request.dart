// lib/src/features/requests/data/models/waiter_request.dart
import 'package:json_annotation/json_annotation.dart';

part 'waiter_request.g.dart';

@JsonSerializable()
class WaiterRequest {
  final String requestId;
  final String message;
  final String status;
  /// возможно придется заменить также на
  /// _nullableDateTimeFromJson, toJson: _nullableDateTimeToJson
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;
  @JsonKey(fromJson: _nullableDateTimeFromJson, toJson: _nullableDateTimeToJson)
  final DateTime? confirmedAt;
  @JsonKey(fromJson: _nullableDateTimeFromJson, toJson: _nullableDateTimeToJson)
  final DateTime? completedAt;

  WaiterRequest({
    required this.requestId,
    required this.message,
    required this.status,
    required this.createdAt,
    this.confirmedAt,
    this.completedAt,
  });

  factory WaiterRequest.fromJson(Map<String, dynamic> json) => _$WaiterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$WaiterRequestToJson(this);

  static DateTime _dateTimeFromJson(String timestamp) => DateTime.parse(timestamp);
  static String _dateTimeToJson(DateTime timestamp) => timestamp.toIso8601String();

  static DateTime? _nullableDateTimeFromJson(String? timestamp) =>
      timestamp == null || timestamp.isEmpty ? null : DateTime.parse(timestamp);
  static String? _nullableDateTimeToJson(DateTime? timestamp) =>
      timestamp?.toIso8601String();
}