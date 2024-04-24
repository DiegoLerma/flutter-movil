import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:yes_no/domain/entities/message.dart';

class BotMessageBubble extends StatelessWidget {
  final Message message;

  const BotMessageBubble({super.key, required this.message});

  Color _getMessageBackgroundColor(String messageText, ColorScheme colors) {
    final lowerCaseText = messageText.toLowerCase();

    if (lowerCaseText.contains('código rojo')) {
      return Colors.red[100]!;
    } else if (lowerCaseText.contains('código naranja')) {
      return Colors.orange[100]!;
    } else if (lowerCaseText.contains('código amarillo')) {
      return Colors.yellow[100]!;
    } else if (lowerCaseText.contains('código verde')) {
      return Colors.green[100]!;
    } else if (lowerCaseText.contains('código azul')) {
      return Colors.blue[100]!;
    } else if (lowerCaseText.contains('código naranja')) {
      return Colors.orange[100]!; // Color naranja pastel
    } else if (lowerCaseText.contains('código amarillo')) {
      return Colors.yellow[100]!; // Color amarillo pastel
    } else if (lowerCaseText.contains('código verde')) {
      return Colors.green[100]!; // Color verde pastel
    } else if (lowerCaseText.contains('código azul')) {
      return Colors.blue[100]!; // Color azul pastel
    }
    // Color por defecto para mensajes normales
    return colors.secondary;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final backgroundColor = _getMessageBackgroundColor(message.text, colors);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity, // Ocupar toda la anchura disponible
          decoration: BoxDecoration(
            color: backgroundColor, // Color basado en el contenido del mensaje
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: MarkdownBody(
              data: message.text,
              styleSheet:
                  MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                p: TextStyle(
                  color: backgroundColor.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                ),
                strong: TextStyle(
                  color: backgroundColor.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10), // Espacio después del mensaje
      ],
    );
  }
}
