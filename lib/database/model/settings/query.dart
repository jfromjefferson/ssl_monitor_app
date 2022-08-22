import 'package:hive/hive.dart';
import 'package:ssl_monitor/database/model/settings/settings.dart';

Future<Settings?> getSettings() async {
  Box box = await Hive.openBox<Settings>('settings');

  Settings? settings = await box.get(0);

  return settings;
}

Future<void> createDBSettings({required Settings settings}) async {
  Box box = await Hive.openBox<Settings>('settings');

  Settings? settingsTemp = await getSettings();

  if (settingsTemp == null) {
    await box.add(settings);
  }
}
