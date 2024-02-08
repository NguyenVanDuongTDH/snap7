import 'dart:typed_data';

class S7 {
  static final Uint8List mask =
      Uint8List.fromList([0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80]);

// Lấy giá trị bit tại vị trí Pos trong mảng Buffer, bit 0..7
  static int getBit(List<int> buffer, int pos, int bit) {
    if (bit < 0) bit = 0;
    if (bit > 7) bit = 7;
    if ((buffer[pos] & mask[bit]) != 0) {
      return 1;
    } else {
      return 0;
    }
  }

// Đặt giá trị bit tại vị trí Pos trong mảng Buffer
  static void setBit(List<int> buffer, int pos, int bit, int value) {
    if (bit < 0) bit = 0;
    if (bit > 7) bit = 7;

    if (value != 1) {
      buffer[pos] &= ~mask[bit];
    } else {
      buffer[pos] |= mask[bit];
    }
  }

  // Lấy giá trị Byte (0..255) tại vị trí Pos trong mảng Buffer
  static int getByte(List<int> buffer, int pos) {
    return buffer[pos];
  }

// Đặt giá trị Byte (0..255) tại vị trí Pos trong mảng Buffer
  static void setByte(List<int> buffer, int pos, int value) {
    if (value < 0) value = 0;
    if (value > 255) value = 255;
    buffer[pos] = value;
  }

  static int getUSInt(List<int> buffer, int pos) => getByte(buffer, pos);
  static void setUSInt(List<int> buffer, int pos, int value) =>
      setByte(buffer, pos, value);

// Lấy giá trị SInt (-128..127) tại vị trí Pos trong mảng Buffer
  static int getSInt(List<int> buffer, int pos) {
    int value = buffer[pos];
    if (value < 128) {
      return value;
    } else {
      return value - 256;
    }
  }

// Đặt giá trị SInt (-128..127) tại vị trí Pos trong mảng Buffer
  static void setSInt(List<int> buffer, int pos, int value) {
    if (value < -128) value = -128;
    if (value > 127) value = 127;
    buffer[pos] =
        value & 0xFF; // Đảm bảo giá trị được giới hạn trong khoảng -128..127
  }

// Lấy giá trị 16 bit không dấu (S7 UInt) 0..65535
  static int getUInt(List<int> buffer, int pos) {
    return (buffer[pos] << 8) | buffer[pos + 1];
  }

// Đặt giá trị 16 bit không dấu (S7 UInt) 0..65535
  static void setUInt(List<int> buffer, int pos, int value) {
    buffer[pos] = (value >> 8) & 0xFF;
    buffer[pos + 1] = value & 0xFF;
  }

// Lấy giá trị 16 bit không dấu (S7 Word) 0..65535
  static int getWord(List<int> buffer, int pos) {
    return getUInt(buffer, pos);
  }

// Đặt giá trị 16 bit không dấu (S7 Word) 0..65535
  static void setWord(List<int> buffer, int pos, int value) {
    setUInt(buffer, pos, value);
  }

