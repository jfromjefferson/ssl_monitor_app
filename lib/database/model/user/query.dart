import 'package:hive/hive.dart';
import 'package:ssl_monitor/database/model/user/user.dart';

Future<void> createDBUser({required User user}) async {
  Box box = await Hive.openBox<User>('user');

  User? userTemp = await getUser();

  if (userTemp == null) {
    await box.add(user);
  }
}

Future<User?> getUser() async {
  Box box = await Hive.openBox<User>('user');

  User? user = box.get(0);

  return user;
}

Future<void> clearUser() async {
  Box box = await Hive.openBox<User>('user');

  await box.clear();
}
