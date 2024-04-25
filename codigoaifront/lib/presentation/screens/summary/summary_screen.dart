// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Resúmenes Médicos",
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _fetchSummaries,
              child: const Text('Actualizar Resúmenes'),
            ),
            ..._buildSummaryWidgets(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSummaryWidgets() {
    // Definir el orden deseado de los colores
    const List<String> colorOrder = ['rojo', 'naranja', 'amarillo', 'verde'];

    // Ordenar las entradas del mapa según el orden definido
    final sortedEntries = summariesByColor.entries.toList()
      ..sort((a, b) =>
          colorOrder.indexOf(a.key).compareTo(colorOrder.indexOf(b.key)));

    return sortedEntries
        .expand((entry) => [
              if (entry.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: BorderSide.strokeAlignCenter),
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
                          icon: const Icon(Icons.check_circle_outline_outlined,
                              color: Colors.black),
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
                        ],
                      ),
                    ),
                  )),
            ])
        .toList();
  }
}
