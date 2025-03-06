import 'package:flutter/services.dart';
import 'package:gimelstudio/ui/common/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDialogModel extends BaseViewModel {
  bool infoCopied = false;

  String getApplicationVersion() {
    // TODO
    return '0.7.0-alpha';
  }

  String getBuildDate() {
    if (envBuildDateTime == '') {
      return '(unknown)';
    }
    DateTime datetime = DateTime.parse(envBuildDateTime);
    return datetime.toIso8601String().split('T')[0];
  }

  Future<void> copyInfoToClipBoard() async {
    String applicationInfo =
        'Gimel Studio v${getApplicationVersion()} for $envPlatform built on ${getBuildDate()} from branch $envBuildBranch, commit $envBuildCommit.';
    await Clipboard.setData(ClipboardData(text: applicationInfo));

    infoCopied = true;
    rebuildUi();
  }

  Future<void> onContribute() async {
    await launchUrl(Uri.https('github.com', '/GimelStudio/GimelStudio'));
  }

  Future<void> onVisitWebsite() async {
    await launchUrl(Uri.https('gimelstudio.com'));
  }

  Future<void> onJoinCommunityChat() async {
    await launchUrl(Uri.https('gimelstudio.zulipchat.com', '/join/sif32f3gjpnikveonzgc7zhw/'));
  }

  Future<void> onCredits() async {
    await launchUrl(Uri.https('github.com', '/GimelStudio/GimelStudio/blob/master/CONTRIBUTORS.md'));
  }

  Future<void> onLicenses() async {
    await launchUrl(Uri.https('github.com', '/GimelStudio/GimelStudio/blob/master/LICENSE'));
  }
}
