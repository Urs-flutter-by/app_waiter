// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waiter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaiterModel _$WaiterModelFromJson(Map<String, dynamic> json) => WaiterModel(
      id: json['id'] as String,
      username: json['username'] as String,
      restaurantId: json['restaurantId'] as String,
    );

Map<String, dynamic> _$WaiterModelToJson(WaiterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'restaurantId': instance.restaurantId,
    };
