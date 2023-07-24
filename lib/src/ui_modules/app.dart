import 'package:flutter/material.dart';
import '../core.dart';




class App extends StatelessWidget {
  static final navKey = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

      ],
      child: BlocBuilder<ThemeBloc, ChangeThemeState>(
        builder: (_, state) {
          return Container(
            color: Colors.blue,
          );
        },
      ),
    );
  }
}