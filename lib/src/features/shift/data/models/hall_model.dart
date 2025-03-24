import 'package:json_annotation/json_annotation.dart';
import 'package:basic_template/src/features/shift/data/models/table_model.dart';

part 'hall_model.g.dart';

@JsonSerializable()
class HallModel {
  final String hallId;
  final String name;
  final List<TableModel> tables;

  HallModel({
    required this.hallId,
    required this.name,
    required this.tables,
  });

  factory HallModel.fromJson(Map<String, dynamic> json) => _$HallModelFromJson(json);
  Map<String, dynamic> toJson() => _$HallModelToJson(this);
}