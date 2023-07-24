import 'package:flutter/material.dart';
import 'package:super_app_framework/super_app_framework.dart';

import 'navigator_helper.dart';

abstract class NavigationControllerContract {
  NavigationDomains getDomainName(EnumPageIntent enumPageIntent);

  String getRootNavigatorRoute(EnumPageIntent intent);

  Map<String, WidgetBuilder>? getRouteBuilder(
      BuildContext context,
      EnumPageIntent pageIntent,
      NavigationDomains navigationDomain,
      dynamic modelReference);

  NavigatorModel getNavigationProperties(EnumPageIntent pageIntent,
      {dynamic modelRef});

  String? getNavigatorRoute(EnumPageIntent intent);
}
