import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:super_app_framework/super_app_framework.dart';
import '../helpers/data_collector.dart';
import 'domain/domain_service_contract.dart';
import 'page/page_service_contract.dart';


/// Singleton,
///
/// Responsible to fetch/set configuration for all domains,
/// Holding Instance of domain service contracts.
class ServiceHelper {
  ServiceHelper._privateConstructor();


  static final ServiceHelper getInstance = ServiceHelper._privateConstructor();

  Future<void> initConfig() async {

  }

  //Update the domainConfig in domain's contract (i.e in _domainContracts)
  Future<void> _updateDomainContracts(
      {NavigationDomains? domain, DomainConfig? domainConfig}) async {
    if (domainConfig != null) {
      if (DataCollector.instance.domainContracts[domain!] != null) {
        DataCollector.instance.domainContracts[domain]?.domainConfig =
            domainConfig;
        FrameworkServiceHelper.getInstance.setupDomainConfig(
            domain: domain,
            domainConfig:
                DataCollector.instance.domainContracts[domain]?.domainConfig);
      }
    }
  }

  /// Which,
  ///
  /// Returns [DomainServiceContract] instance as per request
  DomainServiceContract? getServiceContract(NavigationDomains domain) {
    return DataCollector.instance.domainContracts.containsKey(domain)
        ? DataCollector.instance.domainContracts[domain]
        : null;
  }

  /// Which,
  ///
  /// Returns [PageServiceContract] instance as per request
  PageServiceContract? getPageServiceContract({
    required NavigationDomains domain,
    EnumPageIntent? pageIntent,
  }) {
    return getServiceContract(domain)!
        .getPageServiceContract(pageIntent: pageIntent);
  }

  /// Which,
  ///
  /// Extract the domain name string from enum
  String getDomainName(NavigationDomains domain) {
    return domain
        .toString()
        .substring(domain.toString().indexOf('.') + 1)
        .toLowerCase();
  }

  /// Which,
  ///
  /// Find current app version in valid versions list,
  /// If current version is available, return => TRUE
  /// Else returns => FALSE
  Future<bool> isForceUpdate() async {
    // write code for force update
    return false;
  }

  Future<bool> isUpdateAvailable() async {
    // check if update is available
    return false;
  }

  // Which returns current app version code
  Future<int?> getVersionCode() async {
    int versionCode;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      var code = SystemInfoHelpers.getInstance.buildNumber;
      return int.tryParse(code ?? '1');
    } on PlatformException {
      versionCode = 1;
    }

    return versionCode;
  }

  /// Which,
  ///
  /// Find current ML-Model version in valid versions list,
  /// If current version is available, return => TRUE
  /// Else returns => FALSE,
  /// Defaults => TRUE
  // Future<bool> isValidMLModel() async {
  //   var currVersionCode = await _getVersionCode();
  //   var currModelVersion = await _getModelVersion();
  //
  //   var validVersions = _appCredential?.validVersions?.firstWhere(
  //       (version) => version?.code == currVersionCode,
  //       orElse: () => null);
  //
  //   return validVersions?.supportedMlModels?.contains(currModelVersion) ?? true;
  // }
  //
  // Future<String> _getModelVersion() async {
  //   return _storageService.getPrefs(localModelVersion, defaultValue: '');
  // }


}
