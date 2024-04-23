import 'package:flutter/material.dart';

class MessageFieldBox extends StatelessWidget {
  final ValueChanged<String> onValue;

  const MessageFieldBox({super.key, required this.onValue});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final focusNode = FocusNode();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: textController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Escriba su mensaje...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 25,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: IconButton(
              icon: const Icon(Icons.send),
              color: Colors.white,
              onPressed: () {
                if (textController.text.trim().isNotEmpty) {
                  onValue(textController.text.trim());
                  textController.clear();
                  // focusNode.unfocus();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
