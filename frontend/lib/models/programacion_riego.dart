class ProgramacionRiego {
  final int id;
  final String? inicio;
  final int? duracion;
  final bool activo;
  final int? numero_lotes;

  ProgramacionRiego({
    required this.id,
    required this.inicio,
    required this.duracion,
    required this.activo,
    this.numero_lotes,
  });

  factory ProgramacionRiego.fromJson(Map<String, dynamic> json) {
    return ProgramacionRiego(
      id: json['id'],
      inicio: json['inicio'],
      duracion: json['duracion'],
      activo: json['activo'],
      numero_lotes: json['numero_lotes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inicio': inicio,
      'duracion': duracion,
      'activo': activo,
      'numero_lotes': numero_lotes,
    };
  }
}
