import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:yes_no/domain/entities/message.dart';

class ChatProvider extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();
  Dio dio = Dio();

  // La URL del endpoint de tu servidor FastAPI
  final String apiUrl = 'https://codigoai.azurewebsites.net/triage/';

  List<Message> messageList = [];

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;
    final newMessage = Message(text: text, fromWho: FromWho.user);
    messageList.add(newMessage);
    notifyListeners();
    moveScrollToBottom();
    await sendToApi(text);
  }

  Future<void> sendToApi(String text) async {
    try {
      var response = await dio.post(
        apiUrl,
        data: {
          "messages": [
            {"role": "user", "content": text}
          ]
        },
      );
      if (response.statusCode == 200 && response.data != null) {
        // Asumiendo que la respuesta de FastAPI es un JSON con una clave 'text'
        final botMessage =
            Message(text: response.data['text'], fromWho: FromWho.bot);
        messageList.add(botMessage);
        notifyListeners();
        moveScrollToBottom();
      } else {
        // Manejo de errores de API
        throw Exception(
            'Error al cargar mensaje. Por favor contacta al administrador.');
      }
    } catch (e) {
      print(
          'Error al enviar mensaje: $e'); // Esto ayudará a depurar el problema
      throw Exception('Error al enviar mensaje.');
    }
  }

  Future<void> moveScrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));
    chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut);
  }
}
