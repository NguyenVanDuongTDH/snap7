import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:snap7/snap7.dart';
import 'package:snap7/src/s7_server.dart';
import 'package:snap7/src/snap7_gen.dart';

import 'db.dart';

Future<void> main() async {
  S7Client client = S7Client();
  bool c = client.ConnectTo("127.0.0.1", 0, 1, port: 5505);
  print(client.DBRead(1, 0, 10));
  client.Disconnect();

  // S7Server s7server = S7Server();
  // int size = 100;
  // Pointer<Uint8> data = calloc.allocate(size);
  // s7server.registerArea(5, 1, data, size);
  // s7server.startTo("0.0.0.0" ,port: 5505);
  // while (true) {
  //   final e = s7server.getEvent();
  //   if (e != null) {
  //     print(e);
  //   }
  //   await Future.delayed(Duration(milliseconds: 50));
  // }
}
