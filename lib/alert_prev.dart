import 'dart:math';

class AlertPrev {
  static const double noiseThreshold = 70.0; // Umbral de ruido en decibeles
  static const int percentageLimit = 50; // Porcentaje para alerta

  final List<double> decibelLevels;

  AlertPrev({required this.decibelLevels}) {
    if (decibelLevels.length != 60) {
      throw ArgumentError('Debe haber exactamente 60 niveles de decibeles.');
    }
  }

  String evaluateNoise() {
    int countAboveThreshold =
        decibelLevels.where((level) => level > noiseThreshold).length;

    double percentageAboveThreshold =
        (countAboveThreshold / decibelLevels.length) * 100;

    return percentageAboveThreshold > percentageLimit
        ? _getRandomWarningMessage()
        : _getRandomPositiveMessage();
  }

  String _getRandomWarningMessage() {
    const messages = [
      "Debes abandonar el lugar. El ambiente es demasiado ruidoso y puede alterar tus emociones.",
      "El nivel de ruido aquí es peligroso para tu bienestar emocional. ¡Sal de aquí pronto!",
      "Este ambiente es muy ruidoso y podría afectarte. Considera irte a un lugar más tranquilo.",
    ];
    return messages[Random().nextInt(messages.length)];
  }

  String _getRandomPositiveMessage() {
    const messages = [
      "¡Eso fue fenomenal! Respirar de vez en cuando nos ayuda mucho.",
      "¡Buen trabajo! El ambiente está tranquilo, disfruta el momento.",
      "¡Qué bien! Parece un lugar relajante para estar.",
    ];
    return messages[Random().nextInt(messages.length)];
  }

  /// Export results to a map
  Map<String, dynamic> toMap() {
    return {
      'decibelLevels': decibelLevels,
      'evaluation': evaluateNoise(),
    };
  }
}

void main() {
  final alertPrev = AlertPrev(
    decibelLevels: List.generate(60, (index) => Random().nextDouble() * 100),
  );

  print(alertPrev.evaluateNoise());
}
