import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:snap7/src/s7_server.dart';

Future<void> main() async {
  S7Server s7server = S7Server();
  int size = 100;
  Pointer<Uint8> data = calloc.allocate(size);
  s7server.set(5, 1, data, size);
  s7server.start(port: 1602);
  while (true) {
    while (true) {
      final event = s7server.pickEvent();
      if (event != null) {
        print(S7Server.event_text(event));
      }
      await Future.delayed(Duration(milliseconds: 50));
    }
  }
}
