import 'package:dio/dio.dart';
import 'package:yes_no/domain/entities/message.dart';

class ApiService {
  final Dio _dio; // Hace _dio un campo final que debe ser inicializado

  // Modifica el constructor para aceptar una instancia de Dio
  ApiService(this._dio);

  final String _apiUrl = 'https://codigoai.azurewebsites.net/triage/';

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

  // Método para marcar un resumen como atendido
  Future<void> markSummaryAsAttended(String summaryId) async {
    try {
      final response = await _dio
          .post('${_apiUrl}summary_status/update_attended/$summaryId');
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to mark summary as attended with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error marking summary as attended: $e');
    }
  }

  // Método para marcar un resumen como ignorado
  Future<void> markSummaryAsGoneWithoutAttention(String summaryId) async {
    try {
      final response = await _dio.post(
          '${_apiUrl}summary_status/update_gone_without_attention/$summaryId');
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to mark summary as gone without attention with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error marking summary as gone without attention: $e');
    }
  }
}
