import 'dart:math';

class GlucPrev {
  static const double carbohydrateFactor = 0.1; // Cambiado a lowerCamelCase
  static const double resistanceFactor = 1.0; // Cambiado a lowerCamelCase
  static const double tygThreshold = 4.5; // Cambiado a lowerCamelCase

  final double triglycerides;
  final double fastingGluc;
  final double currentGluc;
  final double carbsConsumed;

  late final double _tyGIndex;
  late final double _insulinResistance;
  late final double _futureGluc;

  GlucPrev({
    required this.triglycerides,
    required this.fastingGluc,
    required this.currentGluc,
    required this.carbsConsumed,
  }) {
    _tyGIndex = _calculateTyG(triglycerides, fastingGluc);
    _insulinResistance = _tyGIndex;
    _futureGluc = _calculateFutureGluc(currentGluc, carbsConsumed);
  }

  /// Calculates the TyG index based on triglycerides and fasting glucose.
  double _calculateTyG(double triglycerides, double glucose) {
    if (triglycerides <= 0 || glucose <= 0) {
      throw ArgumentError('Values must be greater than zero');
    }
    return log(triglycerides / 2) + log(glucose / 2);
  }

  /// Predicts future glucose levels based on current glucose and carbs consumed.
  double _calculateFutureGluc(double currentGluc, double carbs) {
    double carbImpact = carbs * carbohydrateFactor; // Actualización aquí
    double resistanceAdjustment =
        _insulinResistance * resistanceFactor; // Actualización aquí

    return currentGluc + carbImpact - resistanceAdjustment;
  }

  /// Interprets the TyG index risk level.
  String interpretTyG() {
    return _tyGIndex > tygThreshold
        ? 'Elevated risk of insulin resistance'
        : 'Normal risk of insulin resistance';
  }

  /// Exposes the calculated TyG index.
  double get tyGIndex => _tyGIndex;

  /// Exposes the insulin resistance value.
  double get insulinResistance => _insulinResistance;

  /// Exposes the predicted future glucose level.
  double get futureGluc => _futureGluc;
}

/// Example usage of GlucPrev
void main() {
  try {
    final glucPrev = GlucPrev(
      triglycerides: 150.0, // mg/dL
      fastingGluc: 90.0, // mg/dL
      currentGluc: 110.0, // mg/dL
      carbsConsumed: 50.0, // grams
    );

    print('TyG Index: ${glucPrev.tyGIndex.toStringAsFixed(2)}');
    print(glucPrev.interpretTyG());
    print(
        'Predicted glucose in 1 hour: ${glucPrev.futureGluc.toStringAsFixed(2)} mg/dL');
  } catch (e) {
    print('Error: ${e.toString()}');
  }
}
