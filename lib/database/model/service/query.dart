import 'package:hive/hive.dart';
import 'package:ssl_monitor/database/model/service/service.dart';

Future<void> createDBService({required Service service}) async {
  Box box = await Hive.openBox<Service>('service');

  await box.add(service);
}

Future<List<Service>> getServiceList() async {
  Box box = await Hive.openBox<Service>('service');
  List<Service> serviceList = [];

  for (var element in box.values) {
    serviceList.add(element);
  }

  return serviceList;
}
