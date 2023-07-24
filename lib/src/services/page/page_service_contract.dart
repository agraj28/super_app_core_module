import 'package:super_app_framework/super_app_framework.dart';

import '../system_navigator/helper/navigator_helper.dart';



abstract class PageServiceContract<PageModel> {
  bool isVoiceSupported();

  NavigatorModel getNavigationProperties({PageModel? model});

  String? getNavigatorRoute();

  PageModel getPageModel(
    PageModel model, {
    PageModelType pageModelType = PageModelType.UIModel,
  });

  String? getForeGroundIntentView();

  List<String>? getHints(Map<String, dynamic>? trigger);

  dynamic getBlocModel({
    bool forceCreateNewInstance = false,
    bool getASRBloc = false,
  });

  bool isProgressiveIntentSupported();

  bool isAppOnBoardingSupported();



  String? getIntent();

  PageServiceContract getNewPageServiceInstance(EnumPageIntent? pageIntent);

  String? getPrefilledTextForGlobalSearch();

  String? getForegroundIntentForHints();
}

enum PageModelType { UIModel, AnnotationModel }
