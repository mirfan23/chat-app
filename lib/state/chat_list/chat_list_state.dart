import 'package:chat_app/models/chat_list_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_list_state.freezed.dart';

@freezed
abstract class ChatListState with _$ChatListState {
  const factory ChatListState({
    @Default(false) bool isLoading,
    @Default([]) List<ChatListModel> chatList,
    @Default({}) Map<String, bool> onlineUsers,
    String? myUserId,
  }) = _ChatListState;
}
