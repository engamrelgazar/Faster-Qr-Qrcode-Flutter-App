import 'package:hive/hive.dart';

part 'operation.g.dart';

@HiveType(typeId: 0)
class Operation extends HiveObject {
  @HiveField(0)
  final String result;

  @HiveField(1)
  final DateTime dateTime;

  Operation(this.result, this.dateTime);
}
