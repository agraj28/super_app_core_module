import 'dart:async';
import 'package:super_app_core_module/src/core.dart';
import 'package:super_app_framework/super_app_framework.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'helper/navigator_helper.dart' as navigator_helper;
import '../../ui_modules/app.dart';
import '../../util/status_bar_util.dart';
import '../page/page_service_contract.dart';
import '../page/page_service_handler.dart';


class NavigatorService {
  // Navigation stack to get the current displayed page
  List<EnumPageIntent?>? navigationStack;
  NavigationDomains? navigationDomain;
  PageServiceContract? pageServiceContract;
  late navigator_helper.NavigatorModel navigatorModel;

  EnumPageIntent? currentPageIntent;

  EnumPageIntent? previousPageIntent;

  Duration kNavServiceDelay = Duration(milliseconds: 50);

  // Stream to update navigator
  Stream<navigator_helper.NavigatorData> get navigatorData =>
      _navigatorData.stream;
  final _navigatorData = BehaviorSubject<navigator_helper.NavigatorData>();
  // Stream for the current page intent
  ValueStream<EnumPageIntent?> get currentPageIntentStream =>
      setCurrentIntent.stream;
  BehaviorSubject<EnumPageIntent?> setCurrentIntent =
      BehaviorSubject<EnumPageIntent?>();



  static final NavigatorService _singleton = NavigatorService._internal();

  factory NavigatorService() {
    return _singleton;
  }

  NavigatorService._internal() {
    navigationStack = <EnumPageIntent?>[];
    currentPageIntent = EnumPageIntent.Home;

    currentPageIntentStream.listen((enumPageIntent) {
      currentPageIntent = enumPageIntent;
    });
  }

  // Get's the context of the key
  BuildContext? get currentContext => _getNavigatorKey()!.currentContext;

  ///
  /// Method to perform Push operation
  ///
  void push(EnumPageIntent? pageIntent, dynamic pageModel,
      {PageTransitionType? pageTransitionType = null,
      bool withTransition = true,
      Duration transitionDuration = const Duration(milliseconds: 500),
      bool isUIAction = true,
      bool? refreshNavigator = false,
      void Function(dynamic value)? thenValue,
      bool isReplace = false}) async {


    // Get the navigator key
    var navigatorKey = _getNavigatorKey();

    transitionDuration = Duration(milliseconds: 300);
    var isHomeRoute = true;

    bool isValidReplaceForHome = true;

    // Update the current page
    currentPageIntent = getCurrentPage();

    // Return, if current and new page-intent is same
    if (pageIntent == EnumPageIntent.Home &&
        currentPageIntent == pageIntent) {
      return;
    }

    // Save current intent before update
    previousPageIntent = currentPageIntent;
    currentPageIntent = pageIntent;

    // Notify the current intent
    setCurrentIntent.add(currentPageIntent);
    await Future.delayed(kNavServiceDelay);

    // Get the current navigation domain
    var currentNavigationDomain = getDomainName(currentPageIntent!);

    // For Replace we need a valid stack of Home page, if we don't have then pop to the Home screen and return
    if (isReplace) {
      isValidReplaceForHome = navigationStack!
          .any((element) => element == EnumPageIntent.Home);
    }

    // Check for the flag and refresh the navigator, if SET
    if (!refreshNavigator! && isValidReplaceForHome) {
      // Get the Widget to display
      var pageToDisplay = getWidgetToDisplay(pageModel);
      // Check for the domain change
      // If yes, then pop to the first screen
      if (navigationDomain != currentNavigationDomain) {

        navigationDomain =
            currentNavigationDomain; // Update the navigation domain

        // Perform pop
        navigatorKey?.currentState?.popUntil((route) {
          if (!route.isFirst) {
            // Update the stack, by removing all but not the first element
            if (navigationStack != null && navigationStack!.length > 0) {
              navigationStack?.removeLast();
            }
          } else {
            // Check for the first route and raise the flag if it's not the Home
            // Note: This is to handle progressive intent where all the stack is destroyed
            if (route.settings.name != 'EnumPageIntent.Home') {
              isHomeRoute = false;
            }
          }

          return route.isFirst;
        });

        await Future.delayed(kNavServiceDelay);
        if (!isHomeRoute) {
          // Drop the last route as we have to start with the Home again
          pop(isExternalPop: false);
        } else {
          // Stop, in case if it's navigating to the Home screen
          if (currentNavigationDomain == NavigationDomains.Home) {
            checkAndChangeTheme(currentPageIntent, isFromPush: true);

            return;
          }
        }
      }

      ///
      /// Prepare for the push
      ///

      // Update the stack
      navigationStack!.add(currentPageIntent);
      await Future.delayed(kNavServiceDelay);


      performOperation(
          (isReplace)
              ? EnumTransitionType.PushAndRemoveUntil
              : EnumTransitionType.Push,
          navigatorKey,
          pageToDisplay,
          pageTransitionType: pageTransitionType,
          transitionDuration: transitionDuration,
          thenValue: thenValue);

      if (!isReplace) {
        checkAndChangeTheme(currentPageIntent, isFromPush: true);
      }
    } else {
      // Reset and add the page to the navigation stack
      navigationStack = <EnumPageIntent?>[];
      navigationStack!.add(currentPageIntent);

      // Notify bloc to refresh the parent Navigator
      _navigatorData.add(navigator_helper.NavigatorData(
          intent: currentPageIntent, pageModel: pageModel));
    }
  }

