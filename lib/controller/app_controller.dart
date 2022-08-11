import 'package:get/get.dart';
import 'package:ssl_monitor/database/model/user/user.dart';

import '../database/model/user/query.dart';

class AppController extends GetxController {
  User? user;

  String? get userName => user?.name;

  @override
  void onInit() async {
    user = (await getUser())!;
    super.onInit();
  }
}
