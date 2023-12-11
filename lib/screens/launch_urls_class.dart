import 'package:url_launcher/url_launcher.dart';

class UrlLauncherClass{

  Future<void> doLaunchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw Exception('Could not launch $_url');
    }
  }
}