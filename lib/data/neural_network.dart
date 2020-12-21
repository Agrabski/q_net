import 'package:dart_nn/dart_nn.dart';

import 'data_access.dart';

class NeuralNetworkDTO {
  int inputSize;
  int outputSize;
  String name;
  NeuralNetwork network;
  NeuralNetworkDTO(this.inputSize, this.outputSize, this.name) {
    network = NeuralNetwork(inputSize, List(), Layer(outputSize, 'Sigmoid'));
  }

  Future<String> getPath() {
    return getPathToFile<NeuralNetworkPointer>(name);
  }

  Future<NeuralNetworkPointer> save() {
    return getPath().then((path) =>
        saveFile(path, this).then((_) => NeuralNetworkPointer(path, name)));
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'input': inputSize,
      'output': outputSize,
      'network': network.toJson(),
      'name': name
    };
  }

  static NeuralNetworkDTO fromJson(e) {
    final result = NeuralNetworkDTO(e['input'], e['output'], e['name']);
    result.network = NeuralNetwork.fromJson(e['network']);
    return result;
  }
}

class NeuralNetworkPointer {
  String path;
  String name;
  NeuralNetworkPointer(this.path, this.name);

  static Future<List<NeuralNetworkPointer>> load() {
    return loadPointers((n, p) => NeuralNetworkPointer(n, p));
  }
}
