import 'package:flutter/material.dart';
import 'dart:convert';

// To parse this JSON data, do
//     final summary = summaryFromJson(jsonData);
List<Summary> summaryFromJson(List<dynamic> jsonData) {
  return List<Summary>.from(
      jsonData.map((x) => Summary.fromJson(x as Map<String, dynamic>)));
}

String summaryToJson(List<Summary> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Summary {
  final String title;
  final Content content;

  Summary({required this.title, required this.content});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      title: json['title'] as String? ?? '',
      content: Content.fromJson(json['content'] as Map<String, dynamic>),
    );
  }
  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content.toJson(),
      };
}

class Content {
  final String id;
  final ContentDetails contentDetails;
  final bool attended;
  final bool goneWithoutAttention;
  final String colorDeTriage;

  Content({
    required this.id,
    required this.contentDetails,
    required this.attended,
    required this.goneWithoutAttention,
    required this.colorDeTriage,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'] as String? ?? '',
      contentDetails:
          ContentDetails.fromJson(json['content'] as Map<String, dynamic>),
      attended: json['attended'] as bool? ?? false,
      goneWithoutAttention: json['gone_without_attention'] as bool? ?? false,
      colorDeTriage: json['color_de_triage'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": contentDetails
            .toJson(), // Asegúrate de que contentDetails también tenga un método toJson()
        "attended": attended,
        "gone_without_attention": goneWithoutAttention,
        "color_de_triage":
            colorDeTriage, // Incluye este campo para mantener consistencia con el formato JSON.
      };
}

class ContentDetails {
  final String colorDeTriage;
  final String fecha;
  final String nombre;
  final String sexo;
  final String edad;
  final String motivoDeConsulta;
  final String resumen;
  final List<Conversation> conversacionCompleta;

  ContentDetails({
    required this.colorDeTriage,
    required this.fecha,
    required this.nombre,
    required this.sexo,
    required this.edad,
    required this.motivoDeConsulta,
    required this.resumen,
    required this.conversacionCompleta,
  });

  factory ContentDetails.fromJson(Map<String, dynamic> json) {
    return ContentDetails(
      colorDeTriage: json['color_de_triage'] as String? ?? 'Desconocido',
      fecha: json['fecha'] as String? ?? 'Fecha desconocida',
      nombre: json['nombre'] as String? ?? 'Nombre desconocido',
      sexo: json['sexo'] as String? ?? 'Sexo desconocido',
      edad: json['edad'] as String? ?? 'Edad desconocida',
      motivoDeConsulta:
          json['motivo_de_consulta'] as String? ?? 'Motivo desconocido',
      resumen: json['resumen'] as String? ?? 'Sin resumen',
      conversacionCompleta:
          (json['conversacion_completa'] as List<dynamic>? ?? [])
              .map((x) => Conversation.fromJson(x as Map<String, dynamic>))
              .toList(),
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

  String get formattedConversation {
    String formatted = '';
    for (var conversation in conversacionCompleta) {
      formatted += '**${conversation.rol}:** ${conversation.contenido}\n\n';
    }
    return formatted;
  }

  Color get color => TriageUtils.colorFromTriage(colorDeTriage);
}

class Conversation {
  final String rol;
  final String contenido;

  Conversation({required this.rol, required this.contenido});

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        rol: json['rol'] as String? ?? '',
        contenido: json['contenido'] as String? ?? '',
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
