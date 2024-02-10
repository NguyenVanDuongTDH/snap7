import 'package:snap7/snap7.dart';

import 'db.dart';

Future<void> main() async {
  S7Client client = S7Client();
  client.ConnectTo("192.168.0.199", 0, 1);
  final DB1 = PLC_DB(client);
  DB1.read();
  print(DB1.Static_1);
  client.Disconnect();

  // S7Server s7server = S7Server();
  // int size = 100;
  // Pointer<Uint8> data = calloc.allocate(size);
  // s7server.registerArea(5, 1, data, size);
  // s7server.start(port: 1402);
  // while (true) {
  //   final e = s7server.getEvent();
  //   if (e != null) {
  //     print(e);
  //   }
  //   await Future.delayed(Duration(milliseconds: 50));
  // }
}
