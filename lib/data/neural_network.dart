import 'data_access.dart';

class NeuralNetwork {
  int inputSize;
  int outputSize;
  String name;

  Future<String> getPath() {
    return getPathToFile<NeuralNetworkPointer>(name);
  }

  Future<NeuralNetworkPointer> save() {
    return getPath().then((path) =>
        saveFile(path, this).then((_) => NeuralNetworkPointer(name, path)));
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
