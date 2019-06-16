import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/dao/search_dao.dart' show SearchDao;
import 'package:flutter_xiecheng/model/search_model.dart' show SearchModel;
import 'package:flutter_xiecheng/widget/search_bar.dart' show SearchBar;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String showText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('搜索'),
      ),
      body: Column(
        children: <Widget>[
          SearchBar(
            hideLeft: true,
            defaultText: '啊哈哈',
            hint: '123',
            leftButtonClick: (){
              Navigator.pop(context);
            },
            onChanged: _onTextChange,
          ),
          InkWell(
            onTap: (){
              SearchDao.fetch('https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=长城')
              .then((SearchModel value) {
                setState(() {
                  showText = value.data[0].url;
                });
              });
            },
            child: Text('data'),
          ),
          Text(showText)
        ],
      ),
    );
  }

  _onTextChange (text) {
    print(text);
  }
}