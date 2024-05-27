import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod_template/data/remote/api/api_result_state.dart';
import 'package:flutter_riverpod_template/feature/login/models/login_request_model.dart';
import 'package:flutter_riverpod_template/feature/login/models/login_response_model.dart';
import 'package:flutter_riverpod_template/feature/login/models/login_state_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_notifier_provider.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  Future<LoginStateModel> build() async {
    debugPrint('login initial state....');
    return Future.value(const LoginStateModel());
  }

  Future<LoginStateModel> login(LoginRequestModel loginRequestModel) async {
    debugPrint('login requested....');
    state = const AsyncData(
        LoginStateModel(apiResultState: APIResultState.loading));
    try {
      // Simulate loading delay
      await Future.delayed(const Duration(seconds: 2));
      debugPrint('login data loaded....');
      // TODO api call goes here
      // Return dummy future with dummy response model
      const loginStateModel = LoginStateModel(
          apiResultState: APIResultState.result,
          loginResponseModel:
              LoginResponseModel(id: 1, userName: 'dinkar1708@gmail.com'));
      state = const AsyncData(loginStateModel);
      // throw error to test
      // throw Exception("Login id is incorrect from api!!");
      // return actual value to test correct case
      return Future.value(loginStateModel);
    } catch (e, trace) {
      debugPrint("Error in login notifier provider $e $trace ");
      final loginStateModel = LoginStateModel(
          apiResultState: APIResultState.error,
          errorMessage: "Login id is in correct! $e");
      // update UI
      state = AsyncData(loginStateModel);
      // also return
      return Future.value(loginStateModel);
    }
  }
}
