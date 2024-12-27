import 'dart:math';

class TimeSeriesData {
  final DateTime timestamp;
  final double systolicBP;
  final double heartRate;
  final double temperature;
  final double activity;
  final int hourOfDay;
  final bool afterMeal;
  final bool medication;

  TimeSeriesData({
    required this.timestamp,
    required this.systolicBP,
    required this.heartRate,
    required this.temperature,
    required this.activity,
    required this.hourOfDay,
    required this.afterMeal,
    required this.medication,
  });

  List<double> toFeatures() {
    return [
      heartRate,
      temperature,
      activity,
      hourOfDay.toDouble(),
      afterMeal ? 1.0 : 0.0,
      medication ? 1.0 : 0.0,
    ];
  }
}

class DecisionTreeNode {
  double? value;
  int? featureIndex;
  double? threshold;
  DecisionTreeNode? left;
  DecisionTreeNode? right;
}

class StandardScaler {
  List<double> mean = [];
  List<double> std = [];

  void fit(List<List<double>> data) {
    if (data.isEmpty) return;

    int numFeatures = data[0].length;
    mean = List.filled(numFeatures, 0.0);
    std = List.filled(numFeatures, 0.0);

    for (var sample in data) {
      for (int i = 0; i < numFeatures; i++) {
        mean[i] += sample[i];
      }
    }
    for (int i = 0; i < numFeatures; i++) {
      mean[i] /= data.length;
    }

    for (var sample in data) {
      for (int i = 0; i < numFeatures; i++) {
        std[i] += pow(sample[i] - mean[i], 2);
      }
    }
    for (int i = 0; i < numFeatures; i++) {
      std[i] = sqrt(std[i] / (data.length - 1));
      if (std[i] < 1e-10) std[i] = 1.0;
    }
  }

  List<double> transform(List<double> features) {
    if (features.length != mean.length) {
      throw Exception(
          'Número incorrecto de características. Esperado: ${mean.length}, Recibido: ${features.length}');
    }
    return List.generate(
        features.length, (i) => (features[i] - mean[i]) / std[i]);
  }
}

class HourlyBPPredictor {
  final List<DecisionTreeNode> trees = [];
  late StandardScaler scaler;
  final int numTrees;
  final int maxDepth;
  final int historyHours;
  final Random random = Random(42);

  HourlyBPPredictor({
    this.numTrees = 100,
    this.maxDepth = 10,
    this.historyHours = 6,
  });

  void train(List<TimeSeriesData> timeSeriesData) {
    if (timeSeriesData.length <= historyHours) {
      throw Exception('Insuficientes datos de entrenamiento');
    }

    var features = <List<double>>[];
    var targets = <double>[];

    for (int i = historyHours; i < timeSeriesData.length - 1; i++) {
      var currentFeatures = timeSeriesData[i].toFeatures();
      features.add(currentFeatures);
      targets.add(timeSeriesData[i + 1].systolicBP);
    }

    scaler = StandardScaler();
    scaler.fit(features);
    var scaledFeatures = features.map((f) => scaler.transform(f)).toList();

    for (int i = 0; i < numTrees; i++) {
      var sampleIndices = _bootstrapSamples(scaledFeatures.length);
      var tree = _buildTree(
        scaledFeatures,
        targets,
        0,
        sampleIndices,
      );
      trees.add(tree);
    }
  }

  double predictNextHour(List<TimeSeriesData> recentData) {
    if (recentData.isEmpty) {
      throw Exception('No hay datos para predecir');
    }

    var features = recentData.last.toFeatures();
    var scaledFeatures = scaler.transform(features);

    double prediction = 0.0;
    for (var tree in trees) {
      prediction += _predictTree(tree, scaledFeatures);
    }
    return prediction / trees.length;
  }

  DecisionTreeNode _buildTree(
    List<List<double>> features,
    List<double> targets,
    int depth,
    List<int> sampleIndices,
  ) {
    var node = DecisionTreeNode();

    if (depth >= maxDepth || sampleIndices.length < 2) {
      node.value = _calculateMean(targets, sampleIndices);
      return node;
    }

    var split = _findBestSplit(features, targets, sampleIndices);
    if (split == null) {
      node.value = _calculateMean(targets, sampleIndices);
      return node;
    }

    node.featureIndex = split.featureIndex;
    node.threshold = split.threshold;

    var leftIndices = <int>[];
    var rightIndices = <int>[];

    for (int idx in sampleIndices) {
      if (features[idx][split.featureIndex] <= split.threshold) {
        leftIndices.add(idx);
      } else {
        rightIndices.add(idx);
      }
    }

    if (leftIndices.isEmpty || rightIndices.isEmpty) {
      node.value = _calculateMean(targets, sampleIndices);
      return node;
    }

    node.left = _buildTree(features, targets, depth + 1, leftIndices);
    node.right = _buildTree(features, targets, depth + 1, rightIndices);

    return node;
  }

