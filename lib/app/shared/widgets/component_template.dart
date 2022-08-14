import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../localizations/locale_keys.g.dart';

enum ComponentState { FETCHING_DATA, ERROR, SHOW_DATA, NO_DATA }

class ComponentTemplate extends StatelessWidget {
  final ComponentState state;
  final Widget screen;
  final VoidCallback? onRetry;

  ComponentTemplate({required this.state, required this.screen, this.onRetry});

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case ComponentState.SHOW_DATA:
        return screen;
      case ComponentState.FETCHING_DATA:
        return Container(
            height: 150, child: Center(child: CircularProgressIndicator()));
      case ComponentState.NO_DATA:
        return Center(child: Text(LocaleKeys.emptyData.tr()));
      case ComponentState.ERROR:
        return Container(alignment: Alignment.center,
            height: 250,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(LocaleKeys.unKnownError.tr()),
              SizedBox(height: 20),
              if (onRetry != null)
                OutlinedButton.icon(
                    onPressed: onRetry,
                    icon: Icon(Icons.refresh),
                    label: Text(LocaleKeys.retry.tr()))
            ]));
      default:
        return Container();
    }
  }
}
