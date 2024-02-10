// ignore_for_file: non_constant_identifier_names, unused_element

import 'dart:ffi';
import 'dart:typed_data';

import 's7.dart';
import 'snap7_gen.dart';
import 'package:ffi/ffi.dart';

class S7Client {
  int Client = 0;
  S7Client() {
    Client = cSnap7.Cli_Create();
  }
  // Control functions
  bool Connect() {
    return cSnap7.Cli_Connect(Client) == 0;
  }

  int setPort(int port) {
    Pointer<Int> pValue = calloc.allocate(1);
    pValue.value = port;
    return cSnap7.Cli_SetParam(Client, S7Const.RemotePort, pValue.cast());
  }

  bool ConnectTo(String RemAddress, int Rack, int Slot, {int port = 102}) {
      setPort(port);
    final Address = RemAddress.toNativeUtf8();
    int res = cSnap7.Cli_ConnectTo(Client, Address.cast(), Rack, Slot);
    calloc.free(Address);
    return res == 0;
  }

  // int SetConnectionParams(const char *RemAddress, word LocalTSAP, word RemoteTSAP);
  //   int SetConnectionType(word ConnectionType);
  bool Disconnect() {
    return cSnap7.Cli_Disconnect(Client) == 0;
  }

  //   int GetParam(int ParamNumber, void *pValue);
  //   int SetParam(int ParamNumber, void *pValue);
  //   // Data I/O Main functions
  Uint8List? ReadArea(
      int Area, int DBNumber, int Start, int Amount, int WordLen) {
    Pointer<Uint8> pUsrData = calloc.allocate(Amount);
    int res = cSnap7.Cli_ReadArea(
        Client, Area, DBNumber, Start, Amount, WordLen, pUsrData.cast());
    Uint8List bytes = Uint8List.fromList(pUsrData.asTypedList(Amount));
    calloc.free(pUsrData);
    if (res == 0) {
      return bytes;
    } else {
      return null;
    }
  }

  bool WriteArea(int Area, int DBNumber, int Start, int Amount, int WordLen,
      Uint8List Data) {
    var pUsrData = calloc.allocate<Uint8>(Data.length);
    pUsrData.asTypedList(Data.length).setAll(0, Data);
    int res = cSnap7.Cli_WriteArea(
        Client, Area, DBNumber, Start, Amount, WordLen, pUsrData.cast());
    calloc.free(pUsrData);
    return res == 0;
  }

  //   int ReadMultiVars(PS7DataItem Item, int ItemsCount);
  //   int WriteMultiVars(PS7DataItem Item, int ItemsCount);
  //   // Data I/O Lean functions
  Uint8List? DBRead(int DBNumber, int Start, int Size) {
    Pointer<Uint8> pUsrData = calloc.allocate(Size);
    int res = cSnap7.Cli_DBRead(Client, DBNumber, Start, Size, pUsrData.cast());
    Uint8List bytes = Uint8List.fromList(pUsrData.asTypedList(Size));
    calloc.free(pUsrData);
    if (res == 0) {
      return bytes;
    } else {
      return null;
    }
  }

  bool DBWrite(int DBNumber, int Start, Uint8List Data) {
    var pUsrData = calloc.allocate<Uint8>(Data.length);
    pUsrData.asTypedList(Data.length).setAll(0, Data);
    int res = cSnap7.Cli_DBWrite(
        Client, DBNumber, Start, Data.length, pUsrData.cast());
    calloc.free(pUsrData);
    return res == 0;
  }

  // Uint8List? MBRead(int Start, int Size) {
  //   Pointer<Uint8> pUsrData = calloc.allocate(Size);
  //   int res = cSnap7.Cli_MBRead(Client, Start, Size, pUsrData.cast());
  //   Uint8List bytes = Uint8List.fromList(pUsrData.asTypedList(Size));
  //   calloc.free(pUsrData);
  //   if (res == 0) {
  //     return bytes;
  //   } else {
  //     return null;
  //   }
  // }

