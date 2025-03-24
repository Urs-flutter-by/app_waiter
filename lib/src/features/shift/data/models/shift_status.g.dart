// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftStatus _$ShiftStatusFromJson(Map<String, dynamic> json) => ShiftStatus(
      success: json['success'] as bool,
      shiftOpen: json['shiftOpen'] as bool,
      openedAt: json['openedAt'] as String?,
      halls: (json['halls'] as List<dynamic>?)
          ?.map((e) => HallModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShiftStatusToJson(ShiftStatus instance) =>
    <String, dynamic>{
      'success': instance.success,
      'shiftOpen': instance.shiftOpen,
      'openedAt': instance.openedAt,
      'halls': instance.halls,
    };
