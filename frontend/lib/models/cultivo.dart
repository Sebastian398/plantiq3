import '../models/riegos.dart';

class Cultivo {
  final int id;
  final String nombreCultivo;
  final String tipoCultivo;
  final List<Riego> programaciones;

  // El token debe manejarse externamente, no como propiedad de instancia
  static const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1NzYwMzgzMCwiaWF0IjoxNzU3NTE3NDMwLCJqdGkiOiI0MzA4YWQyMTM3YjY0ZTI1ODgyYzE0MWZkYjE3YmIxYiIsInVzZXJfaWQiOiIxIn0.YTpGkjoeSw744gdYgQYyj2NznCV9TumxeJVT72pLGew";

  Cultivo({
    required this.id,
    required this.nombreCultivo,
    required this.tipoCultivo,
    List<Riego>? programaciones,
  }) : programaciones = programaciones ?? [];

  factory Cultivo.fromJson(Map<String, dynamic> json) {
    return Cultivo(
      id: json['id'] as int,
      nombreCultivo: json['nombre_cultivo'] as String,
      tipoCultivo: json['tipo_cultivo'] as String,
      programaciones: (json['programaciones'] as List<dynamic>?)
              ?.map((r) => Riego.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
