import 'package:hive/hive.dart';
import 'package:ssl_monitor/database/model/user/user.dart';

part 'service.g.dart';

@HiveType(typeId: 2)
class Service extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String url;

  @HiveField(2)
  late Map<String, dynamic> serviceInfo;

  @HiveField(3)
  late String uuid;

  @HiveField(4)
  late User user;

  Service({
    required this.name,
    required this.url,
    required this.serviceInfo,
    required this.user,
    required this.uuid,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'url': url,
      'serviceInfo': serviceInfo,
      'user': user.toMap(),
      'uuid': uuid,
    };

    return map;
  }

  Service.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    url = map['url'];
    serviceInfo = map['serviceInfo'];
    user = map['user'];
    uuid = map['uuid'];
  }
}
