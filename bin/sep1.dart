import 'package:sep_1/arte_reco.dart';
import 'package:sep_1/gluc_prev.dart';

class ModelActivator {
  final Map<String, bool> _models;

  ModelActivator({
    bool glucose = false,
    bool psi = false,
    bool ap = false,
    bool musc = false,
    bool cancer = false,
    bool renal = false,
    bool horm = false,
    bool gastro = false,
  }) : _models = {
          'Glucose': glucose,
          'PSI': psi,
          'AP': ap,
          'Musc': musc,
          'Cancer': cancer,
          'Renal': renal,
          'Horm': horm,
          'Gastro': gastro,
        };

  // Método principal que activa los modelos y devuelve el resultado en JSON
  Map<String, dynamic> activateModels(Map<String, dynamic> inputData) {
    Map<String, dynamic> result = {};
    _models.forEach((modelName, isActive) {
      if (isActive) {
        result[modelName] = _processModel(modelName, inputData);
      }
    });
    return result;
  }

  // Método para procesar los datos según el modelo
  Map<String, dynamic> _processModel(
      String modelName, Map<String, dynamic> inputData) {
    switch (modelName) {
      case 'Glucose':
        return _processGlucoseModel(inputData);
      case 'AP':
        return _processAPModel(inputData);
      default:
        return {"error": "Modelo $modelName no implementado."};
    }
  }

  // Función que utiliza GlucPrev para calcular los resultados de glucosa
  Map<String, dynamic> _processGlucoseModel(Map<String, dynamic> inputData) {
    final glucPrev = GlucPrev(
      triglycerides: inputData['triglycerides'] ?? 0.0,
      fastingGluc: inputData['fastingGluc'] ?? 0.0,
      currentGluc: inputData['currentGluc'] ?? 0.0,
      carbsConsumed: inputData['carbsConsumed'] ?? 0.0,
    );

    // Cálculo de las calorías por día
    double dailyCalories = calculateDailyCalories(
      inputData['datetime'],
      inputData['weight'],
      inputData['height'],
      inputData['sex'],
    );

    // Añadir las calorías calculadas al resultado
    glucPrev.toMap()['dailyCalories'] = dailyCalories;

    // Retornamos el mapa con los resultados calculados
    return glucPrev.toMap();
  }

  // Función que utiliza APReco para calcular los resultados de presión arterial
  Map<String, dynamic> _processAPModel(Map<String, dynamic> inputData) {
    final apReco = APReco(
      systolicBP: inputData['systolicBP'] ?? 0.0,
      diastolicBP: inputData['diastolicBP'] ?? 0.0,
    );

    // Retornamos el mapa con los resultados calculados por APReco
    return apReco.toMap();
  }

  // Método para calcular las calorías diarias basadas en la fórmula Mifflin-St Jeor
  double calculateDailyCalories(
      String datetime, double weight, double height, int sex) {
    DateTime birthDate = DateTime.parse(datetime);
    int age = DateTime.now().year - birthDate.year;

    // Fórmulas de Mifflin-St Jeor para calcular las calorías diarias
    double bmr = 0.0;
    if (sex == 0) {
      // Masculino
      bmr = 10 * weight + 6.25 * height * 30.48 - 5 * age + 5;
    } else {
      // Femenino
      bmr = 10 * weight + 6.25 * height * 30.48 - 5 * age - 161;
    }

    // Retornamos el BMR como las calorías por día
    return bmr;
  }

  // El método que se puede utilizar en cualquier parte de tu aplicación
  Map<String, dynamic> sep1({
    required bool glucose,
    required bool ap,
    required String datetime, // Fecha de nacimiento en formato "yyyy-mm-dd"
    required double weight, // Peso en libras
    required double height, // Altura en pies
    required int sex, // Sexo (0 para masculino, 1 para femenino)
    double triglycerides = 0.0,
    double fastingGluc = 0.0,
    double currentGluc = 0.0,
    double carbsConsumed = 0.0,
    double systolicBP = 0.0,
    double diastolicBP = 0.0,
  }) {
    // Datos de entrada combinados
    Map<String, dynamic> inputData = {
      'datetime': datetime,
      'weight': weight,
      'height': height,
      'sex': sex,
      'triglycerides': triglycerides,
      'fastingGluc': fastingGluc,
      'currentGluc': currentGluc,
      'carbsConsumed': carbsConsumed,
      'systolicBP': systolicBP,
      'diastolicBP': diastolicBP,
    };

    // Crear el activador de modelos con los modelos activados
    ModelActivator modelActivator = ModelActivator(glucose: glucose, ap: ap);

    // Activar los modelos y obtener el resultado
    return modelActivator.activateModels(inputData);
  }
}
