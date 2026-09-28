enum Meld {
  m20(20),
  m50(50),
  m100(100),
  m150(150),
  m200(200);

  final int value;
  const Meld(this.value);

  static Meld fromValue(int value) {
    return Meld.values.firstWhere((meld) => meld.value == value);
  }
}
