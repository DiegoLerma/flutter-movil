import 'package:dio/dio.dart';
import 'package:yes_no/domain/entities/message.dart';

class ApiService {
  final Dio _dio = Dio(); // Instancia de Dio para realizar solicitudes HTTP

  // Actualiza la URL del endpoint a la dirección correcta del servidor FastAPI
  final String _apiUrl =
      'https://codigoai.azurewebsites.net/triage/'; // Asegúrate de cambiar esto por la IP correcta o URL

  // Método para enviar mensaje y recibir respuesta de la API
  Future<Message> sendChatMessage(String text) async {
    try {
      final response = await _dio.post(
        _apiUrl,
        data: {
          "messages": [
            {"role": "user", "content": text}
          ]
        },
      );
      if (response.statusCode == 200 && response.data != null) {
        // Asume que la respuesta es directamente el texto del mensaje
        // Extrae el texto usando la clave 'text'
        return Message(text: response.data['text'], fromWho: FromWho.bot);
      } else {
        // Lanza una excepción si la respuesta no es válida
        throw Exception(
            'Error al cargar el mensaje. Por favor revise su conexión a internet.');
      }
    } catch (e) {
      throw Exception(
          'Error al enviar el mensaje. Por favor revise su conexión a internet.');
    }
  }
}
