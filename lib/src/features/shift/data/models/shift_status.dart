// lib/src/features/shift/data/models/shift_status.dart
import 'package:json_annotation/json_annotation.dart';

part 'shift_status.g.dart';

@JsonSerializable()
class ShiftStatus {
  final bool success;
  final bool shiftOpen;
  final String? openedAt;

  ShiftStatus({
    required this.success,
    required this.shiftOpen,
    this.openedAt,
  });

  factory ShiftStatus.fromJson(Map<String, dynamic> json) => _$ShiftStatusFromJson(json);
  Map<String, dynamic> toJson() => _$ShiftStatusToJson(this);
}