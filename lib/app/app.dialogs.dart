// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedDialogGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/dialogs/about/about_dialog.dart';
import '../ui/dialogs/info_alert/info_alert_dialog.dart';
import '../ui/dialogs/new_document/new_document_dialog.dart';
import '../ui/dialogs/preferences/preferences_dialog.dart';

enum DialogType {
  infoAlert,
  newDocument,
  preferences,
  about,
}

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final Map<DialogType, DialogBuilder> builders = {
    DialogType.infoAlert: (context, request, completer) => InfoAlertDialog(request: request, completer: completer),
    DialogType.newDocument: (context, request, completer) => NewDocumentDialog(request: request, completer: completer),
    DialogType.preferences: (context, request, completer) => PreferencesDialog(request: request, completer: completer),
    DialogType.about: (context, request, completer) => AboutDialog(request: request, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
