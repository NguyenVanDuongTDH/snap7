class ArrayPLCValue<T> extends Iterable<T> {
  T Function(int index, int offset)? getFunc;
  void Function(int index, int offset, T value)? setFunc;
  int _length = 0;
  int _offset = 0;

  @override
  int get length => _length;

  ArrayPLCValue({required int length, required int offset}) {
    _length = length;
    _offset = offset;
  }

  static List<int> boolOffset(int offset, int index) {
    if (index < 8) {
      return [offset, index];
    } else {
      offset = offset + index ~/ 8;
      index = index % 8;
      return [offset, index];
    }
  }

  T? operator [](int index) {
    return getFunc!(index, _offset);
  }

  void operator []=(int index, T value) {
    setFunc!(index, _offset, value);
  }

  Iterator<T> _iterator() {
    List<T> list = [];
    ArrayPLCValue p = this;
    for (var i = 0; i < length; i++) {
      list.add(p[i]);
    }
    return list.iterator;
  }

  @override
  Iterator<T> get iterator => _iterator();
}