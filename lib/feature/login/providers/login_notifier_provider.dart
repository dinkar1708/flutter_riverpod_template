import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod_template/data/remote/api/api_result_state.dart';
import 'package:flutter_riverpod_template/feature/login/models/login_request_model.dart';
import 'package:flutter_riverpod_template/feature/login/models/login_response_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_notifier_provider.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  Future<APIResultState> build() async {
    debugPrint('login initial state....');
    return Future.value(APIResultState.initial);
  }

  Future<LoginResponseModel?> login(LoginRequestModel loginRequestModel) async {
    debugPrint('login requested....');
    state = const AsyncData(APIResultState.loading);
    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 2));
    debugPrint('login data loaded....');
    state = const AsyncData(APIResultState.result);
    // Return dummy future with dummy response model
    // TODO api call goes here
    return Future.value(
        const LoginResponseModel(id: 1, userName: 'dinkar1708@gmail.com'));
  }
}
