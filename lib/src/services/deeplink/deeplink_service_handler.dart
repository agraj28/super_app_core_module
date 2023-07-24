import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:super_app_framework/super_app_framework.dart';

import '../../extension/extensions.dart';

class DeeplinkServiceHandler {
  DeeplinkServiceHandler._privateConstructor();
  static final DeeplinkServiceHandler instance =
      DeeplinkServiceHandler._privateConstructor();

  Future<void> initService() async {
    final urlData = await FirebaseDynamicLinks.instance.getInitialLink();
    await _handleDeeplinks(urlData);

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
      await _handleDeeplinks(dynamicLinkData);
    }).onError((error) {
     print("error $error");
    });
  }

  Future<void> _handleDeeplinks(PendingDynamicLinkData? data) async {
    var link = data?.link;
    if (link != null) {
      var domain = _extractDomain(link);
      print("error occured in handle deep link");
      await selectDomain(domain, data);
    }
  }

  /// selecting domain name for using spesific handler.
  Future<void> selectDomain(
      NavigationDomains domain, PendingDynamicLinkData? urlData) async {
    switch (domain) {
      case NavigationDomains.Home:
        break;
      case NavigationDomains.App:
        break;
      default:
    }
  }

  /// Extract the domain from dynamic links
  NavigationDomains _extractDomain(Uri deeplink) {
    var domain = _enumTypeFromString(deeplink.pathSegments.first.capitalize());
    return domain;
  }

  /// Converting the domain name strint to enum
  NavigationDomains _enumTypeFromString(String typeString) => NavigationDomains
      .values
      .firstWhere((type) => type.toString() == 'NavigationDomains.$typeString');
}
