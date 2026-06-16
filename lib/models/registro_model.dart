import 'dart:convert';

class Registro {
  final int? id;
  final String titulo;
  final String descripcion;
  final String fecha;
  final String responsable;

  Registro({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.responsable,
  });

  // Convertir un JSON del Backend a un Objeto de Dart
  factory Registro.fromJson(Map<String, dynamic> json) {
    return Registro(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      fecha: json['fecha'],
      responsable: json['responsable'],
    );
  }

  // Convertir un Objeto de Dart a un JSON para mandarlo al Backend
  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha': fecha,
      'responsable': responsable,
    };
  }
}