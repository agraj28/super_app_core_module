import 'package:flutter/material.dart';
import '../../../core.dart';



// Default navigation attributes
EnumPageIntent defaultNavPage = EnumPageIntent.Home;
EnumPageIntent defaultModalNavPage = EnumPageIntent.App;

Map<NavigationDomains, GlobalKey<NavigatorState>> navigatorKeys = {
  NavigationDomains.Common: GlobalKey<NavigatorState>(),
  NavigationDomains.App: GlobalKey<NavigatorState>(),
};

Map<NavigationDomains, ThemeModuleType> themeForDomain = {
  NavigationDomains.Home: ThemeModuleType.Home,

};

List<NavigationDomains> getSupportedDomains() {
  return [
    NavigationDomains.Common,
    NavigationDomains.Home,

  ];
}

// Get the domain name
NavigationDomains getDomainName(EnumPageIntent? enumPageIntent) {
  var navigationDomains = NavigationDomains.Home;
  switch (enumPageIntent) {

    case EnumPageIntent.App:
      navigationDomains = NavigationDomains.App;
      break;

    default:
      break;
  }
  return navigationDomains;
}

// Get the domain root page to control the back navigation
EnumPageIntent getDomainRootPage(EnumPageIntent? intent) {
  var _domainRootPage = EnumPageIntent.Home;
  switch (intent) {
    case EnumPageIntent.Home:
      _domainRootPage = EnumPageIntent.Home;
      break;
    default:
      break;
  }
  return _domainRootPage;
}

class NavigatorData {
  final EnumPageIntent? intent;
  final dynamic pageModel;

  const NavigatorData({this.intent, this.pageModel});
}

class NavigatorModel {
  final NavigationDomains? navDomain;
  final Map<String, Widget Function(BuildContext?)>? routeBuilders;
  final GlobalKey<NavigatorState>? navigatorKey;
  final String? rootNavigatorRoute;

  const NavigatorModel(
      {this.navDomain,
      this.routeBuilders,
      this.navigatorKey,
      this.rootNavigatorRoute});
}

