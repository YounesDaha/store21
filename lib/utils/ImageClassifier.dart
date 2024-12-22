// import 'dart:io';
// import 'dart:typed_data' show ByteData, Uint8List;
// import 'dart:ui' as ui;
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'dart:math';

// class ImageClassifier {
//   late Interpreter interpreter;
//   late List<String> labels;

//   ImageClassifier() {
//     _loadModel();
//     _loadLabels();
//   }

//   /// Charge le modèle TFLite
//   void _loadModel() async {
//     interpreter = await Interpreter.fromAsset('model.tflite');
//   }

//   /// Charge les étiquettes
//   void _loadLabels() async {
//     final labelFile = await File('assets/labels.txt').readAsLines();
//     labels = labelFile;
//   }

//   /// Effectue la classification
//   Future<String> classify(File image) async {
//     // Prétraitement de l'image
//     final inputImage = await _processImage(image);

//     // Préparer la sortie pour le modèle
//     var output = List.filled(labels.length, 0.0).reshape([1, labels.length]);

//     // Effectuer la prédiction
//     interpreter.run(inputImage, output);

//     // Trouver l'indice avec la probabilité la plus élevée
//     final maxIndex = output[0].indexWhere((element) => element == output[0].reduce(max));

//     return labels[maxIndex];
//   }

//   /// Prétraitement de l'image pour l'adapter au modèle
//   Future<List<List<List<List<double>>>>> _processImage(File image) async {
//     // Charger l'image depuis un fichier
//     final Uint8List imageBytes = await image.readAsBytes();
//     final ui.Codec codec = await ui.instantiateImageCodec(
//       imageBytes,
//       targetWidth: 224,
//       targetHeight: 224,
//     );
//     final ui.FrameInfo frameInfo = await codec.getNextFrame();
//     final ui.Image uiImage = frameInfo.image;

//     // Convertir l'image en tableau de pixels
//     final ByteData? byteData = await uiImage.toByteData(format: ui.ImageByteFormat.rawRgba);
//     if (byteData == null) {
//       throw Exception("Impossible de lire les données des pixels de l'image");
//     }

//     final Uint8List pixels = byteData.buffer.asUint8List();

//     // Normaliser les pixels et préparer l'entrée pour le modèle
//     List<List<List<List<double>>>> input = List.generate(
//       1,
//       (_) => List.generate(
//         224,
//         (y) => List.generate(
//           224,
//           (x) {
//             final pixelIndex = (y * 224 + x) * 4; // RGBA format
//             return [
//               pixels[pixelIndex] / 255.0,     // Canal rouge
//               pixels[pixelIndex + 1] / 255.0, // Canal vert
//               pixels[pixelIndex + 2] / 255.0  // Canal bleu
//             ];
//           },
//         ),
//       ),
//     );

//     return input;
//   }
// }
