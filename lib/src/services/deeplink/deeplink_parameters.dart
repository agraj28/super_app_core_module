import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DeeplinkParameters {
  /// Base dynamic link url
  String get baseUrl => 'https://iamaiprod.page.link';

  /// Android parameters . It is default and don't change
  AndroidParameters get androidParameters => AndroidParameters(
        packageName: 'com.iamplus.sit.mafplus',
        minimumVersion: 0,
      );

  /// IOS parameters . It is default and don't change
  IOSParameters get iosParameters => IOSParameters(
        bundleId: 'com.iamplus.sit.mafplus',
        minimumVersion: '0',
        appStoreId: '1531785658',
      );

  /// Social Meta parameters .It is default and don't change
  SocialMetaTagParameters socialMetaTagParameters(
      {String? title, required String imageUrl, String? desc}) {
    return SocialMetaTagParameters(
      description: desc,
      imageUrl: Uri.parse(imageUrl),
      title: title,
    );
  }
}
