import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 3)
class Settings extends HiveObject {
  @HiveField(0)
  late String languageCode;

  Settings({required this.languageCode});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'languageCode': languageCode,
    };

    return map;
  }

  Settings.fromMap(Map<String, dynamic> map) {
    languageCode = map['languageCode'];
  }
}
