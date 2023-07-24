import 'package:super_app_framework/super_app_framework.dart';

import '../services/deeplink/deeplink_service_contract.dart';
import '../services/domain/domain_service_contract.dart';
import '../services/page/page_service_contract.dart';

class DataCollector {
  DataCollector._privateConstructor();

  static final DataCollector instance = DataCollector._privateConstructor();

  dynamic _musicServiceHandler;

  Map<NavigationDomains, DeepLinkServiceContract> _deepLinkServiceHandler =
      <NavigationDomains, DeepLinkServiceContract>{};

  Map<NavigationDomains, DomainServiceContract> _domainContracts =
      <NavigationDomains, DomainServiceContract>{};

  Map<NavigationDomains, PageServiceContract> _pageContracts =
      <NavigationDomains, PageServiceContract>{};


  Map<NavigationDomains, dynamic> _onBoardingPages = {};
  Map<EnumPageIntent, dynamic> _repositories = {};

  Map<NavigationDomains, DomainServiceContract> get domainContracts =>
      _domainContracts;

  Map<NavigationDomains, PageServiceContract> get pageContracts =>
      _pageContracts;

  dynamic get musicServiceHandler => _musicServiceHandler;

  Map<NavigationDomains, DeepLinkServiceContract> get deepLinkServiceHandler =>
      _deepLinkServiceHandler;

  void setDomainContracts(
      Map<NavigationDomains, DomainServiceContract> domainContracts) {
    _domainContracts = domainContracts;
  }

  void setPageContracts(
      Map<NavigationDomains, PageServiceContract> pageContracts) {
    _pageContracts = pageContracts;
  }


  void setDeeplinkContracts(
      Map<NavigationDomains, DeepLinkServiceContract> deepLinkContracts) {
    _deepLinkServiceHandler = deepLinkContracts;
  }

  void setMusicServiceHandler(dynamic musicServiceHandler) {
    _musicServiceHandler = musicServiceHandler;
  }

  void setOnBoardingPages(Map<NavigationDomains, dynamic> onBoardingPages) {
    _onBoardingPages = onBoardingPages;
  }

  void setRepositories(Map<EnumPageIntent, dynamic> repositories) {
    _repositories = repositories;
  }

  Map<NavigationDomains, dynamic> get onBoardingPages => _onBoardingPages;

  Map<EnumPageIntent, dynamic> get repositories => _repositories;
}
