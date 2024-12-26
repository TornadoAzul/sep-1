import 'package:sep_1/diabetes/gluc_prev.dart';
import 'dart:io';

void main() {
  print('Welcome to GlucPrev Terminal Chat!');
  print('Follow the prompts to calculate glucose-related metrics.\n');

  try {
    print('Enter triglycerides level (mg/dL):');
    double triglycerides = double.parse(stdin.readLineSync()!);

    print('Enter fasting glucose level (mg/dL):');
    double fastingGluc = double.parse(stdin.readLineSync()!);

    print('Enter current glucose level (mg/dL):');
    double currentGluc = double.parse(stdin.readLineSync()!);

    print('Enter carbohydrates consumed (grams):');
    double carbsConsumed = double.parse(stdin.readLineSync()!);

    final glucPrev = GlucPrev(
      triglycerides: triglycerides,
      fastingGluc: fastingGluc,
      currentGluc: currentGluc,
      carbsConsumed: carbsConsumed,
    );

    print('\n--- Results ---');
    print('TyG Index: ${glucPrev.tyGIndex.toStringAsFixed(2)}');
    print(
        'Insulin Resistance: ${glucPrev.insulinResistance.toStringAsFixed(2)}');
    print(
        'Future Glucose (1 hour): ${glucPrev.futureGluc.toStringAsFixed(2)} mg/dL');
    print('TyG Interpretation: ${glucPrev.interpretTyG()}');
  } on FormatException {
    print('Error: Please enter valid numerical values.');
  } on ArgumentError catch (e) {
    print('Error: ${e.message}');
  }

  print('\nThank you for using GlucPrev Terminal Chat!');
}
