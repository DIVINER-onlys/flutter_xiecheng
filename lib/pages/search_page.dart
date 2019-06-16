import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/dao/search_dao.dart' show SearchDao;
import 'package:flutter_xiecheng/model/search_model.dart' show SearchModel, SearchItem;
import 'package:flutter_xiecheng/widget/search_bar.dart' show SearchBar;
import 'package:flutter_xiecheng/widget/webview.dart' show WebView;

const URL = 'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';
const TYPES = [
  'channelgroup',
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];

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

  // listview中的item
  Widget _item (int index) {
    if (searchModel==null||searchModel.data==null) {
      return null;
    }
    SearchItem item = searchModel.data[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (Context) => WebView(url: item.url, title: '详情',)
        ));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey))
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(2),
              child: Image(
                height: 26,
                width: 26,
                image: AssetImage(_typeImage(item.type)),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: 300,
                  child: _title(item)
                  // Text(
                  //   '${item.word} ${item.districtname??''} ${item.zonename??''}'
                  // ),
                ),
                Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 5),
                  child: subTitle(item)
                  // Text(
                  //   '${item.price??''} ${item.type??''}'
                  // ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // 输入框值变化回调
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

  // 返回本地图片路径
  _typeImage(String type) {
    if (type == null) {
      return 'assets/images/type_travelgroup.png';
    }
    String path = 'travelgroup';
    for (final val in TYPES) {
      if (type.contains(val)) {
        path = val;
        break;
      }
    }
    return 'assets/images/type_$path.png';
  }

  _title(SearchItem item) {
    if (item == null) {
      return null;
    }
    List<TextSpan> spans = [];
    spans.addAll(_keywordTextSpan(item.word, searchModel.keyword));
    spans.add(
      TextSpan(
        text: ' ' + item.districtname??'' + ' ' + item.zonename??'',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey
        )
      ),
    );

    return RichText(text: TextSpan(children: spans),);
  }

  subTitle(SearchItem item) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: item.price??'',
            style: TextStyle(
              fontSize: 16,
              color: Colors.orange
            )
          ),
          TextSpan(
            text: ' ' + (item.star??''),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey
            )
          )
        ]
      ),
    );
  }

  _keywordTextSpan(String word, String keyword) {
    List<TextSpan> spans = [];
    if(word == null || word.length == 0) {
      return spans;
    }

    List<String> arr = word.split(keyword);
    TextStyle normalStyle = TextStyle(fontSize: 16, color: Colors.black87);
    TextStyle keywordStyle = TextStyle(fontSize: 16, color: Colors.orange);
    // 'wordwoc'.split('w') => [, ord, oc]
    for(int i=0; i<arr.length; i++) {
      if ((i+1)%2 == 0) {
        spans.add(TextSpan(text: keyword, style: keywordStyle));
      }
      String val = arr[i];
      if(val != null && val.length > 0) {
        spans.add(TextSpan(text: val, style: normalStyle));
      }
    }
    return spans;
  }
}