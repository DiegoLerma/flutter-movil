import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yes_no/domain/entities/message.dart';
import 'package:yes_no/presentation/providers/chat_provider.dart';
import 'package:yes_no/presentation/widgets/chat/her_message_bubble.dart';
import 'package:yes_no/presentation/widgets/chat/my_message_bubble.dart';
import 'package:yes_no/presentation/widgets/shared/message_field_box.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: _ChatView(),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Padding(
        padding: EdgeInsets.all(4.0),
        child: CircleAvatar(
          backgroundImage: NetworkImage(
              "https://phantom-marca-us.unidadeditorial.es/0a774892da73bbeb49a02e9a8e39e3ad/resize/828/f/jpg/assets/multimedia/imagenes/2023/01/08/16731951733620.jpg"),
        ),
      ),
      title: const Text('Mi amors ❤️'),
      // centerTitle: true,
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Define el tamaño preferido aquí
}

class _ChatView extends StatelessWidget {
  const _ChatView();

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
              controller: chatProvider.chatScrollController,
              itemCount: chatProvider.messageList.length,
              itemBuilder: (context, index) {
                final message = chatProvider.messageList[index];
                return (message.fromWho == FromWho.hers)
                    ? HerMessageBubble(message: message)
                    : MyMessageBubble(message: message);
              },
            )),
            //Caja de texto
            MessageFieldBox(
              // onValue: (value) => chatProvider.sendMessage(value), // La forma larga de hacerlo
              onValue: chatProvider.sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
