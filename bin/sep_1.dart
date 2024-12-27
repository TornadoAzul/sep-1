List<Map<String, dynamic>> SepOne({
  int? heart,
  int? diabetes,
  int? respiration,
  int? stomach,
  int? psicology,
}) {
  List<Map<String, dynamic>> questions = [];

  // Heart-related questions
  if (heart == 1) {
    questions.add({
      "type": "number",
      "title": "¿Cuál es tu presión arterial actual?",
      'requiredq': true,
    });
    questions.add({
      "type": "choose",
      "title": "¿Sientes algún dolor en el corazón?",
      "options": ["Sí", "No"],
      'requiredq': true,
    });
  }

  // Diabetes-related questions
  if (diabetes != null) {
    if (diabetes == 1 || diabetes == 2) {
      questions.add({
        "type": "number",
        "title": "¿Cuál es tu nivel actual de glucosa en sangre?",
        'requiredq': false,
      });
    } else if (diabetes == 3 || diabetes == 4) {
      questions.add({
        "type": "number",
        "title": "¿Cuál es tu nivel actual de glucosa en sangre?",
        'requiredq': true,
      });
    }
  }

  // Respiration-related questions
  if (respiration == 1) {
    questions.add({
      "type": "choose",
      "title": "¿Tuviste una recaída de asma durante el día anterior?",
      "options": ["Sí", "No"],
      'requiredq': true,
    });
  }

  // Stomach-related questions
  questions.add({
    "type": "number",
    "title": "¿Cuántos carbohidratos planeas consumir hoy?",
    'requiredq': true,
  });

  // Psychology-related questions
  if (psicology == 1) {
    questions.add({
      "type": "type",
      "title": "¿Cómo te sientes hoy?",
      'requiredq': false,
    });
  }

  // Exercise-related question
  questions.add({
    "type": "choose",
    "title": "¿Qué nivel de ejercicio planeas realizar hoy?",
    "options": ["Ninguno", "Ligero", "Moderado", "Intenso"],
    'requiredq': true,
  });

  return questions;
}

void SepOneProcess(Map<String, dynamic> responses) {
  // Example of handling heart responses
  if (responses.containsKey("¿Cuál es tu presión arterial actual?")) {
    int bloodPressure = responses["¿Cuál es tu presión arterial actual?"];
    print("La presión arterial reportada es: $bloodPressure");
    // Add logic for blood pressure handling
  }

  if (responses.containsKey("¿Sientes algún dolor en el corazón?")) {
    String heartPain = responses["¿Sientes algún dolor en el corazón?"];
    print("Dolor en el corazón reportado: $heartPain");
    // Add logic for heart pain handling
  }

  // Example of handling diabetes responses
  if (responses.containsKey("¿Cuál es tu nivel actual de glucosa en sangre?")) {
    int glucoseLevel =
        responses["¿Cuál es tu nivel actual de glucosa en sangre?"];
    print("Nivel de glucosa reportado: $glucoseLevel");
    // Add logic for glucose level handling
  }

  // Example of handling respiration responses
  if (responses
      .containsKey("¿Tuviste una recaída de asma durante el día anterior?")) {
    String asthmaRelapse =
        responses["¿Tuviste una recaída de asma durante el día anterior?"];
    print("Recaída de asma reportada: $asthmaRelapse");
    // Add logic for asthma relapse handling
  }

  // Example of handling stomach responses
  if (responses.containsKey("¿Cuántos carbohidratos planeas consumir hoy?")) {
    int carbs = responses["¿Cuántos carbohidratos planeas consumir hoy?"];
    print("Carbohidratos planeados: $carbs");
    // Add logic for carbohydrate intake handling
  }

  // Example of handling psychology responses
  if (responses.containsKey("¿Cómo te sientes hoy?")) {
    String mood = responses["¿Cómo te sientes hoy?"];
    print("Estado de ánimo reportado: $mood");
    // Add logic for mood handling
  }

  // Example of handling exercise responses
  if (responses.containsKey("¿Qué nivel de ejercicio planeas realizar hoy?")) {
    String exerciseLevel =
        responses["¿Qué nivel de ejercicio planeas realizar hoy?"];
    print("Nivel de ejercicio planeado: $exerciseLevel");
    // Add logic for exercise level handling
  }
}

void main() {
  // Example usage
  var questions =
      SepOne(heart: 1, diabetes: 2, respiration: 0, stomach: 1, psicology: 1);
  print(questions);

  // Example responses
  var responses = {
    "¿Cuál es tu presión arterial actual?": 120,
    "¿Sientes algún dolor en el corazón?": "No",
    "¿Cuál es tu nivel actual de glucosa en sangre?": 95,
    "¿Cuántos carbohidratos planeas consumir hoy?": 200,
    "¿Cómo te sientes hoy?": "Bien",
    "¿Qué nivel de ejercicio planeas realizar hoy?": "Moderado",
  };

  SepOneProcess(responses);
}
