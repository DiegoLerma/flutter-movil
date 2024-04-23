import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:yes_no/config/theme/app_theme.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  SummaryScreenState createState() => SummaryScreenState();
}

class Summary {
  final String title;
  final String content;

  Summary({required this.title, required this.content});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      title: json['title'],
      content: json['content'],
    );
  }
}

class SummaryScreenState extends State<SummaryScreen> {
  final TextEditingController _dateController = TextEditingController();
  List<Summary> _summaries = [];
  final Dio _dio = Dio();

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
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;
        setState(() {
          _summaries =
              responseData.map((data) => Summary.fromJson(data)).toList();
        });
      } else {
        throw Exception(
            'Failed to load summaries with status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _summaries = [];
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al obtener los datos: $e')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Resúmenes Médicos")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Ingrese la fecha (DD-MM-YYYY)',
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
            ..._summaries.map((summary) => ExpansionTile(
                  backgroundColor: Colors.amber,
                  title: Text(summary.title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: MarkdownBody(data: summary.content),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