  double _predictTree(DecisionTreeNode node, List<double> features) {
    if (node.value != null) return node.value!;

    if (features[node.featureIndex!] <= node.threshold!) {
      return _predictTree(node.left!, features);
    } else {
      return _predictTree(node.right!, features);
    }
  }

  List<int> _bootstrapSamples(int dataSize) {
    return List.generate(dataSize, (_) => random.nextInt(dataSize));
  }

  double _calculateMean(List<double> values, List<int> indices) {
    if (indices.isEmpty) return 0.0;
    double sum = 0.0;
    for (int idx in indices) {
      sum += values[idx];
    }
    return sum / indices.length;
  }

  _Split? _findBestSplit(
    List<List<double>> features,
    List<double> targets,
    List<int> sampleIndices,
  ) {
    if (sampleIndices.isEmpty) return null;

    int numFeatures = features[0].length;
    double bestScore = double.infinity;
    _Split? bestSplit;

    int numFeaturesToTry = sqrt(numFeatures).ceil();
    var featureIndices = List.generate(numFeatures, (i) => i)..shuffle(random);
    featureIndices = featureIndices.sublist(0, numFeaturesToTry);

    for (int featureIndex in featureIndices) {
      var values = sampleIndices.map((i) => features[i][featureIndex]).toList()
        ..sort();

      for (int i = 0; i < values.length - 1; i++) {
        double threshold = (values[i] + values[i + 1]) / 2;

        var leftIndices = sampleIndices
            .where((idx) => features[idx][featureIndex] <= threshold)
            .toList();

        var rightIndices = sampleIndices
            .where((idx) => features[idx][featureIndex] > threshold)
            .toList();

        if (leftIndices.isEmpty || rightIndices.isEmpty) continue;

        double score = _calculateVariance(
                leftIndices.map((i) => targets[i]).toList()) +
            _calculateVariance(rightIndices.map((i) => targets[i]).toList());

        if (score < bestScore) {
          bestScore = score;
          bestSplit = _Split(featureIndex, threshold);
        }
      }
    }

    return bestSplit;
  }

  double _calculateVariance(List<double> values) {
    if (values.isEmpty) return 0.0;
    double mean = values.reduce((a, b) => a + b) / values.length;
    return values.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b) /
        values.length;
  }
}

class _Split {
  final int featureIndex;
  final double threshold;

  _Split(this.featureIndex, this.threshold);
}

void PredArte() {
  final random = Random(42);
  final historicalData = List.generate(48, (i) {
    final hourOfDay = i % 24;
    final baselineBP = 120.0 + 10 * sin(2 * pi * hourOfDay / 24);

    return TimeSeriesData(
      timestamp: DateTime.now().subtract(Duration(hours: 48 - i)),
      systolicBP: baselineBP + random.nextDouble() * 5 - 2.5,
      heartRate:
          70 + 10 * sin(2 * pi * hourOfDay / 24) + random.nextDouble() * 5,
      temperature:
          36.5 + 0.5 * sin(2 * pi * hourOfDay / 24) + random.nextDouble() * 0.2,
      activity: max(0,
          50 * sin(2 * pi * (hourOfDay - 6) / 24) + random.nextDouble() * 10),
      hourOfDay: hourOfDay,
      afterMeal: [7, 12, 19].contains(hourOfDay),
      medication: hourOfDay == 8 || hourOfDay == 20,
    );
  });

  try {
    final predictor = HourlyBPPredictor(
      numTrees: 50,
      maxDepth: 5,
      historyHours: 6,
    );

    predictor.train(historicalData.sublist(0, 40));
    final recentData = [historicalData.last];
    final prediction = predictor.predictNextHour(recentData);

    print('\nPredicción de presión arterial:');
    print('Hora actual: ${historicalData.last.hourOfDay}:00');
    print(
        'Presión arterial actual: ${historicalData.last.systolicBP.toStringAsFixed(2)} mmHg');
    print(
        'Presión arterial predicha para la próxima hora: ${prediction.toStringAsFixed(2)} mmHg');
  } catch (e) {
    print('Error durante la predicción: $e');
  }
}
