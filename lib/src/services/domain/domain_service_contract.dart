import 'package:super_app_framework/super_app_framework.dart';
import '../page/page_service_contract.dart';


abstract class DomainServiceContract {
  PageServiceContract? getPageServiceContract({EnumPageIntent? pageIntent});

  Map<EnumPageIntent, List<String>>? getAllMLIntents();

  EnumPageIntent? initialPageIntent();

  handleQuickAction({bool onTile = false, int index = 0});

  var _domainConfig;

  DomainConfig? get domainConfig => _domainConfig;

  set domainConfig(DomainConfig? domainConfig);

  Future<void> performInitialSetup();

  Map<EnumPageIntent, PageServiceContract> pageServices = {};

  Map<EnumPageIntent, List<String>> mlPageIntents = {};
}
