import 'dart:math';

class GlucPrev {
  static const double carbohydrateFactor =
      0.1; // Impacto de carbohidratos en glucosa
  static const double resistanceFactor =
      1.0; // Factor de resistencia a la insulina
  static const double tygThreshold = 4.5; // Umbral para el índice TyG
  static const double caloriesPerGramCarb =
      4.0; // Calorías por gramo de carbohidrato
  static const double targetGluc = 100.0; // Objetivo de glucosa en mg/dL

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

  double _calculateTyG(double triglycerides, double glucose) {
    if (triglycerides <= 0 || glucose <= 0) {
      throw ArgumentError('Values must be greater than zero');
    }
    return log(triglycerides / 2) + log(glucose / 2);
  }

  double _calculateFutureGluc(double currentGluc, double carbs) {
    double carbImpact = carbs * carbohydrateFactor;
    double resistanceAdjustment = _insulinResistance * resistanceFactor;
    return currentGluc + carbImpact - resistanceAdjustment;
  }

  double _calculateCaloriesNeeded() {
    double glucDifference = targetGluc - _futureGluc;
    if (glucDifference > 0) {
      // Si la glucosa futura es menor que el objetivo, se necesitan calorías
      double carbsNeeded = glucDifference / carbohydrateFactor;
      return carbsNeeded * caloriesPerGramCarb;
    }
    return 0.0;
  }

  double _calculateCaloriesToBurn() {
    double glucDifference = _futureGluc - targetGluc;
    if (glucDifference > 0) {
      // Si la glucosa futura es mayor que el objetivo, se deben quemar calorías
      double carbsToBurn = glucDifference / carbohydrateFactor;
      return carbsToBurn * caloriesPerGramCarb;
    }
    return 0.0;
  }

  String interpretTyG() {
    return _tyGIndex > tygThreshold
        ? 'Elevated risk of insulin resistance'
        : 'Normal risk of insulin resistance';
  }

  double get tyGIndex => _tyGIndex;
  double get insulinResistance => _insulinResistance;
  double get futureGluc => _futureGluc;
  double get kcalNeed => _calculateCaloriesNeeded();
  double get kcalBurn => _calculateCaloriesToBurn();

  /// Export results to a map
  Map<String, dynamic> toMap() {
    return {
      'tyGIndex': _tyGIndex,
      'insulinResistance': _insulinResistance,
      'futureGluc': _futureGluc,
      'kcalNeed': _calculateCaloriesNeeded(),
      'kcalBurn': _calculateCaloriesToBurn(),
      'tyGInterpretation': interpretTyG(),
    };
  }
}

void main() {
  final glucPrev = GlucPrev(
    triglycerides: 150.0,
    fastingGluc: 90.0,
    currentGluc: 70.0,
    carbsConsumed: 1.0,
  );

  print('glucfuture: ${glucPrev.futureGluc}');
  print('kcalneed: ${glucPrev.kcalNeed}');
  print('kcalburn: ${glucPrev.kcalBurn}');
}
