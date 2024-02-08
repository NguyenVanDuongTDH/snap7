import 'dart:typed_data';
import 'package:snap7/snap7.dart';


class PLC_DB {
  final S7Client __plc__;
  Uint8List? __bytes__;
  final int __dbNumber__ = 1;
  final int ___lenght__ = 18;

  PLC_DB(S7Client plc) : __plc__ = plc;



  bool read() {
    __bytes__ = __plc__.DBRead(__dbNumber__, 0, ___lenght__);
    return __bytes__ != null;
  }

  bool disconnect() {
    return __plc__.Disconnect();
  }


  bool get b => S7.getBit(__bytes__!, 0, 0) == 1;

  set b(bool value) {
    S7.setBit(__bytes__!, 0, 0, value ? 1 : 0);
    __plc__.DBWrite(__dbNumber__, 0, __bytes__!.sublist(0, 0 + 1));
  }


  bool get a => S7.getBit(__bytes__!, 0, 1) == 1;

  set a(bool value) {
    S7.setBit(__bytes__!, 0, 1, value ? 1 : 0);
    __plc__.DBWrite(__dbNumber__, 0, __bytes__!.sublist(0, 0 + 1));
  }

  int get c => S7.getInt(__bytes__!, 2);

  set c(int value) {
    
    S7.setInt(__bytes__!, 2 , value);
    __plc__.DBWrite(__dbNumber__, 2,  __bytes__!.sublist(2 , 2 + 2));
  }
  ArrayPLCValue<bool> get bbb => __bbb();
  ArrayPLCValue<bool> __bbb() {
    ArrayPLCValue<bool> _array = ArrayPLCValue<bool>(length: 15 + 1, offset: 4);
    _array.getFunc = (index, offset) {
      int l = ArrayPLCValue.boolOffset(offset, index)[0];
      int r = ArrayPLCValue.boolOffset(offset, index)[1];
      return S7.getBit(__bytes__!, l, r) == 1;
    };
    //
    _array.setFunc = (index, offset, value) {
      int l = ArrayPLCValue.boolOffset(offset, index)[0];
      int r = ArrayPLCValue.boolOffset(offset, index)[1];
      S7.setBit(__bytes__!, l, r, value ? 1 : 0);
      __plc__.DBWrite(__dbNumber__, l, __bytes__!.sublist(l, l + 1));
    };
    return _array;
  }
  ArrayPLCValue<bool> get cc => __cc();
  ArrayPLCValue<bool> __cc() {
    ArrayPLCValue<bool> _array = ArrayPLCValue<bool>(length: 15 + 1, offset: 6);
    _array.getFunc = (index, offset) {
      int l = ArrayPLCValue.boolOffset(offset, index)[0];
      int r = ArrayPLCValue.boolOffset(offset, index)[1];
      return S7.getBit(__bytes__!, l, r) == 1;
    };
    //
    _array.setFunc = (index, offset, value) {
      int l = ArrayPLCValue.boolOffset(offset, index)[0];
      int r = ArrayPLCValue.boolOffset(offset, index)[1];
      S7.setBit(__bytes__!, l, r, value ? 1 : 0);
      __plc__.DBWrite(__dbNumber__, l, __bytes__!.sublist(l, l + 1));
    };
    return _array;
  }
 ArrayPLCValue<int> get bytes => __bytes();
 ArrayPLCValue<int> __bytes(){
    ArrayPLCValue<int> _array = ArrayPLCValue<int>(length: 1 + 1,offset: 8);
    _array.getFunc = (index, offset){
     int _size = 1;
     int _offset = offset + (_size * index);
      return  S7.getByte(__bytes__!, _offset);
    };
    _array.setFunc = (index, offset, value){
      int _size = 1;
      int _offset = offset + (_size * index);
     

    S7.setByte(__bytes__!, _offset, value);
    __plc__.DBWrite(__dbNumber__, _offset,  __bytes__!.sublist(_offset, _offset + _size) );
    };
    return _array; 
  }
  int get o => S7.getLInt(__bytes__!, 10);

  set o(int value) {
    
    S7.setLInt(__bytes__!, 10 , value);
    __plc__.DBWrite(__dbNumber__, 10,  __bytes__!.sublist(10 , 10 + 8));
  }

}