class Riego {
  final int id;
  final String nombre;
  final DateTime fecha;
  final double cantidadAgua; // Cantidad de agua usada en litros
  final String descripcion;
  final int loteId;

  final double ph; // pH del suelo o agua en el riego
  final double humedad; // Humedad medida en porcentaje o unidad similar

  Riego({
    required this.id,
    required this.nombre,
    required this.fecha,
    required this.cantidadAgua,
    required this.descripcion,
    required this.loteId,
    required this.ph,
    required this.humedad,
  });

  // Convertir de JSON (desde API)
  factory Riego.fromJson(Map<String, dynamic> json) {
    return Riego(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      cantidadAgua: (json['cantidad_agua'] as num).toDouble(),
      descripcion: json['descripcion'] ?? '',
      loteId: json['lote_id'] as int,
      ph: (json['ph'] as num).toDouble(),
      humedad: (json['humedad'] as num).toDouble(),
    );
  }

  // Convertir a JSON (para enviar a API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'fecha': fecha.toIso8601String(),
      'cantidad_agua': cantidadAgua,
      'descripcion': descripcion,
      'lote_id': loteId,
      'ph': ph,
      'humedad': humedad,
    };
  }
}
