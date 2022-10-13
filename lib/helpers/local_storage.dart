import 'dart:convert';

import 'package:cleanedapp/user/be_user_model.dart';
import 'package:sharedor/helpers/export_helpers.dart';

extension LocalStorage on PreferenceUtils {
  set setMember(BeUser user) =>
      setKeyValue("member", jsonEncode(user.toJson()));
}
