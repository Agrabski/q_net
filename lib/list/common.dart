import 'package:flutter/material.dart';
import 'package:q_net/main.dart';

class CommonListWidget extends StatefulWidget {
  final Widget Function() builder;
  final String name;
  CommonListWidget(this.builder, this.name);
  @override
  _CommonListWidgetState createState() {
    return _CommonListWidgetState(builder, name);
  }
}

class _CommonListWidgetState extends State<CommonListWidget> {
  Widget Function() builder;
  String name;
  _CommonListWidgetState(this.builder, this.name);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: builder(),
      theme: getTheme(),
      title: name,
    );
  }
}

Row buildRow(String elementName, void onDelete(), void onClick()) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      FlatButton(onPressed: onClick, child: Text(elementName)),
      IconButton(
          icon: Icon(Icons.delete),
          alignment: Alignment.center,
          onPressed: onDelete)
    ],
  );
}

Widget buildList(Widget buttonBuilder(), List<Widget> listBuilder(),
    bool isLoading, String viewName, BuildContext context) {
  Widget content;
  if (isLoading)
    content = Center(
      child: Column(
        children: [CircularProgressIndicator(), Text("Loading")],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  else
    content = ListView(
      children: listBuilder(),
    );
  return Scaffold(
    appBar: AppBar(
      title: Text("data sets"),
    ),
    drawer: getDrawer(context),
    body: content,
    floatingActionButton: buttonBuilder(),
  );
}
