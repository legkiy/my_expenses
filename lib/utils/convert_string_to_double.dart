double convertStringToDouble(String str) {
  double? amount = double.tryParse(str);
  return amount ?? 0;
}
