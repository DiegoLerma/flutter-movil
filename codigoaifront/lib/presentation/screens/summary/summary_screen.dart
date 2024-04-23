import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  SummaryScreenState createState() => SummaryScreenState();
}

class SummaryScreenState extends State<SummaryScreen> {
  final TextEditingController _dateController = TextEditingController();
  String _summaries =
      "Por favor, seleccione una fecha para cargar los resúmenes.";
  final Dio _dio = Dio(); // Instancia de Dio

  // Método para abrir el selector de fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != DateTime.now()) {
      _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      _fetchSummaries(); // Cargar resúmenes automáticamente al seleccionar la fecha
    }
  }

  // Método para obtener los resúmenes médicos de la fecha especificada usando Dio
  Future<void> _fetchSummaries() async {
    if (_dateController.text.isEmpty) {
      return;
    }
    try {
      final response = await _dio
          .get('http://codigoai.azurewebsites.net/${_dateController.text}/');
      setState(() {
        _summaries = response.data.toString();
      });
    } catch (e) {
      setState(() {
        _summaries = "Error al obtener los datos: $e";
      });
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
          children: <Widget>[
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
                keyboardType: TextInputType.number,
                onSubmitted: (_) =>
                    _fetchSummaries(), // Cargar resúmenes al presionar Enter
              ),
            ),
            ElevatedButton(
              onPressed: _fetchSummaries,
              child: const Text('Cargar Resúmenes'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_summaries),
            ),
          ],
        ),
      ),
    );
  }
}
