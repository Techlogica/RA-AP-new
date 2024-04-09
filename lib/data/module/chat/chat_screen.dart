import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:rapid_app/data/module/chat/chat_controller.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Obx(() => Chat(
              messages: controller.messages.value,
              onAttachmentPressed: () =>
                  controller.handleAttachmentPressed(context),
              onMessageTap: controller.handleMessageTap,
              onPreviewDataFetched: controller.handlePreviewDataFetched,
              onSendPressed: controller.handleSendPressed,
              showUserAvatars: true,
              showUserNames: true,
              user: controller.user,
              theme: const DefaultChatTheme(
                primaryColor: Colors.blueGrey,
                receivedMessageBodyTextStyle:
                    TextStyle(fontSize: 12, color: Colors.black),
                sentMessageBodyTextStyle:
                    TextStyle(fontSize: 14, color: Colors.white),
                seenIcon: Text(
                  'read',
                  style: TextStyle(
                    fontSize: 10.0,
                  ),
                ),
              ),
            )),
      );
}
