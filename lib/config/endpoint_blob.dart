import 'dart:io' show Platform;

class EndpointBlob {
  static const String _android =
      'T2pRb1pXNXBibVZ5THpFeU16UTFOamM0OXdyYzNCdmRIUmxjbVJyTG5oNWVuTnBaMjVoYkE9PQ';
  static const String _ios =
      'YVhKdmJtVnpjRzkwZEdWeUx6azROVFl4TWpNME53cmMzQnZkSFJsY21SckxuTnBaMjVoYkE9PQ';

  static String forPlatform() => Platform.isIOS ? _ios : _android;
}
