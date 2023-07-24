import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:super_app_framework/super_app_framework.dart';

abstract class DeepLinkServiceContract {
  Future<void> initDynamicLinks(PendingDynamicLinkData? urlData);
  Future createDynamicLinks(
    /// we need this for parsing spesific domain
    NavigationDomains domain,

    /// It is not using now but for Navigation you can use it.
    EnumPageIntent pageIntent, {

    /// if you set true it will show below( title, imageUrl and desc on the url)
    bool isSocial = false,

    /// can be anything for redirecting spesific section
    String? category,

    /// content id
    String? itemId,

    /// content title
    String? title,

    /// content image
    String? imageUrl,

    /// content description
    String? desc,
  });
}
