import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/model/travel_tab_model.dart' show TravelTabModel, TravelTab;
import 'package:flutter_xiecheng/model/travel_model.dart' show TravelModel;
import 'package:flutter_xiecheng/dao/travel_tab_dao.dart' show TravelTabDao;
import 'package:flutter_xiecheng/dao/travel_dao.dart' show TravelDao;

class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage>  with SingleTickerProviderStateMixin{
  TabController _controller;
  List<TravelTab> tabs = [];
  TravelTabModel travelTabModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: 0, vsync: this);
    TravelTabDao.fetch().then((TravelTabModel model) {
      print('旅拍tab数据:${model.tabs[0].labelName}');
      setState(() {
        tabs = model.tabs;
        travelTabModel = model;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 30),
            child: TabBar(
              controller: _controller,
              isScrollable: true,
              labelColor: Colors.black,
              labelPadding: EdgeInsets.fromLTRB(20, 0, 10, 5),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Color(0xff2fcfbb), width: 3),
                insets: EdgeInsets.fromLTRB(0, 0, 0, 10)
              ),
              tabs: tabs.map<Tab>((TravelTab tab) {
                return Tab(
                  text: tab.labelName,
                );
              }).toList(),
            ),
          )
        ],
      )
    );
  }
}