import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:snap7/snap7.dart';
import 'package:snap7/src/s7_server.dart';

Future<void> main() async {
    S7Server s7server = S7Server();
  int size = 100;
  Pointer<Uint8> data = calloc.allocate(size);
  s7server.registerArea(5, 1, data, size);
  s7server.startTo("192.168.1.6" ,port: 1402);
  while (true) {
    final e = s7server.getEvent();
    if (e != null) {
      print(e);
    }
    await Future.delayed(Duration(milliseconds: 50));
  }
}
