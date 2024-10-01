import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketService {
  static WebSocketChannel? _channel;

  static void connect(String url, Function(dynamic) onMessage) {
    try {
      _channel = IOWebSocketChannel.connect(url);
      _channel!.stream.listen(
        onMessage,
        onError: (error) => print('WebSocket错误: $error'),
        onDone: () => print('WebSocket连接关闭'),
      );
    } catch (e) {
      print('WebSocket连接失败: $e');
    }
  }

  static void send(String message) {
    if (_channel != null) {
      _channel!.sink.add(message);
    } else {
      print('WebSocket未连接');
    }
  }

  static void close() {
    _channel?.sink.close();
  }
}