import 'dart:convert';
import 'dart:io';

import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:q_net/any_data_set_wizard.dart';
import 'package:q_net/data/data_access.dart';
import 'package:q_net/list/common.dart';
import 'package:q_net/main.dart';
import 'package:tuple/tuple.dart';

import '../data/data_set_entry.dart';

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

class __DataSetsState extends State<DataSets>
    with SingleTickerProviderStateMixin {
  List<DataSetPointer> _pointers;
  bool _isLoading = false;
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadList();
    return buildList(
        buildButton,
        () => _pointers.map(buildListElement).toList(),
        _pointers == null,
        'Data sets',
        context);
  }

  void loadList() {
    if (_pointers == null && !_isLoading) {
      _isLoading = true;

      Future.delayed(Duration(seconds: 5)).then((value) => {
            setState(() async {
              _pointers = await DataSetPointer.load();
              if (_pointers == null) {
                _pointers = List();
              }
              _isLoading = false;
            })
          });
    }
  }

  void saveList() {
    if (_isLoading) return;
    getApplicationDocumentsDirectory().then((value) {
      var path = value.path;
      var file = File('$path/data_sets.json');
      if (!file.existsSync()) {
        file.create();
      }
      file.writeAsStringSync(jsonEncode(_pointers), flush: true);
    });
  }

  Widget buildListElement(DataSetPointer pointer) {
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

  FloatingActionBubble buildButton() {
    if (!_isLoading) {
      return FloatingActionBubble(
        icon: AnimatedIcons.add_event,
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),
        animation: _animation,
        items: buildActionButtonItems(),
        iconColor: bubbleColor(),
      );
    }
    return null;
  }

  List<Bubble> buildActionButtonItems() {
    return [
      Bubble(
          title: "Any set",
          titleStyle: null,
          iconColor: null,
          bubbleColor: bubbleColor(),
          icon: Icons.account_box,
          onPress: buildNavigationAction(
              context, (c) => AnyDataSetWizard(dataSet: DataSet()))),
      Bubble(
          title: "2d classification",
          titleStyle: null,
          iconColor: null,
          bubbleColor: bubbleColor(),
          icon: Icons.account_box,
          onPress: buildNavigationAction(context, (c) => AnyDataSetWizard())),
    ];
  }

  Function buildNavigationAction(
      BuildContext context, void Function(BuildContext) routeSelector) {
    return () async {
      _animationController.reverse();
      final result = await Navigator.push<Tuple2<String, DataSet>>(
          context, MaterialPageRoute(builder: routeSelector));
      await result.item2.save(result.item1).then(_pointers.add);
    };
  }

  Color bubbleColor() {
    return Colors.blue;
  }
}
