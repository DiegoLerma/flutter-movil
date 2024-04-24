import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

// To parse this JSON data, do
//
//     final summary = summaryFromJson(jsonString);

List<Summary> summaryFromJson(String str) =>
    List<Summary>.from(json.decode(str).map((x) => Summary.fromJson(x)));

String summaryToJson(List<Summary> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Summary {
  final String title;
  final SummaryContent content;

  Summary({
    required this.title,
    required this.content,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      title: json["title"] as String,
      content: SummaryContent.fromJson(json["content"] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content.toJson(),
      };
}

class SummaryContent {
  final String id;
  final ContentContent content;
  final bool attended;
  final bool goneWithoutAttention;
  final String colorDeTriage;

  SummaryContent({
    required this.id,
    required this.content,
    required this.attended,
    required this.goneWithoutAttention,
    required this.colorDeTriage,
  });

  factory SummaryContent.fromJson(Map<String, dynamic> json) => SummaryContent(
        id: json["id"],
        content: ContentContent.fromJson(json["content"]),
        attended: json["attended"],
        goneWithoutAttention: json["gone_without_attention"],
        colorDeTriage: json["color_de_triage"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content.toJson(),
        "attended": attended,
        "gone_without_attention": goneWithoutAttention,
      };
}

class ContentContent {
  final String colorDeTriage;
  final String fecha;
  final String nombre;
  final String sexo;
  final String edad;
  final String motivoDeConsulta;
  final String resumen;
  final List<ConversacionCompleta> conversacionCompleta;

  ContentContent({
    required this.colorDeTriage,
    required this.fecha,
    required this.nombre,
    required this.sexo,
    required this.edad,
    required this.motivoDeConsulta,
    required this.resumen,
    required this.conversacionCompleta,
  });

  // Método para convertir la conversación completa en un string de Markdown
  String get formattedConversation {
    return conversacionCompleta
        .map((msg) => '**${msg.rol}**: ${msg.contenido}\n\n')
        .join();
  }

  factory ContentContent.fromJson(Map<String, dynamic> json) {
    DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateFormat outputFormat = DateFormat("dd-MM-yyyy");

    DateTime date = inputFormat.parse(json["fecha"]);
    String formattedDate = outputFormat.format(date);

    return ContentContent(
      colorDeTriage: json["color_de_triage"],
      fecha: formattedDate, // Usar fecha formateada
      nombre: json["nombre"],
      sexo: json["sexo"],
      edad: json["edad"],
      motivoDeConsulta: json["motivo_de_consulta"],
      resumen: json["resumen"],
      conversacionCompleta: List<ConversacionCompleta>.from(
          json["conversacion_completa"]
              .map((x) => ConversacionCompleta.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "color_de_triage": colorDeTriage,
        "fecha": fecha,
        "nombre": nombre,
        "sexo": sexo,
        "edad": edad,
        "motivo_de_consulta": motivoDeConsulta,
        "resumen": resumen,
        "conversacion_completa":
            List<dynamic>.from(conversacionCompleta.map((x) => x.toJson())),
      };

  Color get color => colorFromTriage(colorDeTriage);

  static Color colorFromTriage(String color) {
    switch (color.toLowerCase()) {
      case 'rojo':
        return Colors.redAccent.shade100;
      case 'naranja':
        return Colors.orangeAccent.shade100;
      case 'amarillo':
        return Colors.yellowAccent.shade100;
      case 'verde':
        return Colors.greenAccent.shade100;
      default:
        return Colors.grey.shade300;
    }
  }
}

class ConversacionCompleta {
  final String rol;
  final String contenido;

  ConversacionCompleta({
    required this.rol,
    required this.contenido,
  });

  factory ConversacionCompleta.fromJson(Map<String, dynamic> json) =>
      ConversacionCompleta(
        rol: json["rol"],
        contenido: json["contenido"],
      );

  Map<String, dynamic> toJson() => {
        "rol": rol,
        "contenido": contenido,
      };
}

class TriageUtils {
  static Color colorFromTriage(String color) {
    switch (color.toLowerCase()) {
      case 'rojo':
        return Colors.redAccent.shade100;
      case 'naranja':
        return Colors.orangeAccent.shade100;
      case 'amarillo':
        return Colors.yellowAccent.shade100;
      case 'verde':
        return Colors.greenAccent.shade100;
      default:
        return Colors.grey.shade300;
    }
  }
}
