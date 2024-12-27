import 'package:ml_algo/ml_algo.dart';
import 'package:ml_dataframe/ml_dataframe.dart';

void main() {
  // Datos de entrenamiento: Cada fila representa un paciente y sus factores de riesgo.
  final data = [
    [
      'sobrepeso',
      'edadAvanzada',
      'viasRespiratoriasEstrechas',
      'hipertension',
      'consumoAlcohol',
      'usoSedantes',
      'antecedentesFamiliares',
      'riesgoApnea'
    ],
    [1, 1, 1, 1, 0, 0, 1, 1], // Paciente con riesgo alto
    [0, 0, 0, 0, 0, 0, 0, 0], // Paciente con riesgo bajo
    [1, 0, 1, 1, 1, 0, 0, 1], // Paciente con riesgo alto
    [0, 1, 0, 0, 0, 0, 1, 0], // Paciente con riesgo bajo
    [1, 1, 1, 0, 1, 1, 1, 1], // Paciente con riesgo alto
  ];

  // Crear un DataFrame para entrenar el modelo.
  final dataframe = DataFrame(data, headerExists: true);

  // Entrenamos un modelo de Regresión Logística para clasificación binaria.
  final model = LogisticRegressor(
    dataframe,
    'riesgoApnea', // La columna objetivo.
    optimizerType:
        LinearOptimizerType.gradient, // Optimizador para ajustar pesos.
  );

  // Nueva entrada: Paciente con datos específicos.
  final nuevaEntrada = DataFrame([
    [1, 0, 0, 1, 0, 0, 1], // Nuevo paciente con factores de riesgo.
  ], header: [
    'sobrepeso',
    'edadAvanzada',
    'viasRespiratoriasEstrechas',
    'hipertension',
    'consumoAlcohol',
    'usoSedantes',
    'antecedentesFamiliares',
  ]);

  // Predicción del modelo.
  final resultado = model.predict(nuevaEntrada);

  print('Predicción de riesgo de apnea del sueño: ${resultado.rows}');
}
