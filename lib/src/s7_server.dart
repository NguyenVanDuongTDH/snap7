// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:snap7/src/snap7_gen.dart';

class S7Server {
  static const int LocalPort = 1;
  static const int RemotePort = 2;
  static const int PingTimeout = 3;
  static const int SendTimeout = 4;
  static const int RecvTimeout = 5;
  static const int WorkInterval = 6;
  static const int SrcRef = 7;
  static const int DstRef = 8;
  static const int SrcTSap = 9;
  static const int PDURequest = 10;
  static const int MaxClients = 11;
  static const int BSendTimeout = 12;
  static const int BRecvTimeout = 13;
  static const int RecoveryTime = 14;
  static const int KeepAliveTime = 15;

  int Server = 0;
  S7Server() {
    Server = cSnap7.Srv_Create();
  }

  void set(int areaCode, int index, Pointer<Uint8> db, int size) {
    cSnap7.Srv_RegisterArea(Server, areaCode, index, db.cast(), size);
  }

  void start({int port = 102}) {
    if (port != 102) {
      SetParam(LocalPort, port);
    }

    cSnap7.Srv_Start(Server);
  }

  void SetParam(int ParamNumber, int value) {
    Pointer<Int> pValue = calloc.allocate(1);
    pValue.value = value;
    cSnap7.Srv_SetParam(Server, ParamNumber, pValue.cast());
  }

  Pointer<TSrvEvent>? pickEvent() {
    Pointer<TSrvEvent> event = calloc.allocate<TSrvEvent>(1);
    Pointer<Int> ready = calloc.allocate<Int>(1);
    final code = cSnap7.Srv_PickEvent(Server, event, ready);
    // check_error(code);
    if (ready.value > 0) {
      return event;
    } else {
      return null;
    }
  }

  static String event_text(Pointer<TSrvEvent> event) {
    Pointer<Uint8> text = calloc.allocate(1024);
    final error = cSnap7.Srv_EventText(event, text.cast(), 1024);
    // check_error(error);
    Uint8List res = text.asTypedList(1024);
    String decodedString =
        String.fromCharCodes(res).toString();
    calloc.free(text);
    return decodedString;
  }

  static void check_error(int code, {String context = "client"}) {
    if (code != 0 && code != 1) {
      String error = error_text(code);
      throw error;
    }
  }

  static String error_text(int code, {String context = "client"}) {
    Pointer<Char> Text = calloc.allocate(1024);
    if (context == "client") {
      cSnap7.Cli_ErrorText(code, Text, 1024);
    } else if (context == "server") {
      cSnap7.Srv_ErrorText(code, Text, 1024);
    } else if (context == "partner") {
      cSnap7.Par_ErrorText(code, Text, 1024);
    } else {
      throw "Unkown context $context used, should be either client, server or partner";
    }
    String text = Text.cast<Utf8>().toDartString();
    calloc.free(Text);
    return text;
  }

  void stop() {
    cSnap7.Srv_Stop(Server);
  }

  void destroy() {
    Pointer pointer = Pointer.fromAddress(Server);
    cSnap7.Srv_Destroy(pointer.cast());
  }
}
