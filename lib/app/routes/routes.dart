import 'package:flutter/widgets.dart';
import 'package:urban_spot/home/home.dart';
import 'package:urban_spot/login/login.dart';
import 'package:urban_spot/app/app.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
    default:
      return [LoginPage.page()];
  }
}