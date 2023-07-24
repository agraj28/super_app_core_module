import 'package:super_app_framework/super_app_framework.dart';
import '../system_navigator/helper/navigator_helper.dart'
    as navigator_helper;
import 'page_service_contract.dart';
import '../../helpers/data_collector.dart';

class PageServiceHandler {
  EnumPageIntent? pageIntent;
  late NavigationDomains _navigationDomains;

  PageServiceHandler(this.pageIntent) {
    _navigationDomains = navigator_helper
        .getDomainName(pageIntent); // Update the navigation domain
  }

  PageServiceContract? getPageService() {
    var pageServiceContract =
        DataCollector.instance.domainContracts[_navigationDomains];
    return pageServiceContract?.getPageServiceContract(pageIntent: pageIntent);
  }
}
