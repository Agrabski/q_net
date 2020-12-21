import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:q_net/data/data_access.dart';
import 'package:q_net/data/neural_network.dart';
import 'package:q_net/edit/neural_network_edit.dart';
import 'package:tuple/tuple.dart';

import 'common.dart';

class NeuralNetworks extends StatefulWidget {
  @override
  _NeuralNetworksState createState() {
    return _NeuralNetworksState();
  }
}

class _NeuralNetworksState extends State<NeuralNetworks> {
  List<NeuralNetworkPointer> _pointers;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    loadList();
    return buildList(
        buildButton,
        () => _pointers.map(buildListElement).toList(),
        _pointers == null,
        'Neural Networks',
        context);
  }

  void loadList() {
    if (_pointers == null && !_isLoading) {
      _isLoading = true;

      NeuralNetworkPointer.load().then((pointers) => {
            if (pointers == null) pointers = List(),
            setState(() {
              _pointers = pointers;
              _isLoading = false;
            })
          });
    }
  }

  Widget buildListElement(NeuralNetworkPointer pointer) {
    return buildRow(
        pointer.name,
        () => {
              setState(() {
                _pointers.remove(pointer);
                deleteFile(pointer.path);
              })
            },
        () => {});
  }

  Widget buildButton() {
    if (!_isLoading) {
      return FloatingActionButton(
        onPressed: buildAddAction(context),
        child: Icon(Icons.add),
      );
    }
    return null;
  }

  Function buildAddAction(BuildContext context) {
    return () async {
      final nn = await Navigator.push<Tuple2<String, NeuralNetworkDTO>>(
          context, MaterialPageRoute(builder: (c) => NeuralNetworkEdit(null)));
      if (nn != null) {
        var pointer = await nn.item2.save();
        setState(() {
          _pointers.add(pointer);
        });
      }
    };
  }

  Color bubbleColor() {
    return Colors.blue;
  }
}
