import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  static Map<String, WebSocketChannel> _channels = {};

  static void connect(String url, Function(dynamic) onMessage) {
    try {
      _channels[url] = IOWebSocketChannel.connect(url);
      _channels[url]!.stream.listen(
        onMessage,
        onError: (error) => print('WebSocket错误: $error'),
        onDone: () => print('WebSocket连接关闭'),
      );
    } catch (e) {
      print('WebSocket连接失败: $e');
    }
  }

  static void send(String url, String message) {
    if (_channels.containsKey(url)) {
      _channels[url]!.sink.add(message);
    } else {
      print('WebSocket未连接');
    }
  }

  static void close([String? url]) {
    if (url != null) {
      _channels[url]?.sink.close();
      _channels.remove(url);
    } else {
      _channels.forEach((_, channel) => channel.sink.close());
      _channels.clear();
    }
  }
}