  // bool MBWrite(int Start, int Size, Uint8List Data) {
  //   final pUsrData = Data.cpp();
  //   int res = cSnap7.Cli_MBWrite(Client, Start, Size, pUsrData.cast());
  //   pUsrData.free();
  //   return res == 0;
  // }
  //   int EBRead(int Start, int Size, void *pUsrData);
  //   int EBWrite(int Start, int Size, void *pUsrData);
  //   int ABRead(int Start, int Size, void *pUsrData);
  //   int ABWrite(int Start, int Size, void *pUsrData);
  //   int TMRead(int Start, int Amount, void *pUsrData);
  //   int TMWrite(int Start, int Amount, void *pUsrData);
  //   int CTRead(int Start, int Amount, void *pUsrData);
  //   int CTWrite(int Start, int Amount, void *pUsrData);
  //   // Directory functions
  //   int ListBlocks(PS7BlocksList pUsrData);
  //   int GetAgBlockInfo(int BlockType, int BlockNum, PS7BlockInfo pUsrData);
  //   int GetPgBlockInfo(void *pBlock, PS7BlockInfo pUsrData, int Size);
  //   int ListBlocksOfType(int BlockType, TS7BlocksOfType *pUsrData, int *ItemsCount);
  //   // Blocks functions
  //   int Upload(int BlockType, int BlockNum, void *pUsrData, int *Size);
  //   int FullUpload(int BlockType, int BlockNum, void *pUsrData, int *Size);
  //   int Download(int BlockNum, void *pUsrData, int Size);
  //   int Delete(int BlockType, int BlockNum);
  //   int DBGet(int DBNumber, void *pUsrData, int *Size);
  //   int DBFill(int DBNumber, int FillChar);
  //   // Date/Time functions
  //   int GetPlcDateTime(tm *DateTime);
  //   int SetPlcDateTime(tm *DateTime);
  //   int SetPlcSystemDateTime();
  //   // System Info functions
  //   int GetOrderCode(PS7OrderCode pUsrData);
  //   int GetCpuInfo(PS7CpuInfo pUsrData);
  //   int GetCpInfo(PS7CpInfo pUsrData);
  // int ReadSZL(int ID, int Index, PS7SZL pUsrData, int *Size);
  // int ReadSZLList(PS7SZLList pUsrData, int *ItemsCount);
  // // Control functions
  // int PlcHotStart();
  // int PlcColdStart();
  // int PlcStop();
  // int CopyRamToRom(int Timeout);
  // int Compress(int Timeout);
  // // Security functions
  // int GetProtection(PS7Protection pUsrData);
  // int SetSessionPassword(char *Password);
  // int ClearSessionPassword();
  // // Properties
  // int ExecTime();
  // int LastError();
  // int PDURequested();
  // int PDULength();
  // int PlcStatus();
  // bool Connected();
  // // Async functions
  // int SetAsCallback(pfn_CliCompletion pCompletion, void *usrPtr);
  // bool CheckAsCompletion(int *opResult);
  // int WaitAsCompletion(longword Timeout);
  // int AsReadArea(int Area, int DBNumber, int Start, int Amount, int WordLen, void *pUsrData);
  // int AsWriteArea(int Area, int DBNumber, int Start, int Amount, int WordLen, void *pUsrData);
  // int AsListBlocksOfType(int BlockType, PS7BlocksOfType pUsrData, int *ItemsCount);
  // int AsReadSZL(int ID, int Index, PS7SZL pUsrData, int *Size);
  // int AsReadSZLList(PS7SZLList pUsrData, int *ItemsCount);
  // int AsUpload(int BlockType, int BlockNum, void *pUsrData, int *Size);
  // int AsFullUpload(int BlockType, int BlockNum, void *pUsrData, int *Size);
  // int AsDownload(int BlockNum, void *pUsrData,  int Size);
  // int AsCopyRamToRom(int Timeout);
  // int AsCompress(int Timeout);
  // int AsDBRead(int DBNumber, int Start, int Size, void *pUsrData);
  // int AsDBWrite(int DBNumber, int Start, int Size, void *pUsrData);
  // int AsMBRead(int Start, int Size, void *pUsrData);
  // int AsMBWrite(int Start, int Size, void *pUsrData);
  // int AsEBRead(int Start, int Size, void *pUsrData);
  // int AsEBWrite(int Start, int Size, void *pUsrData);
  // int AsABRead(int Start, int Size, void *pUsrData);
  // int AsABWrite(int Start, int Size, void *pUsrData);
  //   int AsTMRead(int Start, int Amount, void *pUsrData);
  //   int AsTMWrite(int Start, int Amount, void *pUsrData);
  //   int AsCTRead(int Start, int Amount, void *pUsrData);
  // int AsCTWrite(int Start, int Amount, void *pUsrData);
  //   int AsDBGet(int DBNumber, void *pUsrData, int *Size);
  // int AsDBFill(int DBNumber, int FillChar);
}
