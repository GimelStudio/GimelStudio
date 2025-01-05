import 'package:flutter/material.dart';
import 'package:gimelstudio/services/document_service.dart';
import 'package:stacked/stacked.dart';
import 'package:gimelstudio/app/app.locator.dart';
import 'package:gimelstudio/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _documentsService = locator<DocumentService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    // This is where you can make decisions on where your app should navigate when
    // you have custom startup logic

    // TODO: these documents are created here for testing.
    // In the real application the documents will be created or
    // opened by the user.
    _documentsService.createNewDocument('Untitled', Size(1920, 1080));
    _documentsService.createNewDocument('Nature project', Size(2048, 2048));

    _navigationService.replaceWithMainView();
  }
}
