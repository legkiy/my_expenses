int calculateMonthCount(
    {required int startYear,
    required int startMonth,
    required int currentYear,
    required int currentMonth}) {
  int munthCount =
      (currentYear - startYear) * 12 + currentMonth - startMonth + 1;
  return munthCount;
}
