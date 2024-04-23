import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:yes_no/domain/entities/message.dart';

class BotMessageBubble extends StatelessWidget {
  final Message message;

  const BotMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
              color: colors.secondary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              // Aquí usamos MarkdownBody para renderizar el mensaje
              child: MarkdownBody(
                data: message.text,
                styleSheet:
                    MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  p: const TextStyle(color: Colors.white), // Texto en markdown
                  strong: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold), // Para el texto en negrita
                ),
              ),
            )),
        const SizedBox(
            height: 10), // Mantenemos un pequeño espacio después del mensaje
      ],
    );
  }
}
