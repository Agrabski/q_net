import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:q_net/data_set_entry.dart';
import 'package:q_net/main.dart';

class DS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: DataSets(),
      theme: getTheme(),
      title: "data sets",
    );
  }
}

class DataSets extends StatefulWidget {
  @override
  __DataSetsState createState() {
    // TODO: implement createState
    return new __DataSetsState();
  }
}

class __DataSetsState extends State<DataSets> {
  List<DatasetPointer> _pointers;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    loadList();
    return Scaffold(
      appBar: AppBar(
        title: Text("data sets"),
      ),
      drawer: getDrawer(context),
      body: buildList(context),
      floatingActionButton: buildButton(),
    );
  }

  void loadList() {
    if (_pointers == null && !_isLoading) {
      _isLoading = true;

      Future.delayed(Duration(seconds: 5)).then((value) => getApplicationDocumentsDirectory().then((value) {
        var path = value.path;
        var file = File('$path/data_sets.json');
        if (!file.existsSync()) {
          file.create();
          file.writeAsStringSync(jsonEncode(List<DatasetPointer>()),
              flush: true);
        }
        setState(() {
          _pointers = (jsonDecode(file.readAsStringSync()) as List)
              .map((e) => DatasetPointer.fromJson(e))
              .toList();
          if (_pointers == null) {
            _pointers = List();
          }
          _isLoading = false;
        });
      }));
    }
  }

  Widget buildList(BuildContext context) {
    if (_pointers == null) {
      return Center(
        child: Column(
          children: [CircularProgressIndicator(), Text("Loading")],
          mainAxisSize: MainAxisSize.min,
        ),
      );
    }
    return ListView(
      children: _pointers.map(buildListElement).toList(),
    );
  }
  
  Widget buildListElement(DatasetPointer pointer) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(pointer.name),
        IconButton(icon: Icon(Icons.delete), alignment: Alignment.centerRight, onPressed: (){setState(() {
          _pointers.remove(pointer);
        });})
      ],
    );
  }

  FloatingActionButton buildButton() {
    if (!_isLoading) {
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addDatasetPointer,
      );
    }
    return null;
  }

  addDatasetPointer() {
    setState(() {
      _pointers.add(DatasetPointer("", ""));
    });
  }
}
