import 'package:chat_app/models/all_user_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'all_user_state.freezed.dart';

@freezed
abstract class AllUserState with _$AllUserState {
  const factory AllUserState({@Default(false) bool isLoading, @Default([]) List<AllUserModel> users, Object? error}) =
      _AllUserState;
}
