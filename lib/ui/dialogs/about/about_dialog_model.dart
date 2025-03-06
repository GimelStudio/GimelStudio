import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDialogModel extends BaseViewModel {
  String platform = String.fromEnvironment('PLATFORM', defaultValue: '');
  String buildDateTime = String.fromEnvironment('BUILD_DATETIME', defaultValue: '');
  String buildBranch = String.fromEnvironment('BUILD_BRANCH', defaultValue: '(unknown)');
  String buildCommit = String.fromEnvironment('BUILD_COMMIT', defaultValue: '(unknown)');

  bool infoCopied = false;

  String getApplicationVersion() {
    // TODO
    return '0.7.0-alpha';
  }

  String getBuildDate() {
    if (buildDateTime == '') {
      return '(unknown)';
    }
    DateTime datetime = DateTime.parse(buildDateTime);
    return datetime.toIso8601String().split('T')[0];
  }

  Future<void> copyInfoToClipBoard() async {
    String applicationInfo =
        'Gimel Studio v${getApplicationVersion()} for $platform built on ${getBuildDate()} from branch $buildBranch, commit $buildCommit.';
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
