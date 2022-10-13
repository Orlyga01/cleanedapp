enum FrequencyEnum { everyTime, twoWeeks, month, halfAYear, year }

Map<dynamic, String> mapEnumToString(String enumName, List<String> list) {
  switch (enumName) {
    case "frequency":
      Map<FrequencyEnum, String> retmap = {};
      FrequencyEnum.values.asMap().forEach((index, tag) =>
          retmap[tag] = index < list.length ? list[index] : 'empty');

      break;
    default:
      return {};
  }
  return {};
}

class FrequencyClass {
  Map<FrequencyEnum, String> map =
      mapEnumToString("frequency", ["Every Day", "", "", ""])
          as Map<FrequencyEnum, String>;
  String name(FrequencyEnum val) {
    return map[val]!;
  }

  // dynamic call(CategoryEnum category, String? field) {
  //   if (field == null) {
  //     return data[category]!;
  //   } else {
  //     return (data[category] as CategoryInfoModel).toJson()[field];
  //   }
  // }

  // static CategoryEnum categoryEnum(String category) => data.keys.firstWhere(
  //       (element) => (data[element] as CategoryInfoModel).name == category,
  //     );
}
