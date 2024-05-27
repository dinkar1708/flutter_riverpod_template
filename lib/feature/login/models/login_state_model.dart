import 'package:flutter_riverpod_template/data/remote/api/api_result_state.dart';
import 'package:flutter_riverpod_template/feature/login/models/login_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state_model.freezed.dart';
part 'login_state_model.g.dart';

@freezed
class LoginStateModel with _$LoginStateModel {
  const factory LoginStateModel({
    @Default(APIResultState.initial) APIResultState apiResultState,
    @Default("") String errorMessage,
    LoginResponseModel? loginResponseModel,
  }) = _LoginStateModel;

  factory LoginStateModel.fromJson(Map<String, dynamic> json) =>
      _$LoginStateModelFromJson(json);
}
