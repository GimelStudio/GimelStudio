import 'package:gimelstudio/services/image_service.dart';

import '../../../app/app.locator.dart';
import 'package:stacked/stacked.dart';

class ViewportPanelModel extends ReactiveViewModel {
  final _imageService = locator<ImageService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_imageService];
}
