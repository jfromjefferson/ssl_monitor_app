import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  Map<String, dynamic>? extraInfo;

  @HiveField(2)
  late String sysUserUuid;

  User({
    required this.name,
    required this.sysUserUuid,
    this.extraInfo,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'sysUserUuid': sysUserUuid,
      'extraInfo': extraInfo,
    };

    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    sysUserUuid = map['sysUserUuid'];
    extraInfo = map['extraInfo'];
  }
}
