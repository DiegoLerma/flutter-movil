import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:codigoia/domain/entities/message.dart';

class ChatProvider extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();

  // La URL del endpoint del servidor FastAPI
  final String apiUrl = 'https://codigoiabackend.azurewebsites.net/triage/';

  List<Message> messageList = [];

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;
    final newMessage = Message(text: text, fromWho: FromWho.user);
    messageList.add(newMessage);
    notifyListeners();
    moveScrollToBottom();
    try {
      await sendToApi(text);
    } catch (e) {
      // Mostrar mensaje de error en la interfaz de usuario si es necesario
      final errorMessage = Message(text: e.toString(), fromWho: FromWho.bot);
      messageList.add(errorMessage);
      notifyListeners();
    }
  }

  Future<void> sendToApi(String text) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type':
              'application/json; charset=UTF-8', // Añadir charset=UTF-8
        },
        body: jsonEncode({
          "messages": [
            {"role": "user", "content": text}
          ]
        }),
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = jsonDecode(utf8.decode(
            response.bodyBytes)); // Decodificar el cuerpo de la respuesta
        final botMessage = Message(text: data['text'], fromWho: FromWho.bot);
        messageList.add(botMessage);
        notifyListeners();
        moveScrollToBottom();
      } else {
        throw Exception(
            'Error al recibir respuesta del servidor. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de comunicación: $e');
    }
  }

  Future<void> moveScrollToBottom() async {
    if (chatScrollController.hasClients) {
      await Future.delayed(const Duration(milliseconds: 100));
      chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
