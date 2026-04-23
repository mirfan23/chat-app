import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';

part 'register_state.freezed.dart';

@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState({@Default(false) bool isLoading, Response? apiError, dynamic error}) = _RegisterState;
}
