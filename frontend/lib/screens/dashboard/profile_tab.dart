import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Columna principal (izquierda)
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Información de la finca
                Expanded(
                  flex: 1, // mismo tamaño que la sección de mapa
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.maps_home_work_sharp, color: colors.onSurface, size: 50),
                          SizedBox(height: 20),
                          Text(
                            'Nombre de la finca o predio:',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: 30),
                          Text(
                            'Tipo de cultivo(s) registrados: Granos,',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: 30),
                          Text(
                            'Tamaño del área cubierta por aspersores:',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: 30),
                          Text(
                            'Zonas configuradas:',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: 30),
                          Text(
                            'Texto adicional para probar el scroll...',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: 30),
                          Text(
                            'Más texto de ejemplo...',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Sección de mapa
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ubicación de la finca o predio',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 15),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  'assets/icon/app_logo.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 270,
                                ),
                              ),
                            ),
                          ),
                          // Puedes añadir más widgets aquí si quieres que sean scrolleables
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(width: 60),

          Center(
            child: Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(70),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 120,
                        backgroundColor: colors.surface,
                        backgroundImage: AssetImage('assets/icon/profile.png'),
                      ),
                      SizedBox(height: 70),
                      Text('Nombres', style: Theme.of(context).textTheme.bodyLarge),
                      Text('Neider', style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: 10),
                      Text('Apellidos', style: Theme.of(context).textTheme.bodyLarge),
                      Text('Ramirez', style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: 10),
                      Text('Teléfono de contacto', style: Theme.of(context).textTheme.bodyLarge),
                      Text('3115331270', style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: 10),
                      Text('Correo Electrónico', style: Theme.of(context).textTheme.bodyLarge),
                      Text(
                        'neider.ramirezdelgadillo@gmail.com',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text('Dirección', style: Theme.of(context).textTheme.bodyLarge),
                      Text('Calle 22 sur # 56-27', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                )
              ),
            ),
          ),// Columna lateral (derecha)
          const SizedBox(width: 20)
        ],
      ),
    );
  }
}
