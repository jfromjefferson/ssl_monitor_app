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

Future<Service> getOneService({required String uuid}) async {
  Box box = await Hive.openBox<Service>('service');

  final filteredService =
      box.values.where((element) => element.uuid == uuid).first;

  return filteredService;
}

Future<void> clearService() async {
  Box box = await Hive.openBox<Service>('service');

  await box.clear();
}
