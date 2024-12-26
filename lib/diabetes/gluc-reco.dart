import 'dart:math';

class GlucReco {
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

  GlucReco({
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

  /// Calcula la cantidad de carbohidratos necesarios para alcanzar una glucosa futura dentro del rango objetivo.
  double calculateRequiredCarbs(double targetGluc) {
    // La diferencia entre la glucosa actual y la meta es lo que necesitas ajustar.
    double glucDifference = targetGluc - currentGluc;

    // El impacto de los carbohidratos en la glucosa es ajustado por la resistencia a la insulina
    double requiredCarbs =
        glucDifference / carbohydrateFactor + insulinResistance;

    // Devuelve la cantidad de carbohidratos necesaria para alcanzar el objetivo
    return requiredCarbs > 0 ? requiredCarbs : 0;
  }
}

/// Example usage of GlucReco
void main() {
  try {
    final glucReco = GlucReco(
      triglycerides: 150.0, // mg/dL
      fastingGluc: 90.0, // mg/dL
      currentGluc: 95.0, // mg/dL
      carbsConsumed: 30.0, // gramos
    );

    // Calcular cuántos carbohidratos necesitas para mantener la glucosa en el rango de 100-130 mg/dL
    double requiredCarbs = glucReco.calculateRequiredCarbs(130.0);

    print('TyG Index: ${glucReco.tyGIndex.toStringAsFixed(2)}');
    print(glucReco.interpretTyG());
    print(
        'Predicted glucose in 1 hour: ${glucReco.futureGluc.toStringAsFixed(2)} mg/dL');
    print(
        'Required carbs to reach target glucose of 130: ${requiredCarbs.toStringAsFixed(2)} grams');
  } catch (e) {
    print('Error: ${e.toString()}');
  }
}
