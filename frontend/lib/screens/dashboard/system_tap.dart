import 'package:flutter/material.dart';
import 'package:plantiq/services/api_service.dart';
import 'package:plantiq/models/cultivo.dart'; // 👈 para manejar el modelo

class SystemTap extends StatefulWidget {
  @override
  _SystemTapState createState() => _SystemTapState();
}

class _SystemTapState extends State<SystemTap> {
  final TextEditingController nombreCultivoController = TextEditingController();
  final TextEditingController tipoCultivoController = TextEditingController();
  final TextEditingController inicioRiegoController = TextEditingController();
  final TextEditingController duracionRiegoController = TextEditingController();

  int? numeroLotes;
  int? numeroAspersoresPorLote;

  @override
  void dispose() {
    nombreCultivoController.dispose();
    tipoCultivoController.dispose();
    inicioRiegoController.dispose();
    duracionRiegoController.dispose();
    super.dispose();
  }

  /// 🔹 Guardar datos y enviar al backend
  Future<void> guardarDatos() async {
    String nombre = nombreCultivoController.text.trim();
    String tipo = tipoCultivoController.text.trim();
    String inicioRiego = inicioRiegoController.text.trim();
    String duracionRiego = duracionRiegoController.text.trim();

    if (nombre.isEmpty || tipo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos obligatorios'),
        ),
      );
      return;
    }

    try {
      // 👇 Llamamos al service
      final cultivo = await ApiService.crearCultivo(nombre: nombre, tipo: tipo);

      // Solo guardamos nombre/tipo en DRF (porque tu modelo Cultivo no tiene lotes/aspersores aún)
      print(
        '✅ Cultivo creado en backend: ${cultivo.nombreCultivo} (${cultivo.tipoCultivo})',
      );
      print('Número de lotes: $numeroLotes');
      print('Número de aspersores por lote: $numeroAspersoresPorLote');
      print('Inicio de riego: $inicioRiego');
      print('Duración de riego: $duracionRiego');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cultivo "${cultivo.nombreCultivo}" guardado correctamente ✅',
          ),
        ),
      );

      // limpiar formulario
      nombreCultivoController.clear();
      tipoCultivoController.clear();
      inicioRiegoController.clear();
      duracionRiegoController.clear();
      setState(() {
        numeroLotes = null;
        numeroAspersoresPorLote = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.background,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 124, right: 124),
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 🔹 Bloque cultivo
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Registro de Cultivos",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 17),
                              TextField(
                                controller: nombreCultivoController,
                                style: TextStyle(color: colors.tertiary),
                                cursorColor: colors.tertiary,
                                decoration: const InputDecoration(
                                  labelText: "Nombre Cultivo",
                                  prefixIcon: Icon(Icons.grass),
                                ),
                              ),
                              const SizedBox(height: 13),
                              TextField(
                                controller: tipoCultivoController,
                                style: TextStyle(color: colors.tertiary),
                                cursorColor: colors.tertiary,
                                decoration: const InputDecoration(
                                  labelText: "Tipo de cultivo",
                                  prefixIcon: Icon(Icons.eco),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),

                        // 🔹 Bloque lotes/riego
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Registro de lotes del cultivo",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 17),
                              DropdownButtonFormField<int>(
                                decoration: const InputDecoration(
                                  labelText: "Número de lotes",
                                  prefixIcon: Icon(Icons.numbers),
                                ),
                                dropdownColor: colors.background,
                                style: TextStyle(color: colors.tertiary),
                                items: List.generate(10, (index) => index + 1)
                                    .map(
                                      (e) => DropdownMenuItem<int>(
                                        value: e,
                                        child: Text(e.toString()),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    numeroLotes = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              DropdownButtonFormField<int>(
                                decoration: const InputDecoration(
                                  labelText: "Número de aspersores por lote",
                                  prefixIcon: Icon(Icons.numbers),
                                ),
                                dropdownColor: colors.background,
                                style: TextStyle(color: colors.tertiary),
                                items: List.generate(10, (index) => index + 1)
                                    .map(
                                      (e) => DropdownMenuItem<int>(
                                        value: e,
                                        child: Text(e.toString()),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    numeroAspersoresPorLote = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: inicioRiegoController,
                                style: TextStyle(color: colors.tertiary),
                                cursorColor: colors.tertiary,
                                decoration: const InputDecoration(
                                  labelText: "Inicio de riego",
                                  prefixIcon: Icon(Icons.timer),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: duracionRiegoController,
                                style: TextStyle(color: colors.tertiary),
                                cursorColor: colors.tertiary,
                                decoration: const InputDecoration(
                                  labelText: "Duración de riego",
                                  prefixIcon: Icon(Icons.access_time),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: guardarDatos,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colors.primary,
                                  foregroundColor: colors.onPrimary,
                                  minimumSize: const Size(double.infinity, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                ),
                                child: Text(
                                  'Guardar',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
