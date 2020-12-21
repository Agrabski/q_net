import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:q_net/data/neural_network.dart';
import 'package:tuple/tuple.dart';

class NeuralNetworkStructureEdit extends StatefulWidget {
  final NeuralNetworkDTO nn;
  NeuralNetworkStructureEdit(this.nn);

  @override
  State<StatefulWidget> createState() {
    return _NeuralNetworkStructureEditState(nn);
  }
}

class _NeuralNetworkStructureEditState
    extends State<NeuralNetworkStructureEdit> {
  final NeuralNetworkDTO nn;
  Offset _currentOffset = Offset(0, 0);
  _NeuralNetworkStructureEditState(this.nn);
  @override
  initState() {
    super.initState();
    const separation = 20;
    var offsetY = 0.0;
    var offsetX = 0.0;
    var currentModelList = List<ItemModel>();
    for (var i in Iterable<int>.generate(nn.network.inputNodes.nodes)) {
      currentModelList.add(
          ItemModel(offset: Offset(0, offsetY) + _currentOffset, text: ''));
      offsetY += separation;
    }
    items.add(currentModelList);

    for (var layer in nn.network.hiddenNodes) {
      currentModelList = List();
      offsetX += separation;
      offsetY = 0;
      for (var i in Iterable<int>.generate(layer.nodes)) {
        currentModelList.add(ItemModel(
            offset: Offset(offsetX, offsetY) + _currentOffset, text: ''));
        offsetY += separation;
      }
      items.add(currentModelList);
    }
    offsetX += separation;
    offsetY = 0;
    currentModelList = List();
    for (var i in Iterable<int>.generate(nn.network.outputNodes.nodes)) {
      currentModelList.add(ItemModel(
          offset: Offset(offsetX, offsetY) + _currentOffset, text: ''));
      offsetY += separation;
    }
    items.add(currentModelList);
  }

  List<List<ItemModel>> items = [];

  handleDrag(details) {
    print(details);
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    setState(() {
      _currentOffset = Offset(x, y);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanStart: handleDrag,
        onPanUpdate: handleDrag,
        child: Stack(
          children: <Widget>[
            CustomPaint(
              size: Size(double.infinity, double.infinity),
              painter: CurvedPainter(
                offsets: getOffsets(),
              ),
            ),
            ..._buildItems()
          ],
        ));
  }

  List<Tuple2<Offset, Offset>> getOffsets() {
    var result = List<Tuple2<Offset, Offset>>();
    for (var i = 1; i < items.length; i++) {
      for (var item1 in items[i - 1]) {
        for (var item2 in items[i]) {
          result.add(Tuple2(item1.offset, item2.offset));
        }
      }
    }
    return result;
  }

  List<Widget> _buildItems() {
    final res = <Widget>[];
    items.asMap().forEach((ind1, item) {
      item.asMap().forEach((ind2, e) {
        res.add(_Item(
          offset: e.offset,
          text: e.text,
        ));
      });
    });

    return res;
  }
}

class _Item extends StatelessWidget {
  _Item({
    Key key,
    this.offset,
    this.onDragStart,
    this.text,
  });

  final double size = 5;
  final Offset offset;
  final Function onDragStart;
  final String text;

  _handleDrag(details) {
    print(details);
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    onDragStart(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: GestureDetector(
        onPanStart: _handleDrag,
        onPanUpdate: _handleDrag,
        child: Container(
          width: size,
          height: size,
          child: Text(text),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.blueAccent,
            ),
          ),
        ),
      ),
    );
  }
}

class CurvedPainter extends CustomPainter {
  CurvedPainter({this.offsets});

  final List<Tuple2<Offset, Offset>> offsets;

  @override
  void paint(Canvas canvas, Size size) {
    if (offsets.length > 1) {
      offsets.asMap().forEach((index, offset) {
        canvas.drawLine(
          offset.item1,
          offset.item2,
          Paint()
            ..color = Colors.red
            ..strokeWidth = 2,
        );
      });
    }
  }

  @override
  bool shouldRepaint(CurvedPainter oldDelegate) => true;
}

class ItemModel {
  ItemModel({this.offset, this.text});

  final Offset offset;
  final String text;

  ItemModel copyWithNewOffset(Offset offset) {
    return ItemModel(offset: offset, text: text);
  }
}
