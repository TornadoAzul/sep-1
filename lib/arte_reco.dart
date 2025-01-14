class APReco {
  static const double normalBP = 120.0; // Presión arterial normal en mmHg
  static const double elevatedBP = 129.0; // Presión arterial elevada en mmHg
  static const double highBP = 140.0; // Umbral de hipertensión en mmHg

  final double systolicBP; // Presión arterial sistólica actual
  final double diastolicBP; // Presión arterial diastólica actual

  late final String _bpStatus;
  late final Map<String, dynamic> _regulations;

  APReco({
    required this.systolicBP,
    required this.diastolicBP,
  }) {
    _bpStatus = _determineBPStatus();
    _regulations = _generateRegulations();
  }

  String _determineBPStatus() {
    if (systolicBP < normalBP && diastolicBP < 80) {
      return 'Normal';
    } else if (systolicBP <= elevatedBP && diastolicBP < 80) {
      return 'Elevated';
    } else if (systolicBP <= highBP || diastolicBP <= 90) {
      return 'High (Stage 1 Hypertension)';
    } else {
      return 'High (Stage 2 Hypertension)';
    }
  }

  Map<String, dynamic> _generateRegulations() {
    if (_bpStatus == 'Normal') {
      return {
        'sodiumLimit': 2300, // en mg
        'exerciseMinutes': 30, // minutos diarios
        'hydrationLiters': 2.5, // litros de agua diarios
        'potassiumGrams': 2.0, // gramos diarios
      };
    } else if (_bpStatus == 'Elevated') {
      return {
        'sodiumLimit': 1500,
        'exerciseMinutes': 45,
        'hydrationLiters': 3.0,
        'potassiumGrams': 3.0,
      };
    } else if (_bpStatus == 'High (Stage 1 Hypertension)') {
      return {
        'sodiumLimit': 1000,
        'exerciseMinutes': 30,
        'hydrationLiters': 3.5,
        'potassiumGrams': 3.5,
      };
    } else {
      return {
        'sodiumLimit': 0,
        'exerciseMinutes': 0,
        'hydrationLiters': 2.0,
        'potassiumGrams': 4.0,
      };
    }
  }

  String get bpStatus => _bpStatus;

  Map<String, dynamic> get regulations => _regulations;

  /// Export results to a map
  Map<String, dynamic> toMap() {
    return {
      'bpStatus': _bpStatus,
      'regulations': _regulations,
    };
  }
}
