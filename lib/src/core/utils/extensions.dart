import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yandex_todo_app/src/core/utils/utils.dart';

import '../constants/colors/colors.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get _theme => Theme.of(this);

  TextTheme get textTheme => _theme.textTheme;

  ColorScheme get colorScheme => _theme.colorScheme;

  AppLocalizations get localizations => S.of(this);

  CustomColors get customColors {
    final customColors = _theme.extension<CustomColors>();
    assert(customColors != null, 'CustomColors not found in ThemeData');
    return customColors!;
  }
}
