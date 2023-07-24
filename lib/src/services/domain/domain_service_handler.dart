
import 'package:super_app_framework/super_app_framework.dart';

import '../../helpers/data_collector.dart';
import 'domain_service_contract.dart';

class DomainServiceHandler {
  NavigationDomains domain;

  DomainServiceHandler(this.domain);

  DomainServiceContract? getDomainService() {
    return DataCollector.instance.domainContracts[domain];
  }
}