  ///
  /// Method to perform Push replacement operation
  ///
  void pushReplacement(EnumPageIntent pageIntent, dynamic pageModel,
      {PageTransitionType? pageTransitionType = null,
      Duration transitionDuration = const Duration(milliseconds: 50),
      void Function(dynamic value)? thenValue}) async {


    // Get the navigator key
    var navigatorKey = _getNavigatorKey();
    transitionDuration = Duration(milliseconds: 300);
    // Return, if current and new page-intent is same
    if (pageIntent == EnumPageIntent.Home &&
        currentPageIntent == pageIntent) {
      return;
    }
    // Save current intent as previous before update
    previousPageIntent = currentPageIntent;
    currentPageIntent = pageIntent;
    print('pageIntent : $pageIntent'); // Update the page intent

    // Get the current navigation domain
    NavigationDomains? currentNavigationDomain = getDomainName(pageIntent);

    setCurrentIntent.add(pageIntent);
    await Future.delayed(kNavServiceDelay);

    // For Common navigation domain, stick to the domain we have been to
    if (currentNavigationDomain == NavigationDomains.Common) {
      currentNavigationDomain = navigationDomain;
    }

    // Check for the domain change, if not then push the page
    // else refresh the Navigator with the updated navigation properties
    if (navigationDomain == currentNavigationDomain) {
      // Update the stack

      if (navigationStack != null && navigationStack!.length > 0) {
        navigationStack?.removeLast();
        //handled range error if navigation stack is empty
      }
      navigationStack?.add(pageIntent);

      // Get the Widget to display
      var pageToDisplay = getWidgetToDisplay(pageModel);

      // TODO: Add page transition support
      // Make a push and replace operation

      performOperation(
          EnumTransitionType.PushAndReplace, navigatorKey, pageToDisplay,
          pageTransitionType: pageTransitionType,
          transitionDuration: transitionDuration,
          thenValue: thenValue);
      checkAndChangeTheme(currentPageIntent, isFromPush: true);
    }
  }

  ///
  /// Method to check whether Pop operation can be performed or not
  ///
  bool canPop() {
    // Get the navigator key
    var navigatorKey = _getNavigatorKey()!;

    return (navigatorKey.currentState != null &&
        navigatorKey.currentState!.canPop());
  }

  /// TODO: Add support to perform route until
  ///
  /// Pop's until the required page
  ///
  void popUntilFirstRoute() async {
    var navigatorKey = _getNavigatorKey()!;
    navigatorKey.currentState!.popUntil((route) {
      if (!route.isFirst) {
        // Update the stack, by removing all but not the first element
        navigationStack?.removeLast();
      }
      return route.isFirst;
    });

    // Update Local ML service with current intent
    setCurrentIntent.add(getCurrentPage());
    await Future.delayed(kNavServiceDelay);

    checkAndChangeTheme(getCurrentPage(),
        duration: Duration(milliseconds: 150));
  }

  ///
  /// Pop's to a particular route
  ///
  void popTo(
      EnumPageIntent pageIntent, BuildContext? context, dynamic data) async {
    var navigatorKey = _getNavigatorKey()!;
    navigatorKey.currentState!.popUntil((route) {
      var routeName = route.settings.name;
      if (routeName == pageIntent.toString()) {
        if (route.settings.arguments != null) {
          (route.settings.arguments as Map)['result'] = data;
        }
        return true;
      }

      // Remove stack item
      if ((navigationStack != null && navigationStack!.length > 0) && (routeName != null && routeName!.length > 0)) {
        navigationStack!.removeLast();
      }

      return false;
    });

    setCurrentIntent.add(getCurrentPage());

    await Future.delayed(kNavServiceDelay);
    checkAndChangeTheme(getCurrentPage(),
        duration: Duration(milliseconds: 150));
  }

