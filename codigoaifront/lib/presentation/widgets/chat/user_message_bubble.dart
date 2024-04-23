import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:yes_no/domain/entities/message.dart';

class UserMessageBubble extends StatelessWidget {
  final Message message;

  const UserMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
            decoration: BoxDecoration(
                color: colors.primary, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              // Usando MarkdownBody para renderizar el mensaje del usuario
              child: MarkdownBody(
                data: message.text,
                styleSheet:
                    MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  p: TextStyle(color: Colors.white), // Texto en markdown
                  strong: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold), // Para texto en negrita
                ),
              ),
            )),
        const SizedBox(height: 5) // Espacio después del mensaje
      ],
    );
  }
}
