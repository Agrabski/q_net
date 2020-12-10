import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:q_net/data/data_set_entry.dart';

class DataSetEdit extends StatefulWidget {
  final DataSet set;

  const DataSetEdit({Key key, this.set}) : super(key: key);

  @override
  _DataSetEditState createState() => _DataSetEditState(set);
}

class _DataSetEditState extends State<StatefulWidget> {
  final DataSet set;

  _DataSetEditState(this.set);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FlatButton(
          child: Text('Add'),
          onPressed: () => setState(() => set.addExample()),
        ),
        Container(
            height: 300,
            child: Scrollbar(
                child: ListView(
              children: set.examples.map((e) => buildItem(e, context)).toList(),
            )))
      ],
    );
  }

  Row buildItem(DataSetEntry entry, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          child: Text(
            entry.toString(),
            overflow: TextOverflow.clip,
            softWrap: false,
          ),
          width: 250,
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => setState(() => set.examples.remove(entry)),
          alignment: Alignment.centerRight,
        )
      ],
    );
  }
}
