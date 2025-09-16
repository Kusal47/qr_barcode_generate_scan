import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:codova_app/core/api/core_bindings.dart';
import 'package:codova_app/core/routes/app_pages.dart';

import 'core/resources/export_resources.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      supportedLocales: [const Locale('en')],
      localizationsDelegates: [],
      fallbackLocale: const Locale('en'),
      themeMode: ThemeMode.light,
      theme: AppThemes.lightThemeData,
      darkTheme: AppThemes.darkThemeData,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      initialBinding: CoreBindings(),
    );
  }
}
