import 'package:freezed_annotation/freezed_annotation.dart';
part 'chat_state.freezed.dart';

@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    @Default(false) bool isLoading,
    @Default([]) List<Map<String, dynamic>> messages,
    String? typingUser,
  }) = _ChatState;
}
