import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/model/grid_nav_model.dart' show GridNavModel, GridNavItem;

class GridNav extends StatefulWidget {
  final GridNavModel gridNavModel;
  final String name;
  const GridNav({Key key, @required this.gridNavModel, this.name='sammy'}):super(key: key);

  @override
  _GridNavState createState() => _GridNavState();
}

class _GridNavState extends State<GridNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('${widget.name}'),
    );
  }
}