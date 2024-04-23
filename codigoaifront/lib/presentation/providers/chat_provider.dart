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
      var response = await dio.post(
        apiUrl,
        data: {
          "messages": [
            {"role": "user", "content": text}
          ]
        },
      );
      if (response.statusCode == 200 && response.data != null) {
        final botMessage =
            Message(text: response.data['text'], fromWho: FromWho.bot);
        messageList.add(botMessage);
        notifyListeners();
        moveScrollToBottom();
      } else {
        throw Exception(
            'Error al recibir respuesta del servidor. Código de estado: ${response.statusCode}');
      }
    } on DioException catch (dioException) {
      // Utilizar el mensaje y la información específica de DioException para una mejor respuesta
      String errorMessage = 'Error de comunicación';
      if (dioException.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Tiempo de conexión agotado';
      } else if (dioException.type == DioExceptionType.sendTimeout) {
        errorMessage = 'Tiempo de envío agotado';
      } else if (dioException.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Tiempo de recepción agotado';
      } else if (dioException.type == DioExceptionType.badResponse) {
        errorMessage = 'Respuesta no válida del servidor';
      } else if (dioException.type == DioExceptionType.connectionError) {
        errorMessage = 'Error de conexión: ${dioException.message}';
      } else if (dioException.type == DioExceptionType.cancel) {
        errorMessage = 'Solicitud cancelada';
      } else {
        errorMessage = 'Error desconocido: ${dioException.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<void> moveScrollToBottom() async {
    if (chatScrollController.hasClients) {
      await Future.delayed(const Duration(milliseconds: 100));
      chatScrollController.animateTo(
          chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut);
    }
  }
}
