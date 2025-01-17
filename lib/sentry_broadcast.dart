import 'dart:async' show StreamSubscription, StreamController;
import 'dart:convert' show jsonEncode;
import 'dart:io' show WebSocket;

class BroadcastClient {
  final String url;
  WebSocket? _socket;
  StreamSubscription? _sub;

  final StreamController<String> _msgCtrl = StreamController<String>.broadcast();

  BroadcastClient(this.url);

  Stream<String> get stream => _msgCtrl.stream;

  Future<void> connect() async {
    try {
      _socket = await WebSocket.connect(url);
      _sub = _socket!.listen((message) {
        _msgCtrl.add(message);
      }, onError: (error) {
        _msgCtrl.addError(error);
      }, onDone: () {
        _msgCtrl.close();
      });
    } catch (e) {
      _msgCtrl.addError("Failed to connect WebSocket: $e");
    }
  }

  void report(String message) {
    _socket?.add(jsonEncode({'data': message, 'typ': 'text'}));
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    await _socket?.close();
    await _msgCtrl.close();
    _socket = null;
  }
}
