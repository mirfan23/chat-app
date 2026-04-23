import 'package:chat_app/features/profile/models/profile_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';

part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isLoading,
    ProfileModel? profile,
    dynamic error,
    Response? apiError,
  }) = _ProfileState;
}