  // Lấy giá trị 16 bit có dấu (S7 int) -32768..32767 từ mảng Buffer
  static int getInt(List<int> buffer, int pos) {
    return (buffer[pos] << 8 | buffer[pos + 1]);
  }

// Đặt giá trị 16 bit có dấu (S7 int) -32768..32767 vào mảng Buffer
  static void setInt(List<int> buffer, int pos, int value) {
    buffer[pos] = (value >> 8) & 0xFF;
    buffer[pos + 1] = value & 0xFF;
  }

// Lấy giá trị 32 bit có dấu (S7 DInt) -2147483648..2147483647 từ mảng Buffer
  static int getDInt(List<int> buffer, int pos) {
    int result = 0;
    for (int i = 0; i < 4; i++) {
      result = (result << 8) | buffer[pos + i];
    }
    return result;
  }

// Đặt giá trị 32 bit có dấu (S7 DInt) -2147483648..2147483647 vào mảng Buffer
  static void setDInt(List<int> buffer, int pos, int value) {
    for (int i = 0; i < 4; i++) {
      buffer[pos + i] = (value >> (8 * (3 - i))) & 0xFF;
    }
  }

// Lấy giá trị 32 bit không dấu (S7 UDInt) 0..4294967295 từ mảng Buffer
  static int getUDInt(List<int> buffer, int pos) {
    int result = 0;
    for (int i = 0; i < 4; i++) {
      result = (result << 8) | buffer[pos + i];
    }
    return result & 0xFFFFFFFF; // Đảm bảo giá trị không âm
  }

// Đặt giá trị 32 bit không dấu (S7 UDInt) 0..4294967295 vào mảng Buffer
  static void setUDInt(List<int> buffer, int pos, int value) {
    for (int i = 0; i < 4; i++) {
      buffer[pos + i] = (value >> (8 * (3 - i))) & 0xFF;
    }
  }

// Lấy giá trị 32 bit không dấu (S7 DWord) 0..4294967295 từ mảng Buffer
  static int getDWord(List<int> buffer, int pos) {
    return getUDInt(buffer, pos);
  }

// Đặt giá trị 32 bit không dấu (S7 DWord) 0..4294967295 vào mảng Buffer
  static void setDWord(List<int> buffer, int pos, int value) {
    setUDInt(buffer, pos, value);
  }

// Lấy giá trị 64 bit không dấu (S7 ULint) 0..18446744073709551615 từ mảng Buffer
  static int getULInt(List<int> buffer, int pos) {
    int result = 0;
    for (int i = 0; i < 8; i++) {
      result = (result << 8) | buffer[pos + i];
    }
    return result & 0xFFFFFFFFFFFFFFFF; // Đảm bảo giá trị không âm
  }

// Đặt giá trị 64 bit không dấu (S7 ULint) 0..18446744073709551615 vào mảng Buffer
  static void setULInt(List<int> buffer, int pos, int value) {
    for (int i = 0; i < 8; i++) {
      buffer[pos + i] = (value >> (8 * (7 - i))) & 0xFF;
    }
  }

// Lấy giá trị 64 bit không dấu (S7 LWord) 0..18446744073709551615 từ mảng Buffer
  static int getLWord(List<int> buffer, int pos) {
    return getULInt(buffer, pos);
  }

// Đặt giá trị 64 bit không dấu (S7 LWord) 0..18446744073709551615 vào mảng Buffer
  static void setLWord(List<int> buffer, int pos, int value) {
    setULInt(buffer, pos, value);
  }

// Lấy giá trị 64 bit có dấu (S7 LInt) -9223372036854775808..9223372036854775807 từ mảng Buffer
  static int getLInt(List<int> buffer, int pos) {
    int result = 0;
    for (int i = 0; i < 8; i++) {
      result = (result << 8) | buffer[pos + i];
    }
    return result;
  }

// Đặt giá trị 64 bit có dấu (S7 LInt) -9223372036854775808..9223372036854775807 vào mảng Buffer
  static void setLInt(List<int> buffer, int pos, int value) {
    for (int i = 0; i < 8; i++) {
      buffer[pos + i] = (value >> (8 * (7 - i))) & 0xFF;
    }
  }

// Lấy giá trị 32 bit số thực (S7 Real) từ mảng Buffer
  static double getReal(List<int> buffer, int pos) {
    int pack = getUDInt(buffer, pos);
    double result = 0.0;
    ByteData bd = ByteData(4);
    bd.setUint32(0, pack);
    result = bd.getFloat32(0, Endian.big); // Đọc dưới dạng big-endian
    return result;
  }

// Đặt giá trị 32 bit số thực (S7 Real) vào mảng Buffer
  static void setReal(List<int> buffer, int pos, double value) {
    ByteData bd = ByteData(4);
    bd.setFloat32(0, value, Endian.big); // Lưu dưới dạng big-endian
    int pack = bd.getUint32(0);
    setUDInt(buffer, pos, pack);
  }

// Lấy giá trị 64 bit số thực (S7 LReal) (Range of double) từ mảng Buffer
  static double getLReal(List<int> buffer, int pos) {
    int pack = getULInt(buffer, pos);
    double result = 0.0;
    ByteData bd = ByteData(8);
    bd.setInt64(0, pack, Endian.big);
    result = bd.getFloat64(0, Endian.big); // Đọc dưới dạng big-endian
    return result;
  }

// Đặt giá trị 64 bit số thực (S7 LReal) (Range of double) vào mảng Buffer
  static void setLReal(List<int> buffer, int pos, double value) {
    ByteData bd = ByteData(8);
    bd.setFloat64(0, value, Endian.big); // Lưu dưới dạng big-endian
    int pack = bd.getInt64(0, Endian.big);
    setULInt(buffer, pos, pack);
  }


// Lấy giá trị chuỗi (S7 String) từ mảng Buffer
  static String getString(List<int> buffer, int pos) {
    int maxLength = buffer[pos];
    int currentLength = buffer[pos + 1];
    List<int> chars = buffer.sublist(pos + 2, pos + 2 + currentLength);
    return String.fromCharCodes(chars);
  }

// // Đặt giá trị chuỗi (S7 String) vào mảng Buffer
  static void setString(
      List<int> buffer, int pos, int maxLength, String value) {
    int currentLength = value.length;
    buffer[pos] = maxLength;
    buffer[pos + 1] = currentLength;
    for (int i = 0; i < currentLength; i++) {
      buffer[pos + 2 + i] = value.codeUnitAt(i);
    }
  }

// // Lấy giá trị mảng ký tự (S7 ARRAY OF CHARS) từ mảng Buffer
  static String getChars(List<int> buffer, int pos, int size) {
    List<int> chars = buffer.sublist(pos, pos + size);
    return String.fromCharCodes(chars);
  }

// Đặt mảng ký tự (S7 ARRAY OF CHARS) vào mảng Buffer
  static void setChars(List<int> buffer, int pos, String value) {
    int maxLen = buffer.length - pos;
    int size = value.length;

    if (size > maxLen) {
      size = maxLen;
    }

    for (int i = 0; i < size; i++) {
      buffer[pos + i] = value.codeUnitAt(i);
    }
  }
}
