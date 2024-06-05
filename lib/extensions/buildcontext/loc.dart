import 'package:flutter/widgets.dart' show BuildContext;
import 'package:flutter_gen/gen_l10n/app_localizations.dart'
    show AppLocalizations;
import 'package:two_a/components/mediaquery.dart';

extension Localization on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
  ({double hsf, double hmf, double wsf, double height, double width})
      get scaleFactor => MQuery(context: this).scaleFactor;
}
