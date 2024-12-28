List<Map<String, dynamic>> SepOne({
  required String language,
  int? heart,
  int? diabetes,
  int? respiration,
  int? stomach,
  int? psicology,
}) {
  List<Map<String, dynamic>> questions = [];
  Map<String, Map<String, String>> translations = {
    "heart_1": {
      "es": "¿Cuál es tu presión arterial actual?",
      "en": "What is your current blood pressure?",
    },
    "heart_2": {
      "es": "¿Sientes algún dolor en el corazón?",
      "en": "Do you feel any heart pain?",
    },
    "diabetes_1": {
      "es": "¿Cuál es tu nivel actual de glucosa en sangre?",
      "en": "What is your current blood glucose level?",
    },
    "respiration_1": {
      "es": "¿Tuviste una recaída de asma durante el día anterior?",
      "en": "Did you have an asthma relapse yesterday?",
    },
    "stomach_1": {
      "es": "¿Cuántos carbohidratos planeas consumir hoy?",
      "en": "How many carbohydrates do you plan to consume today?",
    },
    "psicology_1": {
      "es": "¿Cómo te sientes hoy?",
      "en": "How are you feeling today?",
    },
    "exercise_1": {
      "es": "¿Qué nivel de ejercicio planeas realizar hoy?",
      "en": "What level of exercise do you plan to do today?",
    },
  };

  // Heart-related questions
  if (heart == 1) {
    questions.add({
      "id": "heart_1",
      "type": "number",
      "title": translations["heart_1"]![language],
      'requiredq': true,
    });
    questions.add({
      "id": "heart_2",
      "type": "choose",
      "title": translations["heart_2"]![language],
      "options": [0, 1],
      'requiredq': true,
    });
  }

  // Diabetes-related questions
  if (diabetes != null) {
    if (diabetes == 1 || diabetes == 2) {
      questions.add({
        "id": "diabetes_1",
        "type": "number",
        "title": translations["diabetes_1"]![language],
        'requiredq': false,
      });
    } else if (diabetes == 3 || diabetes == 4) {
      questions.add({
        "id": "diabetes_1",
        "type": "number",
        "title": translations["diabetes_1"]![language],
        'requiredq': true,
      });
    }
  }

  // Respiration-related questions
  if (respiration == 1) {
    questions.add({
      "id": "respiration_1",
      "type": "choose",
      "title": translations["respiration_1"]![language],
      "options": [0, 1],
      'requiredq': true,
    });
  }

  // Stomach-related questions
  questions.add({
    "id": "stomach_1",
    "type": "number",
    "title": translations["stomach_1"]![language],
    'requiredq': true,
  });

  // Psychology-related questions
  if (psicology == 1) {
    questions.add({
      "id": "psicology_1",
      "type": "type",
      "title": translations["psicology_1"]![language],
      'requiredq': false,
    });
  }

  // Exercise-related question
  questions.add({
    "id": "exercise_1",
    "type": "choose",
    "title": translations["exercise_1"]![language],
    "options": [0, 1, 2, 3],
    'requiredq': true,
  });

  return questions;
}

void SepOneProcess(Map<String, dynamic> responses) {
  responses.forEach((questionId, response) {
    print("Respuesta a $questionId: $response");
  });
}
