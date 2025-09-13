import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/cultivo.dart'; // Asegúrate de importar Cultivo1
import '../../models/riegos.dart';
import '../../services/api_service.dart';

class StatisticsTab extends StatefulWidget {
  const StatisticsTab({super.key});

  @override
  State<StatisticsTab> createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab> {
  late Future<List<Cultivo1>> futureCultivos;
  Cultivo1? selectedCultivo;
  String chartType = 'line';

  @override
  void initState() {
    super.initState();
    futureCultivos = ApiService.getCultivos1();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      body: FutureBuilder<List<Cultivo1>>(
        future: futureCultivos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: colors.tertiary),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay lotes disponibles'));
          }
          final cultivos = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Selección de lote y tipo de gráfica
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Cultivo1>(
                            isExpanded: true,
                            hint: Text(
                              'Seleccione un cultivo',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            dropdownColor: colors.surface,
                            style: Theme.of(context).textTheme.bodyLarge,
                            value: selectedCultivo,
                            items: cultivos.map((c) {
                              return DropdownMenuItem<Cultivo1>(
                                value: c,
                                child: Text(c.nombreCultivo),
                              );
                            }).toList(),
                            onChanged: (c) {
                              setState(() {
                                selectedCultivo = c;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: chartType,
                            isExpanded: true,
                            dropdownColor: colors.surface,
                            style: Theme.of(context).textTheme.bodyLarge,
                            items: const [
                              DropdownMenuItem(
                                value: 'line',
                                child: Text('Líneas'),
                              ),
                              DropdownMenuItem(
                                value: 'bar',
                                child: Text('Barras'),
                              ),
                              DropdownMenuItem(
                                value: 'radialBar',
                                child: Text('Radial'),
                              ),
                            ],
                            onChanged: (v) {
                              setState(() {
                                chartType = v ?? 'line';
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Instrucción si no hay lote seleccionado
                if (selectedCultivo == null)
                  Expanded(
                    child: Center(
                      child: Text(
                        'Selecciona un lote para ver sus gráficas',
                        style: TextStyle(color: colors.tertiary),
                      ),
                    ),
                  )
                else
                  Expanded(child: _buildCharts(selectedCultivo!)),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ElevatedButton(
                    onPressed: selectedCultivo != null
                        ? () {
                            print(
                              "Activando sistema para lote: ${selectedCultivo!.nombreCultivo}",
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Activar",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Ejemplo gráfica radial para un riego
  Widget buildRadialBarChart(Riego riego, {required bool isPh}) {
    final maxValue = isPh ? 14.0 : 100.0;
    final value = isPh ? (riego.ph ?? 0) : (riego.humedad ?? 0);
    return SizedBox(
      width: 100,
      height: 250,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 35,
          sectionsSpace: 3,
          sections: [
            PieChartSectionData(
              value: value.toDouble(),
              color: isPh ? Colors.greenAccent : Colors.blueAccent,
              radius: 55,
              title: value.toStringAsFixed(1),
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            PieChartSectionData(
              value: maxValue - value.toDouble(),
              color: Colors.grey.shade800,
              radius: 55,
              title: '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharts(Cultivo1 cultivo) {
    final riegosToShow = cultivo.programaciones;

    if (chartType == 'radialBar') {
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: riegosToShow.length,
        itemBuilder: (context, index) {
          final riego = riegosToShow[index];
          final colors = Theme.of(context).colorScheme;
          return Card(
            color: colors.surface,
            margin: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Riego ${riego.nombre ?? 'Sin nombre'}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Humedad',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 8),
                            buildRadialBarChart(riego, isPh: false),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Temperatura',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 8),
                            buildRadialBarChart(riego, isPh: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    // Para líneas o barras
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: riegosToShow.length,
      itemBuilder: (context, index) {
        final riego = riegosToShow[index];
        final colors = Theme.of(context).colorScheme;
        return Card(
          color: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Humedad', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(
                  height: 250,
                  child: chartType == 'bar'
                      ? BarChart(
                          BarChartData(
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY: riego.humedad?.toDouble() ?? 0,
                                    width: 16,
                                    color: Colors.blueAccent,
                                  ),
                                ],
                              ),
                            ],
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                          ),
                        )
                      : LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: [FlSpot(0, riego.humedad?.toDouble() ?? 0)],
                                isCurved: true,
                                color: Colors.blueAccent,
                                barWidth: 3,
                                dotData: FlDotData(show: true),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.blueAccent.withOpacity(0.3),
                                ),
                              ),
                            ],
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                            ),
                            gridData: FlGridData(show: true),
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                Text('Temperatura', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(
                  height: 250,
                  child: chartType == 'bar'
                      ? BarChart(
                          BarChartData(
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY: riego.ph?.toDouble() ?? 0,
                                    width: 16,
                                    color: Colors.greenAccent,
                                  ),
                                ],
                              ),
                            ],
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                          ),
                        )
                      : LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: [FlSpot(0, riego.ph?.toDouble() ?? 0)],
                                isCurved: true,
                                color: Colors.greenAccent,
                                barWidth: 3,
                                dotData: FlDotData(show: true),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.greenAccent.withOpacity(0.2),
                                ),
                              ),
                            ],
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                            ),
                            gridData: FlGridData(show: true),
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
