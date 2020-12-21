import 'data_access.dart';

class DataSetEntry {
  DataSetEntry(int inputSize, int outputSize) {
    input = List.filled(inputSize, 0);
    output = List.filled(outputSize, 0);
  }
  List<int> input;
  List<int> output;

  @override
  String toString() {
    return '[${input.join(', ')}] -> [${output.join(', ')}]';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'input': input,
      'output': output,
      'inputSize': input.length,
      'outputSize': output.length
    };
  }

  static DataSetEntry fromJson(e) {
    final result = DataSetEntry(e['inputSize'], e['outputSize']);
    result.input = e['input'];
    result.output = e['output'];
    return result;
  }
}

enum DataSetType { Any, Point }

DataSetType getDataSetTypeFromString(String statusAsString) {
  for (DataSetType element in DataSetType.values) {
    if (element.toString() == statusAsString) {
      return element;
    }
  }
  return null;
}

class DataSet {
  int inputSize;
  int outputSize;
  DataSetType type = DataSetType.Any;
  List<DataSetEntry> examples = List();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'inputSize': inputSize,
      'outputSize': outputSize,
      'type': type.toString(),
      'examples': examples.map((e) => e.toJson()).toList()
    };
  }

  static DataSet fromJson(e) {
    final result = DataSet();
    result.inputSize = e['inputSize'];
    result.outputSize = e['outputSize'];
    result.type = getDataSetTypeFromString(e['type']);
    result.examples = e['examples'];
    return result;
  }

  static Future<String> getPathForFilename(String filename) {
    return getPathToFile<DataSetPointer>(filename);
  }

  Future<DataSetPointer> save(String fileName) {
    return getPathForFilename(fileName).then((path) =>
        saveFile(path, this).then((_) => DataSetPointer(fileName, path)));
  }

  DataSetEntry addExample() {
    examples.add(DataSetEntry(inputSize, outputSize));
    return examples.last;
  }
}

class DataSetPointer {
  DataSetPointer(n, p) {
    name = n;
    path = p;
  }
  String name;
  String path;

  static Future<List<DataSetPointer>> load() {
    return loadPointers((n, p) => DataSetPointer(n, p));
  }

  static DataSetPointer fromJson(e) {
    return DataSetPointer(e["name"], e["path"]);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'name': name, 'path': path};
  }
}
