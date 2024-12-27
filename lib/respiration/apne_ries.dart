// Este modelo quedó cancelado por temas de tiempo y recursos.
// Aún así, se dejó el código para futuras implementaciones.

import 'dart:io';
import 'dart:math';
import 'package:csv/csv.dart';

class LogisticRegressionModel {
  late List<double> weights;
  final double learningRate;
  final int epochs;
  final double convergenceThreshold;

  LogisticRegressionModel({
    this.learningRate = 0.001,
    this.epochs = 10000,
    this.convergenceThreshold = 0.00001,
  });

  double sigmoid(double x) {
    return 1.0 / (1.0 + exp(-x));
  }

  void fit(List<List<double>> X, List<double> y) {
    final numFeatures = X[0].length;
    weights = List.filled(numFeatures + 1, 0.0); // +1 para el bias
    final random = Random();

    for (var i = 0; i < weights.length; i++) {
      weights[i] = random.nextDouble() * 0.01;
    }

    for (var epoch = 0; epoch < epochs; epoch++) {
      var totalError = 0.0;

      for (var i = 0; i < X.length; i++) {
        final features = [1.0, ...X[i]];

        var prediction = 0.0;
        for (var j = 0; j < weights.length; j++) {
          prediction += weights[j] * features[j];
        }
        prediction = sigmoid(prediction);

        final error = y[i] - prediction;
        totalError += error.abs();

        for (var j = 0; j < weights.length; j++) {
          weights[j] += learningRate * error * features[j];
        }
      }

      if (totalError / X.length < convergenceThreshold) {
        print('Convergió en la época $epoch');
        break;
      }
    }
  }

  double predict(List<double> features) {
    final featuresWithBias = [1.0, ...features];
    var prediction = 0.0;
    for (var i = 0; i < weights.length; i++) {
      prediction += weights[i] * featuresWithBias[i];
    }
    return sigmoid(prediction);
  }
}

Future<void> ApneRies() async {
  final file =
      File('assets/respiration/Sleep_health_and_lifestyle_dataset.csv');
  final csvData = await file.readAsString();
  final rows = const CsvToListConverter().convert(csvData);

  final headers = rows.first.cast<String>();
  final data = rows.sublist(1);

  final categoryMaps = {
    'Gender': {'Male': 0, 'Female': 1},
    'BMI Category': {'Normal': 0, 'Overweight': 1, 'Obese': 2},
    'Blood Pressure': {'Normal': 0, 'High': 1},
  };

  final featureColumns = {
    'Age': false,
    'Sleep Duration': false,
    'Quality of Sleep': true,
    'Physical Activity Level': false,
    'Stress Level': false,
    'Heart Rate': false,
    'Daily Steps': false,
    'Gender': true,
    'BMI Category': true,
    'Blood Pressure': false,
  };

  final List<List<double>> X = [];
  final List<double> y = [];

  for (final row in data) {
    final List<double> features = [];

    for (final entry in featureColumns.entries) {
      final columnIndex = headers.indexOf(entry.key);
      final value = row[columnIndex];

      if (entry.value) {
        // Codificación manual de categorías
        features.add((categoryMaps[entry.key]?[value] ?? 0.0).toDouble());
      } else {
        // Asegurarse de que el valor sea un double válido
        if (value is String) {
          features.add(
              double.tryParse(value) ?? 0.0); // Convierte la cadena a double
        } else if (value is num) {
          features.add(value.toDouble()); // Asegura que el valor es un double
        }
      }
    }

    X.add(features);

    final targetIndex = headers.indexOf('Sleep Disorder');
    final targetValue = row[targetIndex].toString();
    y.add(targetValue == 'Sleep Apnea' ? 1.0 : 0.0);
  }

  // Normalización
  for (var j = 0; j < X[0].length; j++) {
    var min = double.infinity;
    var max = double.negativeInfinity;

    for (var i = 0; i < X.length; i++) {
      min = min > X[i][j] ? X[i][j] : min;
      max = max < X[i][j] ? X[i][j] : max;
    }

    if (max > min) {
      for (var i = 0; i < X.length; i++) {
        X[i][j] = (X[i][j] - min) / (max - min);
      }
    }
  }

  final model = LogisticRegressionModel(
    learningRate: 0.001,
    epochs: 10000,
    convergenceThreshold: 0.00001,
  );

  model.fit(X, y);

  double predictNew(Map<String, dynamic> patientData) {
    final List<double> features = [];
    for (final entry in featureColumns.entries) {
      final value = patientData[entry.key];
      if (entry.value) {
        features.add((categoryMaps[entry.key]?[value] ?? 0.0).toDouble());
      } else {
        features.add(double.parse(value.toString()));
      }
    }
    return model.predict(features);
  }

  final patientData = {
    'Gender': 'Male',
    'Age': '28',
    'Sleep Duration': '6.2',
    'Quality of Sleep': '9',
    'Physical Activity Level': '80',
    'Stress Level': '8',
    'BMI Category': 'Normal',
    'Blood Pressure': '125/80',
    'Heart Rate': '90',
    'Daily Steps': '10000',
  };

  final probability = predictNew(patientData);
  print(
      'Probabilidad de apnea del sueño: ${(probability * 100).toStringAsFixed(2)}%');
}
