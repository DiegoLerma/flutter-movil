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
          minRadius: 6,
          maxRadius: 6,
          backgroundImage: NetworkImage(
              "https://lh3.googleusercontent.com/pw/AP1GczMuth-tDAekLWuJIWWTm0e9_JaIu1IIIe8bn8w24ykpesbFu5qKop7-MIgIABRnqNV5JHnTcT1wTfqSuyGERAjG0xtZ6nUxToww2SjmbdtqiK3ywBaQVvzpb14H4T3UO6uK8JLkMjHZMib1XsrIQU88wvr1pjxGEUwCMznnnFRnOsUuFODz_DAoH6v_x0XxA4-Mmo02_C58nwLOXgbW7fzH7ruod4Z324VqsA65g89RN7MVy6FCAQou8tt67NQcM0iOGkqWGD6U1DKUm9inwoCeODiIySwKl2tTdo4z9uE9CeOBKJB3AduzUeyOIdi9BHj7_30UEkKky2BSdAj2OGDiipdOhOMCVVcorsEj14t63afu0zvl2y6_ryTiu9he0cJUadHR13ItjScRuHhSfevEQQqICmkzoCezIdY_yIO-uzeiD_2XIose4-AxVtDLgHAmYxMZ1QFEBdldZtJP-Uwqta_EY2a2iy6fbwy-Y18tGu1ddoj3pxJa_AFTqzw_XaXhimiPABpmzavv8_CsMQLTGLOOW2qeG_LGez66JPlBZCIdFvGWlV7pHuNlo-p00cI4r1EJg00xbOcQX01ejQrWDsVpgdagQ9IbCQfY2g2EWRXXmtZWQwKaCNEHyEeniaF56fyiULXspIi883IJuwtIBUAKpK7HQrkduQvVEx1O4nN-IHw2OejMzEvSO-pFRP_ke7NrshUMqUt3UK7Q_Yn40oR89AV9XXw8n_t4iOG8g5DDdCAKJ7MyiDBraalP1woZ38OJZ3d0EMaaALNWYjqKexIV2E9x5897f2litAS4NSCF5DcF0wTxmFstmQqwoVUigmczghA8EUV-V0vozt68xT-H5D5XG1CODoJ-AvcuUtzcDsRkUgE53D34sxJuHL7PU8YHn7ZYUThWQVq9VZ1V=w726-h970-s-no-gm?authuser=0"),
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
