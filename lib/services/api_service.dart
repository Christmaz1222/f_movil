import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/registro_model.dart';

class ApiService {
  // Cambiar por 'localhost' si prueban en Web o la IP de su red si es celular físico
  static const String baseUrl = 'http://localhost:3000/registros';

  // 1. GET - Obtener todos los registros desde MySQL
  Future<List<Registro>> obtenerRegistros() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => Registro.fromJson(item)).toList();
      } else {
        throw Exception('Fallo al cargar registros');
      }
    } catch (e) {
      print("Error en GET: $e");
      return [];
    }
  }

  // 2. POST - Enviar un nuevo registro al Backend
  Future<bool> crearRegistro(Registro nuevoRegistro) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(nuevoRegistro.toJson()),
      );

      return response.statusCode == 201; // True si NestJS responde Created
    } catch (e) {
      print("Error en POST: $e");
      return false;
    }
  }
}