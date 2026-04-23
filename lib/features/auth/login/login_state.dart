import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';

part 'login_state.freezed.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool isLoading,
    Response? apiError,
    dynamic error,
    String? token,
    String? message,
  }) = _LoginState;
}
