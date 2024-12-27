class CardRies {
  static int evaluateBloodPressure(int systolic, int diastolic) {
    if (systolic < 90 || diastolic < 60) {
      return 1; // Hipotensión
    } else if (systolic <= 120 && diastolic <= 80) {
      return 2; // Normal
    } else if (systolic <= 129 && diastolic < 80) {
      return 3; // Elevada
    } else if (systolic <= 139 || diastolic <= 89) {
      return 4; // Hipertensión etapa 1
    } else {
      return 5; // Hipertensión etapa 2 o crisis
    }
  }
}
