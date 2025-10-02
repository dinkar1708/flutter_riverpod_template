import 'package:freezed_annotation/freezed_annotation.dart';

part 'users_filter_parameter_model.freezed.dart';
part 'users_filter_parameter_model.g.dart';

@freezed
class UsersFilterParameterModel with _$UsersFilterParameterModel {
  const factory UsersFilterParameterModel({
    @Default('') String query,
  }) = _UsersFilterParameterModel;

  factory UsersFilterParameterModel.fromJson(Map<String, dynamic> json) =>
      _$UsersFilterParameterModelFromJson(json);
}


