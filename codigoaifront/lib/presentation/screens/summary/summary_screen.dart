import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:yes_no/domain/entities/summary.dart';
import 'package:yes_no/config/helpers/api_service.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  SummaryScreenState createState() => SummaryScreenState();
}

class SummaryScreenState extends State<SummaryScreen> {
  final TextEditingController _dateController = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  Map<String, List<Summary>> summariesByColor = {};
  final Dio _dio = Dio();
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(_dio); // Initialize the API service
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != DateTime.now()) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      _dateController.text = formattedDate;
      _fetchSummaries();
    }
  }

  Future<void> _fetchSummaries() async {
    if (_dateController.text.isEmpty) {
      return;
    }
    try {
      final url =
          'https://codigoai.azurewebsites.net/med_summaries/${_dateController.text}';
      final response = await _dio.get(url);
      print(response.data);

      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data ?? [];
        var summaries = responseData
            .where((data) =>
                data['attended'] == false) // Filtrar solo no atendidos
            .map((data) => Summary.fromJson(data as Map<String, dynamic>))
            .toList();
        if (responseData.isEmpty) {
          // Verifica si el widget aún está montado antes de interactuar con el context
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('No existen registros para ese día')));
            setState(() {
              summariesByColor = {};
            });
          }
          return;
        }

        summariesByColor = {
          'Rojo': [],
          'Naranja': [],
          'Amarillo': [],
          'Verde': []
        };
        for (var summary in summaries) {
          var triageColorKey = summary.content.colorDeTriage
              .toLowerCase(); // asegúrate de manejar las claves consistentemente en minúsculas
          if (summariesByColor.containsKey(triageColorKey)) {
            summariesByColor[triageColorKey]?.add(summary);
          } else {
            summariesByColor[triageColorKey] = [
              summary
            ]; // Crea una nueva entrada si la clave no existe
          }
        }
        if (mounted) {
          setState(() {
            // Esto actualizará la UI con los nuevos summaries agrupados por color
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
        title: const Text("Resúmenes Médicos"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Ingrese la fecha',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                keyboardType: TextInputType.datetime,
                onSubmitted: (_) => _fetchSummaries(),
              ),
            ),
            ElevatedButton(
              onPressed: _fetchSummaries,
              child: const Text('Cargar Resúmenes'),
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
