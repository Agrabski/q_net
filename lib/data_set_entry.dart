class DatasetEntry {
  List<int> input = List();
  List<int> output = List();
}

class DatasetPointer {

  DatasetPointer(n, p) {
    name = n;
    path = p;
  }
  String name;
  String path;

  static DatasetPointer fromJson(e) {
    return DatasetPointer(e["name"], e["path"]);
  }

}