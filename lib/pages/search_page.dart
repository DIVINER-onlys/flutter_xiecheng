import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/dao/search_dao.dart' show SearchDao;
import 'package:flutter_xiecheng/model/search_model.dart' show SearchModel, SearchItem;
import 'package:flutter_xiecheng/widget/search_bar.dart' show SearchBar;

const URL = 'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';

class SearchPage extends StatefulWidget {
  final bool hideLife;
  final String searchUrl;
  final String keyword;
  final String hint;
  SearchPage({
    this.hideLife = true,
    this.searchUrl = URL,
    this.keyword,
    this.hint
  });
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchModel searchModel;
  String keyword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(),
          // 去除ListView的顶部padding
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: 
            // 在Column使用ListView没有指明ListView高度会报错
            // 解决方法是 使用Expanded并且flex设置为1， ListVeiw会自动撑开屏幕的剩余高度
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: searchModel?.data?.length??0,
                itemBuilder: (BuildContext context, int index) {
                  return _item(index);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  // 自定义AppBar
  Widget _appBar() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // AppBar渐变遮罩背景
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: Container(
            padding: EdgeInsets.only(top: 20),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: SearchBar(
              hideLeft: widget.hideLife,
              defaultText: widget.keyword,
              hint: widget.hint,
              leftButtonClick: (){
                Navigator.pop(context);
              },
              onChanged: _onTextChange,
            ),
          ),
        )
      ],
    );
  }

  //
  Widget _item (int index) {
    if (searchModel==null||searchModel.data==null) {
      return null;
    }
    SearchItem item = searchModel.data[index];
    return Text(
      item.word
    );
  }

  _onTextChange (String text) {
    keyword = text;
    if (text.length == 0) {
      setState(() {
        searchModel = null;
      });
      return;
    }
    String url = widget.searchUrl + text;
    SearchDao.fetch(url, text)
    .then((SearchModel model) {
      if (model.keyword == keyword) {
        setState(() {
          searchModel = model;
        });
      }
    }).catchError((error) {
      print(error);
    });
  }
}