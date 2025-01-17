import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';

import 'package:sentry_broadcast/sentry_broadcast.dart';

void main() {
  test('adds one to input values', () async {
    final cli = BroadcastClient("ws://192.168.1.227:5170/chat");
    cli.stream.listen((message) {
      log(message);
    }, onError: (error) {
      log(error);
    }, onDone: () {
      log('done');
    });
    await cli.connect();

    cli.send('${DateTime.now()}: message from flutter app');
    // expect(calculator.addOne(0), 1);
  });
}
