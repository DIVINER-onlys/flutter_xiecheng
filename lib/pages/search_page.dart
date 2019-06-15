import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/widget/search_bar.dart' show SearchBar;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
          )
        ],
      ),
    );
  }

  _onTextChange (text) {
    print(text);
  }
}