  ///
  /// Method to perform Pop operation
  ///
  void pop({bool isExternalPop = true, dynamic result}) async {
    // Get the navigator key
    var navigatorKey = _getNavigatorKey();
    // Remove stack item
    if (navigationStack != null && navigationStack!.length > 0){
      navigationStack!.removeLast();
      setCurrentIntent.add(getCurrentPage());
      await Future.delayed(kNavServiceDelay);
    }

    if (isExternalPop) {
      if (NavigatorService().canPop()) {
        // Perform the pop operation
        navigatorKey!.currentState!.pop(result);
      } else {
        App.navKey.currentState!.maybePop();
      }
    } else {
      navigatorKey!.currentState!.pop();
    }
    checkAndChangeTheme(getCurrentPage(),
        duration: Duration(milliseconds: 150));
  }

  ///
  /// Creates the route
  ///
  Route _createRoute(
      Widget pageToDisplay,
      PageTransitionType pageTransitionType,
      RouteSettings settings,
      Duration transitionDuration) {
    return PageTransition(
      type: pageTransitionType,
      child: pageToDisplay,
      settings: settings,
      duration: transitionDuration,
    );
  }

  void setCurrentPageIntent(EnumPageIntent? pageIntent) async {
    currentPageIntent = pageIntent;

    // Notify the current intent
    setCurrentIntent.add(currentPageIntent);
    await Future.delayed(kNavServiceDelay);
  }

  ///
  ///Method for auto checking theme while routing
  ///
  Future<void> checkAndChangeTheme(EnumPageIntent? intentToNavigate,
      {Duration duration = const Duration(milliseconds: 0),
      bool isFromPush = false}) async {
    //Get domain of intent
    var currentNavigationDomainForTheme = getDomainName(intentToNavigate!);
    var previousDomain = getDomainName(previousPageIntent!);

    //Get current theme type
    var currentThemeType = await themeBloc.getThemeType();


    var moduleType =
        navigator_helper.themeForDomain[currentNavigationDomainForTheme];


    if (isFromPush &&
        intentToNavigate == EnumPageIntent.Home) {
      // Requires 500 milis delays when going to Home from dark theme domains
      duration = const Duration(milliseconds: 500);
    }
    //Delay: this will prevent sudden theme change while page in still under transition
    await Future.delayed(duration);
    //Actual theme change check
    themeBloc.onDecideThemeChange(
      themeType:currentThemeType,
      moduleType: moduleType,
    );

    //Changing status bar manually as per theme type


      StatusBarUtil.instance.darkThemeStatusBar();

  }

  ///
  /// Get's the widget to display
  ///
  Widget getWidgetToDisplay(dynamic pageModel,
      {EnumPageIntent pageIntent = EnumPageIntent.App}) {
    ///
    /// Get the page properties
    ///
    // Get the page service and navigation domain
    pageServiceContract = PageServiceHandler(
            (pageIntent != EnumPageIntent.App)
                ? pageIntent
                : currentPageIntent)
        .getPageService();

    // Get the navigator model
    navigatorModel =
        pageServiceContract!.getNavigationProperties(model: pageModel);

    // Get the required navigator route
    var navigatorRoute = pageServiceContract!.getNavigatorRoute();

    // Get the page to display
    return navigatorModel.routeBuilders![navigatorRoute!]!(null);
  }

  ///
  /// Performs the transition operation
  ///
  void performOperation(EnumTransitionType transitionType,
      GlobalKey<NavigatorState>? navigatorKey, Widget pageToDisplay,
      {PageTransitionType? pageTransitionType = null,
      Duration transitionDuration = const Duration(milliseconds: 500),
      void Function(dynamic value)? thenValue}) {
    // Get the route settings
    var routeSettings = RouteSettings(name: currentPageIntent.toString());
    if (transitionType == EnumTransitionType.Push) {
      navigatorKey!.currentState!
          .push(
        (pageTransitionType != null)
            ? _createRoute(pageToDisplay, pageTransitionType, routeSettings,
                transitionDuration)
            : ForkedPageTransition(
                type: ForkedPageTransitionType.none,
                child: pageToDisplay,
                settings: routeSettings,
                duration: transitionDuration,
              ),
      )
          .then((value) {
        var arguments = routeSettings.arguments as Map?;
        if (arguments != null) {
          thenValue!(arguments['result']);
        } else {
          if (value != null) {
            thenValue!(value);
          }
          return;
        }
      });
    } else if (transitionType == EnumTransitionType.PushAndRemoveUntil) {
      navigatorKey!.currentState!
          .pushAndRemoveUntil(
              (pageTransitionType != null)
                  ? _createRoute(pageToDisplay, pageTransitionType,
                      routeSettings, transitionDuration)
                  : ForkedPageTransition(
                      type: ForkedPageTransitionType.none,
                      child: pageToDisplay,
                      settings: routeSettings,
                      duration: transitionDuration,
                    ),
              (route) => false)
          .then((value) {
        var arguments = routeSettings.arguments as Map?;
        if (arguments != null) {
          thenValue!(arguments['result']);
        } else {
          if (value != null) {
            thenValue!(value);
          }
          return;
        }
      });
    } else if (transitionType == EnumTransitionType.PushAndReplace) {
      navigatorKey!.currentState!
          .pushReplacement((pageTransitionType != null)
              ? _createRoute(pageToDisplay, pageTransitionType, routeSettings,
                  transitionDuration)
              : ForkedPageTransition(
                  type: ForkedPageTransitionType.none,
                  child: pageToDisplay,
                  settings: routeSettings,
                  duration: transitionDuration,
                ))
          .then((value) {
        var arguments = routeSettings.arguments as Map?;
        if (arguments != null) {
          thenValue!(arguments['result']);
        } else {
          if (value != null) {
            thenValue!(value);
          }
          return;
        }
      });
    }
  }

