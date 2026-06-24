import 'dart:io' show Platform;

class EndpointBlob {
  static const String _android =
      'xxqcg8OJxRS2sCKTE1FwrrjeOfxTmmmUZL9MxEiwScsRyH/FAiULKSHTLFKT/u5VIQ5uY60KTL4boJq/';
  static const String _ios =
      'J+rY1qa9w2pB2fRQRbekGd43wWC1e/4Hp5Gzp4bMV34KlL+pmJgUDiFiPJFwMzWN6dPbXQGFc+49SHk9';

  static String forPlatform() => Platform.isIOS ? _ios : _android;
}
