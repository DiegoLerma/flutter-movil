import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:yes_no/domain/entities/summary.dart';
import 'package:yes_no/config/helpers/api_service.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  SummaryScreenState createState() => SummaryScreenState();
}

class SummaryScreenState extends State<SummaryScreen> {
  Map<String, List<Summary>> summariesByColor = {};
  final Dio _dio = Dio();
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(_dio); // Initialize the API service
    _fetchSummaries();
  }

  Future<void> _fetchSummaries() async {
    try {
      const url = 'https://codigoai.azurewebsites.net/med_summaries/';
      final response = await _dio.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Convertir la respuesta a String si no se está haciendo
        String responseString = jsonEncode(response.data);
        List<Summary> summaries = summaryFromJson(responseString);

        print("Summaries: $summaries");

        // Filtra los resúmenes que no han sido atendidos y que no se han ido sin atención
        List<Summary> filteredSummaries = summaries
            .where((summary) =>
                !summary.content.attended &&
                !summary.content.goneWithoutAttention)
            .toList();

        // Agrupa los resúmenes por el color de triage
        Map<String, List<Summary>> newSummariesByColor = {
          'rojo': [],
          'naranja': [],
          'amarillo': [],
          'verde': []
        };

        for (var summary in filteredSummaries) {
          var triageColorKey = summary.content.colorDeTriage.toLowerCase();
          print("Triage color key: $triageColorKey");
          newSummariesByColor[triageColorKey]?.add(summary);
        }

        setState(() {
          summariesByColor =
              newSummariesByColor; // Actualiza el estado con los resúmenes filtrados y agrupados
        });
      } else {
        throw Exception(
            'Failed to load summaries with status code: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al obtener los datos: $e')));
      }
      setState(() {
        summariesByColor = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        "Summaries by color $summariesByColor"); // Asegúrate de que los datos se han cargado correctamente
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resúmenes Médicos"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _fetchSummaries,
              child: const Text('Actualizar Resúmenes'),
            ),
            const SizedBox(height: 16.0),
            ..._buildSummaryWidgets(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSummaryWidgets() {
    print(
        summariesByColor); // Asegúrate de que los datos se han cargado correctamente
    return summariesByColor.entries
        .expand((entry) => [
              if (entry.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(entry.key,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: TriageUtils.colorFromTriage(entry.key))),
                ),
              ...entry.value.map((summary) => Card(
                    color: summary.content.content
                        .color, // Asumiendo que el color se determina aquí
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExpansionTile(
                        title: Text(summary.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _apiService
                              .markSummaryAsAttended(summary.content.id),
                        ),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: MarkdownBody(
                                data: summary.content.content
                                    .resumen), // Mostrar el resumen en Markdown
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: MarkdownBody(
                                data: summary.content.content
                                    .formattedConversation), // Mostrar la conversación completa formateada
                          ),
                        ],
                      ),
                    ),
                  )),
            ])
        .toList();
  }
}
