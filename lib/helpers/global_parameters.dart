import 'package:sharedor/helpers/export_helpers.dart';

class GlobalParametersFM extends GlobalParameters {
  Map<String, dynamic>? params;
  static final GlobalParametersFM _gp = GlobalParametersFM._internal();
  GlobalParametersFM._internal() {
    // setGlobalParameters(params);
  }
  factory GlobalParametersFM() {
    return _gp;
  }
  String? _familyId = "";
  @override
  setGlobalParameters(Map<String, dynamic>? params) {
    if (params?["familyId"] != null) {
      _familyId = params!["familyId"];
      PreferenceUtils().setKeyValue("familyId", _familyId!);
    } else {
      _familyId = PreferenceUtils().getKeyValue("familyId");
    }
    super.setGlobalParameters(params);
  }

  set setFamilyId(String id) {
    _familyId = id;
    PreferenceUtils().setKeyValue("familyId", id);
  }

  String? get familyId => _familyId;
}
