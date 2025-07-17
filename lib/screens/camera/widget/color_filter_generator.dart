import 'dart:math';

class ColorFilterGenerator {
  static List<double> temperatureMatrix(double temperatureLevel) {
    // temperatureLevel can range from -1.0 (cooler) to 1.0 (hotter)
    double rScale = 1.0 + temperatureLevel; // Increase red for warmth
    double bScale = 1.0 - temperatureLevel; // Decrease blue for warmth

    return [
      rScale, 0, 0, 0, 0, // Red channel adjustment
      0, 1, 0, 0, 0, // Green remains unchanged
      0, 0, bScale, 0, 0, // Blue channel adjustment
      0, 0, 0, 1, 0, // Alpha channel remains unchanged
    ];
  }

// Function to create a vibrance color matrix
  static List<double> vibranceMatrix(double vibranceLevel) {
    double invSat = 1 - vibranceLevel;
    double r = 0.213 * invSat;
    double g = 0.715 * invSat;
    double b = 0.072 * invSat;

    return [
      r + vibranceLevel,
      g,
      b,
      0,
      0,
      r,
      g + vibranceLevel,
      b,
      0,
      0,
      r,
      g,
      b + vibranceLevel,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  static List<double> hueMatrix(double degrees) {
    double angle = degrees * 3.14159 / 180;
    double cosA = cos(angle);
    double sinA = sin(angle);

    return [
      0.213 + cosA * 0.787 - sinA * 0.213,
      0.715 - cosA * 0.715 - sinA * 0.715,
      0.072 - cosA * 0.072 + sinA * 0.928,
      0,
      0,
      0.213 - cosA * 0.213 + sinA * 0.143,
      0.715 + cosA * 0.285 + sinA * 0.140,
      0.072 - cosA * 0.072 - sinA * 0.283,
      0,
      0,
      0.213 - cosA * 0.213 - sinA * 0.787,
      0.715 - cosA * 0.715 + sinA * 0.715,
      0.072 + cosA * 0.928 + sinA * 0.072,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  static List<double> contrastMatrix(double contrast) {
    double t = (1 - contrast) * 0.5 * 255;
    return [
      contrast,
      0,
      0,
      0,
      t,
      0,
      contrast,
      0,
      0,
      t,
      0,
      0,
      contrast,
      0,
      t,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  static List<double> brightnessMatrix(double brightness) {
    return [
      1,
      0,
      0,
      0,
      brightness * 255,
      0,
      1,
      0,
      0,
      brightness * 255,
      0,
      0,
      1,
      0,
      brightness * 255,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  // Saturation matrix for ColorFilter
  static List<double> saturationMatrix(double value) {
    double invSat = 1 - value;
    double r = 0.213 * invSat;
    double g = 0.715 * invSat;
    double b = 0.072 * invSat;

    return [
      r + value,
      g,
      b,
      0,
      0,
      r,
      g + value,
      b,
      0,
      0,
      r,
      g,
      b + value,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  static List<double> multiplyMatrices(List<double> a, List<double> b) {
    List<double> result = List.filled(20, 0);
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 5; col++) {
        result[row * 5 + col] = a[row * 5 + 0] * b[0 * 5 + col] +
            a[row * 5 + 1] * b[1 * 5 + col] +
            a[row * 5 + 2] * b[2 * 5 + col] +
            a[row * 5 + 3] * b[3 * 5 + col];
      }
    }
    result[15] = 1.0; // Set alpha channel
    return result;
  }
}
