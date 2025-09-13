import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantiq/models/cultivo.dart';
import '../constants.dart';
import '../models/riegos.dart';

class ApiService {
  static Future<http.Response> registerUser(
    String firstName,
    String lastName,
    String email,
    String password,
    String password2,
  ) {
    return http.post(
      Uri.parse(registerEndpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "password2": password2,
      }),
    );
  }

  static Future<http.Response> loginUser(String email, String password) {
    return http.post(
      Uri.parse(loginEndpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
  }

  /// 🔹 Obtener lista de cultivos
  static Future<List<Cultivo>> getCultivos() async {
    final response = await http.get(Uri.parse('$baseUrl/api/cultivos/'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Cultivo.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar cultivos');
    }
  }

   static Future<List<Cultivo1>> getCultivos1() async {
    final response = await http.get(Uri.parse('$baseUrl/api/cultivos/'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Cultivo1.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar cultivos');
    }
  }

  /// 🔹 Crear un cultivo nuevo
  static Future<Cultivo> crearCultivo({
    required String nombre,
    required String tipo,
    required int? numero_lotes,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/cultivos/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"nombre_cultivo": nombre, "tipo_cultivo": tipo, "numero_lotes": numero_lotes}),
    );

    if (response.statusCode == 201) {
      return Cultivo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error al crear cultivo: ${response.body}");
    }
  }

  /// 🔹 Editar riego
  static Future<void> editarProgramacionRiego(Riego riego) async {
    final response = await http.put(
      Uri.parse('$baseUrl/programacion_riego_admin/${riego.id}/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(riego.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al editar riego');
    }
  }

  /// 🔹 Eliminar riego
  static Future<void> eliminarProgramacionRiego(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/programacion_riego_admin/$id/'),
    );
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar riego');
    }
  }

  static Future<bool> createRiego(
    int cultivo,
    String inicio,
    int duracion,
  ) async {
    final response = await http.post(
      Uri.parse(riegosEndpoint),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "cultivo": cultivo,
        "inicio": inicio,
        "duracion": duracion,
        "activo": true,
      }),
    );

    return response.statusCode == 201;
  }
}
