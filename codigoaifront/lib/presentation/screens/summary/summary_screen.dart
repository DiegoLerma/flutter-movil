// import 'dart:convert';

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

  @override
  void dispose() {
    _dio.close(); // Cerrar el cliente Dio cuando el widget se elimine
    super.dispose();
  }

  Future<void> _fetchSummaries() async {
    try {
      const url = 'https://codigoai.azurewebsites.net/med_summaries/';
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        final List<Summary> summaryDB = summaryFromJson(response.data);

        List<Summary> filteredSummaries = summaryDB
            .where((summary) =>
                !summary.content.attended &&
                !summary.content.goneWithoutAttention)
            .toList();

        Map<String, List<Summary>> newSummariesByColor = {};

        for (var summary in filteredSummaries) {
          var triageColorKey = summary.content.colorDeTriage.toLowerCase();
          if (!newSummariesByColor.containsKey(triageColorKey)) {
            newSummariesByColor[triageColorKey] = [];
          }
          newSummariesByColor[triageColorKey]!.add(summary);
        }

        if (mounted) {
          // Verificar si el widget todavía está en el árbol
          setState(() {
            summariesByColor = newSummariesByColor;
          });
        }
      } else {
        throw Exception(
            'Failed to load summaries with status code: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al obtener los datos: $e')));
      }
      if (mounted) {
        // Verificar si el widget todavía está en el árbol
        setState(() {
          summariesByColor = {};
        });
      }
    }

    // ... el resto del código ...
  }

  @override
  Widget build(BuildContext context) {
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
                    color: summary.content.contentDetails.color,
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
                              data: summary.content.contentDetails
                                  .resumen, // Mostrar el resumen en Markdown
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(16.0),
                          //   child: MarkdownBody(
                          //     data: summary.content.contentDetails
                          //         .formattedConversation, // Mostrar la conversación completa formateada
                          // ),
                          // ),
                        ],
                      ),
                    ),
                  )),
            ])
        .toList();
  }
}
