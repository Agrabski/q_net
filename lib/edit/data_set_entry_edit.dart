import 'package:flutter/cupertino.dart';
import 'package:q_net/data/data_set_entry.dart';

class DataSetEntryEdit extends StatefulWidget {
  final DataSetEntry entry;

  const DataSetEntryEdit({Key key, this.entry}) : super(key: key);

  @override
  _DataSetEntryEditState createState() => _DataSetEntryEditState(entry);
}

class _DataSetEntryEditState extends State<DataSetEntryEdit> {
  final DataSetEntry entry;

  _DataSetEntryEditState(this.entry);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
