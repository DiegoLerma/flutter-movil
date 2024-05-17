import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yes_no/domain/entities/message.dart';

class ApiService {
  final String _apiUrl = 'https://codigoiabackend.azurewebsites.net/triage/';

  Future<Message> sendChatMessage(String text) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type':
              'application/json; charset=UTF-8', // Añadir charset=UTF-8
          'Origin': 'https://tudominio.com' // Agregar el encabezado Origin
        },
        body: jsonEncode({
          "messages": [
            {"role": "user", "content": text}
          ]
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(
            response.bodyBytes)); // Decodificar el cuerpo de la respuesta
        return Message(text: data['text'], fromWho: FromWho.bot);
      } else {
        throw Exception(
            'Error al cargar el mensaje. Por favor revise su conexión a internet.');
      }
    } catch (e) {
      throw Exception(
          'Error al enviar el mensaje. Por favor revise su conexión a internet.');
    }
  }

  Future<void> markSummaryAsAttended(String summaryId) async {
    try {
      final response = await http.post(
        Uri.parse('${_apiUrl}summary_status/update_attended/$summaryId'),
      );
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to mark summary as attended with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error marking summary as attended: $e');
    }
  }

  Future<void> markSummaryAsGoneWithoutAttention(String summaryId) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${_apiUrl}summary_status/update_gone_without_attention/$summaryId'),
      );
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to mark summary as gone without attention with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error marking summary as gone without attention: $e');
    }
  }
}
