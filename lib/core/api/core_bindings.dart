
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'network_info.dart';

class CoreBindings extends Bindings {
  @override
  void dependencies() {
    Get
      ..put(const FlutterSecureStorage(), permanent: true)
     
      ..put(InternetConnectionChecker.instance, permanent: true)
      ..put<NetworkInfo>(
          NetworkInfoImpl(dataConnectionChecker: Get.find<InternetConnectionChecker>()),
          permanent: true)
     ;
  }
}
