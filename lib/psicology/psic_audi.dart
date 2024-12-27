import 'dart:math' as math;

class PsicAudit {
  // Constructor para pasar los valores de los decibeles.
  List<int> decibels;

  PsicAudit(this.decibels);

  // Calcular el promedio de los decibeles.
  double calcularPromedio() {
    return decibels.reduce((a, b) => a + b) / decibels.length;
  }

  // Calcular la desviación estándar.
  double calcularDesviacionEstandar() {
    double promedio = calcularPromedio();
    double sumatoria = decibels
        .map((d) => (d - promedio) * (d - promedio))
        .reduce((a, b) => a + b);
    return math.sqrt(sumatoria / decibels.length);
  }

  // Calcular el índice de alerta basado en las fluctuaciones y picos de decibeles.
  double calcularIndiceDeAlerta() {
    int maxDecibeles = decibels.reduce((a, b) => a > b ? a : b);
    double desviacionEstandar = calcularDesviacionEstandar();
    // El índice de alerta usa tanto el valor máximo de los decibeles como la desviación estándar.
    return (maxDecibeles / 100.0) + (desviacionEstandar / 10.0);
  }

  // Calcular la probabilidad de pánico basada en decibeles, desviación estándar e índice de alerta.
  double calcularProbabilidadDePanico() {
    double promedio = calcularPromedio();
    double desviacionEstandar = calcularDesviacionEstandar();
    double indiceAlerta = calcularIndiceDeAlerta();

    // Fórmula para la probabilidad de pánico.
    double probabilidad = 0.0;

    // A mayor promedio de decibeles, mayor probabilidad de pánico.
    probabilidad += (promedio - 50) *
        0.5; // Ajustamos el rango de decibeles a un porcentaje.

    // A mayor desviación estándar, mayor probabilidad de pánico.
    probabilidad += desviacionEstandar * 0.25; // Ajuste ponderado.

    // A mayor índice de alerta, mayor probabilidad de pánico.
    probabilidad += indiceAlerta * 2.0; // Mayor peso en el índice de alerta.

    // Nos aseguramos de que la probabilidad esté entre 0% y 100%.
    if (probabilidad > 100) probabilidad = 100;
    if (probabilidad < 0) probabilidad = 0;

    return probabilidad;
  }
}

void main() {
  // Ejemplo de entrada de decibeles durante 60 segundos (valores más bajos para ver un porcentaje menor).
  List<int> decibeles = [
    50,
    52,
    54,
    56,
    58,
    60,
    62,
    64,
    66,
    68,
    70,
    72,
    74,
    76,
    78,
    80,
    82,
    84,
    86,
    88,
    90,
    92,
    94,
    96,
    98,
    100,
    102,
    104,
    106,
    108,
    110,
    112,
    114,
    116,
    118,
    120,
    122,
    124,
    126,
    128,
    130,
    132,
    134,
    136,
    138,
    140,
    142,
    144,
    146,
    148,
    150,
    152,
    154,
    156,
    158,
    160,
    162,
    164,
    166,
    168,
    170
  ];

  PsicAudit psicAudit = PsicAudit(decibeles);

  // Mostrar solo el porcentaje de la probabilidad de pánico
  print(psicAudit.calcularProbabilidadDePanico().toStringAsFixed(2));
}