  ///
  /// Method to get the current page
  ///
  EnumPageIntent? getCurrentPage() {
    return (navigationStack != null && navigationStack!.isNotEmpty)
        ? navigationStack!.last
        : navigator_helper.getDomainRootPage(currentPageIntent);
  }

  ///
  ///  Pattern                        Result
  //  ----------------------          -------
  //  NavigationDomains.Home     ->   home
  ///
  String getCurrentDomainName() {
    var navigationDomain = getDomainName(currentPageIntent!);

    return navigationDomain
        .toString()
        .replaceAll('${navigationDomain.runtimeType.toString()}.', '')
        .toLowerCase();
  }

  ///
  /// Method to get the current page service
  ///
  PageServiceContract? getCurrentPageService(EnumPageIntent? pageIntent) {
    return pageServiceContract =
        PageServiceHandler(pageIntent).getPageService();
  }

  ///
  /// Update the navigation domain
  ///
  /// Note: This is called by the navigator widget
  void updateNavigationDomain(EnumPageIntent pageIntent) {
    navigationDomain = getDomainName(pageIntent);
  }

  ///
  /// Update the navigation stack
  ///
  /// Note: This is done by the navigator widget for the very initial page
  void updateNavigationStack(EnumPageIntent? pageIntent) async {
    navigationStack = <EnumPageIntent?>[];
    navigationStack!.add(pageIntent);
    await Future.delayed(kNavServiceDelay);
  }

  ///
  /// Gets the Navigator key
  ///
  GlobalKey<NavigatorState>? _getNavigatorKey() {
    return navigator_helper.navigatorKeys[NavigationDomains.Common];
  }
}

class ForkedPageTransition<T> extends PageRouteBuilder<T> {
  /// Child for your next page
  final Widget child;

  /// Transition types
  final ForkedPageTransitionType type;

  /// Curves for transitions
  final Curve curve;

  /// Aligment for transitions
  final Alignment? alignment;

  /// Durationf for your transition default is 300 ms
  final Duration duration;

  /// Context for inheret theme
  final BuildContext? ctx;

  /// Optional inheret teheme
  final bool inheritTheme;

  /// Page transition constructor. We can pass the next page as a child,
  ForkedPageTransition({
    Key? key,
    required this.child,
    required this.type,
    this.ctx,
    this.inheritTheme = false,
    this.curve = Curves.linear,
    this.alignment,
    this.duration = const Duration(milliseconds: 300),
    RouteSettings? settings,
  })  : assert(inheritTheme ? ctx != null : true,
            "'ctx' cannot be null when 'inheritTheme' is true, set ctx: context"),
        super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return inheritTheme
                ? InheritedTheme.captureAll(
                    ctx!,
                    child,
                  )
                : child;
          },
          transitionDuration: type == ForkedPageTransitionType.none
              ? const Duration(seconds: 0)
              : duration,
          reverseTransitionDuration: type == ForkedPageTransitionType.none
              ? const Duration(seconds: 0)
              : duration,
          settings: settings,
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            switch (type) {

              /// PageTransitionType.none

              case ForkedPageTransitionType.none:
                return child;

              /// FadeTransitions which is the fade transition

              default:
                return FadeTransition(opacity: animation, child: child);
            }
          },
        );
}

/// Transition enum
enum ForkedPageTransitionType {
  /// No Animation
  none,
}

enum EnumTransitionType { Push, PushAndRemoveUntil, PushAndReplace }
